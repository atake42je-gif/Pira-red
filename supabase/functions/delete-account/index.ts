// Deletes the authenticated user's account. Service-role key stays server-side.
const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, apikey, content-type, x-client-info",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { ...cors, "Content-Type": "application/json" } });

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "POST") return json({ error: "Método no permitido" }, 405);
  const url = Deno.env.get("SUPABASE_URL");
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const auth = req.headers.get("Authorization") || "";
  if (!url || !serviceKey || !auth.startsWith("Bearer ")) return json({ error: "Configuración o sesión inválida" }, 401);
  try {
    const userResponse = await fetch(`${url}/auth/v1/user`, {
      headers: { apikey: serviceKey, Authorization: auth },
    });
    if (!userResponse.ok) return json({ error: "La sesión no es válida o venció" }, 401);
    const user = await userResponse.json();
    if (!user?.id) return json({ error: "No se pudo identificar la cuenta" }, 401);
    const deleteResponse = await fetch(`${url}/auth/v1/admin/users/${encodeURIComponent(user.id)}`, {
      method: "DELETE",
      headers: { apikey: serviceKey, Authorization: `Bearer ${serviceKey}` },
    });
    if (!deleteResponse.ok) {
      const detail = await deleteResponse.text();
      console.error("Account deletion failed", deleteResponse.status, detail);
      return json({ error: "No se pudo eliminar la cuenta. Contactá al soporte." }, 502);
    }
    return json({ ok: true });
  } catch (error) {
    console.error("Account deletion error", error);
    return json({ error: "Error interno al eliminar la cuenta" }, 500);
  }
});
