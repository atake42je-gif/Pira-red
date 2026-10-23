# PiraRed — backend de comercios y publicidad

## Qué prepara esta carpeta
- Esquema SQL para perfiles, comercios y anuncios.
- Políticas RLS: los visitantes solo leen comercios/anuncios aprobados; los comercios crean anuncios pendientes; la revisión queda reservada a usuarios con rol admin.
- Tipo de anuncio `basic` gratis y `featured` para destacar. El cobro no está implementado ni se almacena información de tarjetas.

## Configuración necesaria (Supabase)
1. Crear un proyecto en Supabase.
2. Abrir **SQL Editor** y ejecutar `supabase/migrations/202610230001_pirared_commerce_ads.sql`.
3. Registrar tu cuenta mediante el sistema de autenticación de Supabase y confirmar tu identidad.
4. En SQL Editor, consultar tu usuario y su perfil para encontrar el UUID correcto. Después asignar el rol admin con la instrucción comentada al final de la migración, sustituyendo el marcador por el UUID real. Nunca otorgues el rol admin desde el formulario público.
5. Configurar autenticación y correo de confirmación. Activar protección contra contraseñas filtradas si está disponible.
6. Guardar la URL del proyecto y la clave publicable/anon en la configuración de la app. **Nunca poner la service_role key en el APK, HTML, repositorio o capturas.**
7. Conectar la interfaz Android/WebView a Supabase Auth y a las tablas. Hasta terminar y probar este paso, los formularios actuales siguen siendo una demostración local.

## Reglas de seguridad
- La base de datos fuerza aprobación antes de hacer visibles los anuncios.
- Las políticas RLS son la barrera de acceso; ocultar botones en la interfaz no es seguridad.
- La política no habilita cobros. Los anuncios destacados deben aprobarse manualmente y activarse comercialmente solo cuando se defina precio y proveedor de pago.
- Probar con cuentas separadas de comerciante y administrador antes de publicar.
