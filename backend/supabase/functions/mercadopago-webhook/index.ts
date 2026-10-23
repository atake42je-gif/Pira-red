import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

function safeEqual(a: string, b: string): boolean {
  if (a.length !== b.length) return false;
  let result = 0;
  for (let i = 0; i < a.length; i++) result |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return result === 0;
}
async function hmacHex(secret: string, value: string): Promise<string> {
  const key = await crypto.subtle.importKey("raw", new TextEncoder().encode(secret),
    { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
  const signature = await crypto.subtle.sign("HMAC", key, new TextEncoder().encode(value));
  return Array.from(new Uint8Array(signature), b => b.toString(16).padStart(2, "0")).join("");
}
Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok");
  if (req.method !== "POST") return new Response("Method not allowed", { status: 405 });
  const mpToken = Deno.env.get("MP_ACCESS_TOKEN");
  const secret = Deno.env.get("MP_WEBHOOK_SECRET");
  const url = Deno.env.get("SUPABASE_URL");
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!mpToken || !secret || !url || !serviceKey) {
    console.error("Webhook configuration missing");
    return Response.json({ error: "server_not_configured" }, { status: 503 });
  }
  try {
    const body = await req.json();
    const paymentId = String(body?.data?.id ?? "");
    const requestId = req.headers.get("x-request-id") ?? "";
    const signature = req.headers.get("x-signature") ?? "";
    const parts: Record<string, string> = {};
    for (const part of signature.split(",")) {
      const pair = part.trim().split("=");
      if (pair.length === 2) parts[pair[0]] = pair[1];
    }
    if (!/^\d+$/.test(paymentId) || !requestId || !parts.ts || !parts.v1) {
      return Response.json({ error: "invalid_signature_headers" }, { status: 401 });
    }
    const manifest = "id:" + paymentId + ";request-id:" + requestId + ";ts:" + parts.ts + ";";
    const expected = await hmacHex(secret, manifest);
    if (!safeEqual(expected.toLowerCase(), parts.v1.toLowerCase())) {
      return Response.json({ error: "invalid_signature" }, { status: 401 });
    }

    const response = await fetch("https://api.mercadopago.com/v1/payments/" + encodeURIComponent(paymentId), {
      headers: { Authorization: "Bearer " + mpToken, Accept: "application/json" },
    });
    if (!response.ok) {
      console.error("Provider payment verification failed", response.status);
      return Response.json({ error: "provider_verification_failed" }, { status: 502 });
    }
    const payment = await response.json();
    const orderId = String(payment.external_reference ?? "");
    if (!/^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(orderId)) {
      return Response.json({ error: "invalid_external_reference" }, { status: 400 });
    }

    const db = createClient(url, serviceKey, { auth: { persistSession: false, autoRefreshToken: false } });
    const { data: order, error: lookupError } = await db.from("promotion_orders").select("*").eq("id", orderId).maybeSingle();
    if (lookupError || !order) return Response.json({ error: "order_not_found" }, { status: 404 });
    const amount = Number(payment.transaction_amount);
    if (payment.currency_id !== order.currency || !Number.isFinite(amount) || Math.abs(amount - Number(order.amount)) > 0.009) {
      console.error("Payment/order mismatch", { orderId });
      return Response.json({ error: "payment_order_mismatch" }, { status: 409 });
    }

    if (payment.status !== "approved") {
      if (["rejected", "cancelled", "refunded", "charged_back"].includes(payment.status)) {
        await db.from("promotion_orders").update({ status: "rejected" }).eq("id", orderId).eq("status", "pending");
      }
      return Response.json({ received: true, activated: false });
    }
    const { data: linked } = await db.from("promotion_orders").select("id").eq("provider_payment_id", paymentId).maybeSingle();
    if (linked && linked.id !== orderId) return Response.json({ error: "payment_already_used" }, { status: 409 });
    if (order.status === "approved") {
      return Response.json({ received: true, activated: true, duplicate: true });
    }
    if (order.status !== "pending") return Response.json({ error: "order_not_pending" }, { status: 409 });

    const approvedAt = new Date().toISOString();
    const expiresAt = new Date(Date.now() + Number(order.duration_days) * 86400000).toISOString();
    const { data: updated, error: updateError } = await db.from("promotion_orders").update({
      status: "approved", provider_payment_id: paymentId, approved_at: approvedAt, expires_at: expiresAt,
    }).eq("id", orderId).eq("status", "pending").select("id").maybeSingle();
    if (updateError || !updated) {
      const { data: current } = await db.from("promotion_orders").select("status,provider_payment_id").eq("id", orderId).maybeSingle();
      if (current?.status === "approved" && current.provider_payment_id === paymentId) {
        return Response.json({ received: true, activated: true, duplicate: true });
      }
      console.error("Could not persist approved payment", updateError);
      return Response.json({ error: "could_not_persist_payment" }, { status: 500 });
    }
    const { error: activationError } = await db.from("listing_promotions").upsert({
      order_id: orderId, listing_id: order.listing_id, user_id: order.user_id,
      promotion_type: order.promotion_type, starts_at: approvedAt, expires_at: expiresAt, active: true,
    }, { onConflict: "order_id" });
    if (activationError) {
      console.error("Payment verified but promotion activation failed", activationError);
      return Response.json({ error: "promotion_activation_failed" }, { status: 500 });
    }
    return Response.json({ received: true, activated: true });
  } catch (error) {
    console.error("Webhook processing error", error);
    return Response.json({ error: "internal_error" }, { status: 500 });
  }
});
