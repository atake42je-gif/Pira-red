import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

async function hmacSha256Hex(secret: string, message: string): Promise<string> {
  const encoder = new TextEncoder();
  const key = await crypto.subtle.importKey(
    "raw", encoder.encode(secret), { name: "HMAC", hash: "SHA-256" }, false, ["sign"],
  );
  const signature = await crypto.subtle.sign("HMAC", key, encoder.encode(message));
  return Array.from(new Uint8Array(signature), (b) => b.toString(16).padStart(2, "0")).join("");
}

function constantTimeEqual(a: string, b: string): boolean {
  if (a.length !== b.length) return false;
  let diff = 0;
  for (let i = 0; i < a.length; i++) diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return diff === 0;
}

Deno.serve(async (req) => {
  if (req.method !== "POST" && req.method !== "GET") return json({ error: "Método no permitido" }, 405);

  try {
    const mpSecret = Deno.env.get("MP_WEBHOOK_SECRET");
    const accessToken = Deno.env.get("MP_ACCESS_TOKEN");
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!mpSecret || !accessToken || !supabaseUrl || !serviceKey) {
      return json({ error: "Configuración del servidor incompleta" }, 503);
    }

    const url = new URL(req.url);
    const paymentId = url.searchParams.get("data.id") ?? url.searchParams.get("id");
    const topic = url.searchParams.get("type") ?? url.searchParams.get("topic");
    if (!paymentId || (topic && topic !== "payment")) return json({ received: true, ignored: true });

    const signatureHeader = req.headers.get("x-signature") ?? "";
    const requestId = req.headers.get("x-request-id") ?? "";
    const parts = Object.fromEntries(signatureHeader.split(",").map((part) => {
      const index = part.indexOf("=");
      return index > 0 ? [part.slice(0, index).trim(), part.slice(index + 1).trim()] : ["", ""];
    }).filter(([key]) => key));
    const ts = parts.ts;
    const v1 = parts.v1;
    if (!ts || !v1 || !requestId) return json({ error: "Firma ausente" }, 401);

    // Manifesto de firma de Mercado Pago para notificaciones de pago.
    const manifest = `id:${paymentId.toLowerCase()};request-id:${requestId};ts:${ts};`;
    const expected = await hmacSha256Hex(mpSecret, manifest);
    if (!constantTimeEqual(expected, v1.toLowerCase())) return json({ error: "Firma inválida" }, 401);

    const paymentResponse = await fetch(
      `https://api.mercadopago.com/v1/payments/${encodeURIComponent(paymentId)}`,
      { headers: { Authorization: `Bearer ${accessToken}` } },
    );
    if (!paymentResponse.ok) return json({ error: "No se pudo verificar el pago con Mercado Pago" }, 502);
    const payment = await paymentResponse.json();

    const orderId = payment.external_reference;
    if (!orderId || !/^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(orderId)) {
      return json({ received: true, ignored: true });
    }

    const admin = createClient(supabaseUrl, serviceKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });
    const { data: order, error: orderError } = await admin
      .from("payment_orders")
      .select("id, amount_ars, currency, status")
      .eq("id", orderId)
      .maybeSingle();
    if (orderError) {
      console.error("No se pudo consultar la orden", orderError.message);
      return json({ error: "Error al consultar la orden" }, 500);
    }
    if (!order) return json({ received: true, ignored: true });

    // No aceptar moneda o importe distintos a la orden guardada en el servidor.
    if (payment.currency_id !== "ARS" || Number(payment.transaction_amount) !== order.amount_ars) {
      console.error("Importe/moneda no coinciden con la orden", orderId);
      return json({ error: "El importe o la moneda no coinciden" }, 409);
    }

    const mpStatus = String(payment.status ?? "");
    const nextStatus = mpStatus === "approved" ? "approved"
      : mpStatus === "rejected" ? "rejected"
      : mpStatus === "cancelled" ? "cancelled"
      : "pending";

    // No degradar una orden ya aprobada por notificaciones tardías.
    if (order.status === "approved") return json({ received: true, already_processed: true });
    const update: Record<string, unknown> = {
      status: nextStatus,
      mp_payment_id: String(payment.id),
      updated_at: new Date().toISOString(),
    };
    if (nextStatus === "approved") update.approved_at = payment.date_approved ?? new Date().toISOString();

    const { error: updateError } = await admin.from("payment_orders").update(update).eq("id", orderId);
    if (updateError) {
      console.error("No se pudo actualizar la orden", updateError.message);
      return json({ error: "No se pudo actualizar la orden" }, 500);
    }

    // Importante: esto registra el pago. La activación del anuncio/publicación debe
    // conectarse a las tablas reales del producto antes de habilitar ventas en producción.
    return json({ received: true, status: nextStatus });
  } catch (error) {
    console.error("Error en webhook", error instanceof Error ? error.message : "desconocido");
    return json({ error: "Error interno" }, 500);
  }
});
