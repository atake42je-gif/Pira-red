// Deletes the authenticated user's account and its private storage objects.
// Service-role credentials are used only on the server.
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
    const userResponse = await fetch(`${url}/auth/v1/user`, { headers: { apikey: serviceKey, Authorization: auth } });
    if (!userResponse.ok) return json({ error: "La sesión no es válida o venció" }, 401);
    const user = await userResponse.json();
    if (!user?.id) return json({ error: "No se pudo identificar la cuenta" }, 401);

    // Remove the user's files first, so account deletion does not leave orphaned photos.
    const listResponse = await fetch(`${url}/storage/v1/object/list/community-images`, {
      method: "POST",
      headers: { apikey: serviceKey, Authorization: `Bearer ${serviceKey}`, "Content-Type": "application/json" },
      body: JSON.stringify({ prefix: user.id, limit: 1000, offset: 0 }),
    });
    if (!listResponse.ok) {
      console.error("Could not list user images", listResponse.status, await listResponse.text());
      return json({ error: "No se pudieron preparar los archivos para borrar la cuenta." }, 502);
    }
    const files = await listResponse.json();
    const paths = (Array.isArray(files) ? files : []).map((file: { name?: string }) => file.name ? `${user.id}/${file.name}` : null).filter(Boolean);
    if (paths.length) {
      const removeResponse = await fetch(`${url}/storage/v1/object/community-images`, {
        method: "DELETE",
        headers: { apikey: serviceKey, Authorization: `Bearer ${serviceKey}`, "Content-Type": "application/json" },
        body: JSON.stringify({ prefixes: paths }),
      });
      if (!removeResponse.ok) {
        console.error("Could not remove user images", removeResponse.status, await removeResponse.text());
        return json({ error: "No se pudieron eliminar las fotos de tu cuenta." }, 502);
      }
    }

    const deleteResponse = await fetch(`${url}/auth/v1/admin/users/${encodeURIComponent(user.id)}`, {
      method: "DELETE",
      headers: { apikey: serviceKey, Authorization: `Bearer ${serviceKey}` },
    });
    if (!deleteResponse.ok) {
      console.error("Account deletion failed", deleteResponse.status, await deleteResponse.text());
      return json({ error: "No se pudo eliminar la cuenta. Contactá al soporte." }, 502);
    }
    return json({ ok: true });
  } catch (error) {
    console.error("Account deletion error", error);
    return json({ error: "Error interno al eliminar la cuenta" }, 500);
  }
});
