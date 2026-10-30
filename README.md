# PiraRed

Aplicación Android comunitaria para Pirané, Formosa. El proyecto usa una interfaz web local dentro de Android WebView y Supabase para autenticación y datos.

## Funciones incluidas en el código actual

- Portada original con tres accesos independientes: iniciar sesión, crear cuenta y acceso exclusivo para comercios.
- Navegación entre pantallas sin apilar contenido.
- Registro por correo, inicio/cierre de sesión y recuperación de contraseña mediante Supabase Auth.
- Perfil básico del usuario.
- Publicaciones comunitarias para Compra / Venta, Trabajos y Servicios.
- Envío de publicaciones a moderación; solo las aprobadas se consultan en el feed público.
- Solicitud de alta de comercios y anuncios básicos gratuitos sujetos a aprobación.
- Mensajes privados entre participantes, sin publicar teléfonos.
- Guardados locales en el dispositivo.
- Panel de revisión para cuentas con rol administrador.
- Diseño adaptable, fotos locales de Pirané y controles táctiles.

## Backend Supabase

Proyecto configurado: `slgqcrcktczuvmivwdst` (región `us-east-1`).

Tablas existentes verificadas: `profiles`, `businesses`, `ads`, `community_posts`, `private_messages`, `user_reports`, `user_blocks` y `payment_orders`. Las tablas públicas verificadas tienen RLS activado. El cliente incluye únicamente una clave publicable; nunca agregar una clave service-role o secret a la APK.

La base de datos contiene las migraciones de comercios, anuncios, publicaciones, mensajes privados, denuncias y bloqueos. Las funciones Edge de pagos no están desplegadas actualmente. Por eso los anuncios destacados pagos permanecen deshabilitados; el flujo disponible es el anuncio básico gratuito.

## Pendientes obligatorios antes del lanzamiento público

1. Probar en un teléfono real el registro, confirmación de correo, inicio/cierre de sesión y recuperación.
2. Probar crear publicaciones, solicitudes de comercios, aprobación administrativa, anuncios y mensajes con dos cuentas de prueba distintas.
3. Probar permisos RLS con cuentas anónimas, usuarios normales y administrador.
4. Verificar visualmente la portada y sus zonas táctiles en el Moto G51 y al menos otro tamaño de pantalla.
5. Configurar una firma Android privada y estable en GitHub Secrets para que las actualizaciones se instalen sobre versiones previas. Sin esos secretos, Actions genera una APK debug que puede requerir desinstalar la versión anterior.
6. Completar los datos del responsable y el correo de privacidad, revisar legalmente y aprobar los borradores de [Política de privacidad](docs/POLITICA-PRIVACIDAD-BORRADOR.md) y [Términos de uso](docs/TERMINOS-BORRADOR.md).
7. Habilitar protección de contraseñas filtradas en Supabase Auth. El asesor de seguridad del proyecto la reporta desactivada.
8. Definir un procedimiento real de eliminación de cuentas y datos.
9. Si se quieren publicaciones con fotos, configurar un bucket de Storage con políticas de acceso antes de habilitar cargas de imágenes.
10. Si se quieren anuncios destacados pagos, desplegar y probar el flujo de cobro y webhook; no aceptar pagos desde un botón que no verifique el pago en servidor.

## Compilar

GitHub Actions ejecuta el workflow `.github/workflows/build APK.yml` al recibir cambios en `main`. También se puede iniciar manualmente desde la pestaña Actions.

La compilación genera `dist/PiraRed.apk` y la publica como artefacto. En builds sin los secretos de firma, se trata de una APK de prueba.

## Enlaces

- [Repositorio](https://github.com/atake42je-gif/Pira-red)
- [Acciones y compilaciones](https://github.com/atake42je-gif/Pira-red/actions)
- [Versiones descargables](https://github.com/atake42je-gif/Pira-red/releases)

**Estado honesto:** las pantallas y conexiones principales ya están incorporadas al código, pero no se debe anunciar PiraRed como lanzamiento público hasta completar las pruebas de dispositivo, la firma estable y los pendientes de privacidad/seguridad enumerados arriba.
