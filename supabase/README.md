# PiraRed — estado del backend y publicación

## Funciones conectadas
- Registro e inicio de sesión con Supabase Auth, confirmación por correo y recuperación de contraseña.
- Perfiles privados con políticas RLS.
- Alta de comercios en estado pendiente.
- Envío de promociones por comercios aprobados.
- Listado público limitado a promociones y comercios aprobados.
- Moderación de anuncios mediante políticas de base de datos; el cliente no incluye botones públicos para aprobar anuncios.
- Las claves de servicio no deben incluirse en la APK. La interfaz usa únicamente una clave publicable.

## Funciones todavía no listas para lanzamiento completo
- Publicaciones comunitarias de productos, changas y servicios.
- Mensajería privada entre vecinos.
- Panel administrativo dentro de la aplicación, denuncias y bloqueo de usuarios.
- Política de privacidad y condiciones revisadas para el lanzamiento público.
- Pruebas funcionales de registro/correo en el dispositivo y revisión final de RLS en el proyecto de producción.

La interfaz informa cuando estas funciones no están disponibles y no simula envíos de anuncios ni aprobaciones administrativas.

## Configuración de Supabase

La interfaz apunta al proyecto `https://slgqcrcktczuvmivwdst.supabase.co` y usa una clave publicable. El proyecto activo tiene tablas `profiles`, `businesses`, `ads`, `payment_orders` y `community_posts`, todas con RLS activado. La migración de publicaciones comunitarias es `202610250001_pirared_community_posts.sql`. Se verificó el estado de los asesores de seguridad de Supabase y no devolvieron alertas en la última consulta; esto no reemplaza las pruebas funcionales ni una revisión de permisos completa.

Para el primer administrador, registrá y confirmá una cuenta y luego asigná el rol `admin` manualmente en SQL Editor usando su UUID real. Nunca permitas que el formulario público establezca el rol de administrador.

## APK y firma
El workflow compila y valida el APK. Sin los secretos de firma de Android, genera una APK de depuración. Para publicar y permitir actualizaciones consistentes en dispositivos existentes, configurá una clave de firma privada estable en GitHub Actions Secrets (`ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`). No compartas ni subas la clave privada al repositorio.

## Antes de anunciar el lanzamiento
1. Confirmá que la migración y RLS están activas en el proyecto correcto.
2. Probá registro, confirmación de correo, inicio de sesión, recuperación y envío de una promoción con cuentas de prueba.
3. Aprobá el comercio y el anuncio con una cuenta administradora separada y verificá que solo lo aprobado sea visible.
4. Agregá y probá las funciones comunitarias y de mensajería si forman parte del alcance inicial.
5. Publicá una política de privacidad y condiciones adecuadas a la operación en Argentina.
6. Generá la APK firmada con la clave estable y probá la actualización en un dispositivo limpio y otro con la versión anterior.
