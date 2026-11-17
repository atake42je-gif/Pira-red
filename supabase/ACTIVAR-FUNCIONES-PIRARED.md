# Activación de funciones nuevas de PiraRed

Los archivos de esta carpeta ya están versionados, pero las migraciones SQL y Edge Functions no se despliegan automáticamente al compilar Android. Para activar las funciones en el proyecto Supabase `slgqcrcktczuvmivwdst`:

## 1. Activar fotos de publicaciones

En Supabase Dashboard → SQL Editor, ejecutar el contenido completo de:

`supabase/migrations/202611170001_pirared_community_images.sql`

Crea el bucket público `community-images`, limita cada archivo a 5 MB y permite únicamente JPEG, PNG y WebP. Las reglas permiten leer fotos y subir, actualizar o borrar solo archivos dentro de la carpeta del usuario autenticado.

## 2. Activar eliminación de cuenta

Desde la raíz del repositorio, con Supabase CLI autenticado y vinculado al proyecto:

```bash
supabase link --project-ref slgqcrcktczuvmivwdst
supabase functions deploy delete-account
```

La función usa `SUPABASE_URL` y `SUPABASE_SERVICE_ROLE_KEY` del entorno seguro de Supabase. No copiar la service-role key al HTML, APK, GitHub ni al teléfono. La función valida el token del usuario, elimina las fotos propias y luego borra la cuenta mediante Auth Admin API.

## 3. Probar antes de habilitar para público

- Crear dos cuentas de prueba y confirmar ambos correos.
- Subir JPG, PNG y WebP; verificar rechazo de SVG, GIF, archivos falsos y archivos mayores de 5 MB.
- Confirmar que usuario A no pueda subir dentro de la carpeta de usuario B.
- Aprobar una publicación y comprobar que la imagen aparezca en Explorar.
- Denunciar una publicación y verificar el registro en `user_reports`.
- Bloquear un usuario y verificar que sus publicaciones desaparezcan y que la política de mensajes impida contacto.
- Eliminar una cuenta de prueba y confirmar que Auth y sus imágenes fueron eliminados.

## Límites importantes

- La app no realiza verificación de DNI ni de identidad. La confirmación de correo no equivale a identidad verificada.
- La carga de fotos requiere ejecutar la migración SQL.
- Denuncias y bloqueos requieren que la migración `202610250004_pirared_reports_and_blocks.sql` ya esté aplicada.
- La eliminación de cuenta requiere desplegar la Edge Function.
- No habilitar pagos ni cobros hasta terminar la integración y las pruebas de Mercado Pago descritas en `supabase/README-pagos.md`.
