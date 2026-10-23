import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": Deno.env.get("PIRARED_ALLOWED_ORIGIN") ?? "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const products = {
  featured_post_7d: {
    title: "PiraRed — Publicación destacada por 7 días",
    priceEnv: "PIRARED_PRICE_FEATURED_7D_ARS",
  },
  advertising_7d: {
    title: "PiraRed — Publicidad por 7 días",
    priceEnv: "PIRARED_PRICE_AD_7D_ARS",
  },
} as const;

function response(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return response({ error: "Método no permitido" }, 405);

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    const accessToken = Deno.env.get("MP_ACCESS_TOKEN");
    const webhookUrl = Deno.env.get("MP_WEBHOOK_URL");
    const appReturnUrl = Deno.env.get("PIRARED_RETURN_URL");

    if (!supabaseUrl || !anonKey || !serviceKey || !accessToken || !webhookUrl || !appReturnUrl) {
      return response({ error: "Configuración del servidor incompleta" }, 503);
    }

    const authHeader = req.headers.get("Authorization");
    if (!authHeader?.startsWith("Bearer ")) return response({ error: "Iniciá sesión para pagar" }, 401);

    const userClient = createClient(supabaseUrl, anonKey, {
      global: { headers: { Authorization: authHeader } },
      auth: { persistSession: false, autoRefreshToken: false },
    });
    const { data: { user }, error: userError } = await userClient.auth.getUser();
    if (userError || !user) return response({ error: "Sesión inválida" }, 401);

    const body = await req.json().catch(() => null);
    const productType = body?.product_type as keyof typeof products;
    if (!productType || !(productType in products)) {
      return response({ error: "Producto no válido" }, 400);
    }

    const product = products[productType];
    const rawPrice = Deno.env.get(product.priceEnv);
    const amount = rawPrice && /^\d+$/.test(rawPrice) ? Number(rawPrice) : 0;
    if (!Number.isSafeInteger(amount) || amount < 1) {
      return response({ error: `Falta configurar el precio del producto en ARS: ${product.priceEnv}` }, 503);
    }

    const admin = createClient(supabaseUrl, serviceKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });
    const { data: order, error: insertError } = await admin
      .from("payment_orders")
      .insert({ user_id: user.id, product_type: productType, amount_ars: amount, currency: "ARS" })
      .select("id, amount_ars, product_type")
      .single();
    if (insertError || !order) {
      console.error("No se pudo crear la orden", insertError?.message);
      return response({ error: "No se pudo crear la orden de pago" }, 500);
    }

    const preferenceBody = {
      items: [{
        id: order.id,
        title: product.title,
        quantity: 1,
        currency_id: "ARS",
        unit_price: amount,
      }],
      external_reference: order.id,
      notification_url: webhookUrl,
      back_urls: {
        success: appReturnUrl,
        pending: appReturnUrl,
        failure: appReturnUrl,
      },
      auto_return: "approved",
      metadata: { order_id: order.id, user_id: user.id, product_type: productType },
    };

    const mpResponse = await fetch("https://api.mercadopago.com/checkout/preferences", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Content-Type": "application/json",
        "X-Idempotency-Key": order.id,
      },
      body: JSON.stringify(preferenceBody),
    });
    const preference = await mpResponse.json().catch(() => ({}));
    if (!mpResponse.ok || !preference.id || !preference.init_point) {
      console.error("Mercado Pago rechazó la preferencia", mpResponse.status);
      await admin.from("payment_orders").update({ status: "rejected", updated_at: new Date().toISOString() }).eq("id", order.id);
      return response({ error: "Mercado Pago no pudo crear el pago" }, 502);
    }

    const { error: updateError } = await admin
      .from("payment_orders")
      .update({ mp_preference_id: String(preference.id), updated_at: new Date().toISOString() })
      .eq("id", order.id);
    if (updateError) {
      console.error("No se pudo guardar la preferencia", updateError.message);
      return response({ error: "No se pudo guardar la orden de pago" }, 500);
    }

    return response({ order_id: order.id, checkout_url: preference.init_point, amount_ars: amount, currency: "ARS" }, 201);
  } catch (error) {
    console.error("Error interno al crear el pago", error instanceof Error ? error.message : "desconocido");
    return response({ error: "Error interno al crear el pago" }, 500);
  }
});
