# PiraRed — estado del backend Supabase

## Proyecto activo
- Proyecto: `slgqcrcktczuvmivwdst`
- Región: `us-east-1` (Estados Unidos)
- Estado comprobado: activo y saludable.
- El cliente Android usa una clave publicable. Nunca incluir service-role/secret keys en el APK.

## Tablas comprobadas
- `profiles`: perfil básico y rol administrado.
- `businesses`: solicitudes de alta de comercios.
- `ads`: anuncios de comercios.
- `community_posts`: Compra / Venta, Trabajos y Servicios.
- `private_messages`: mensajes internos.
- `user_reports` y `user_blocks`: base de denuncias y bloqueos.
- `payment_orders`: estructura de órdenes de pago.

Las tablas públicas comprobadas tienen RLS activado. Las políticas consultadas restringen mensajes a sus participantes y bloquean mensajes entre personas que se bloquearon. El cliente nunca debe poder asignar el rol admin desde el registro.

## Funciones conectadas en la interfaz Android
- Registro, inicio/cierre de sesión y solicitud de recuperación mediante Supabase Auth.
- Perfil básico.
- Envío de publicaciones comunitarias en estado pendiente.
- Consulta pública de publicaciones aprobadas.
- Solicitud de alta de comercios en estado pendiente.
- Envío y consulta pública de anuncios aprobados.
- Mensajes privados entre el autor de una publicación y la persona interesada.
- Cola de moderación para perfiles con rol `admin`.

Los guardados se conservan localmente en el dispositivo, no en Supabase.

## Pendientes del backend y de lanzamiento
1. Probar registro, confirmación de correo, inicio de sesión y recuperación desde el APK real.
2. Probar RLS con dos cuentas normales y una cuenta admin.
3. Completar UI de denuncias y bloqueos; las tablas ya existen.
4. Configurar Storage y sus políticas si se habilitan fotos de publicaciones.
5. Habilitar la protección contra contraseñas filtradas en Auth. El asesor de seguridad la reportó desactivada.
6. Definir el procedimiento de eliminación de cuenta y datos.
7. Completar y revisar legalmente la política de privacidad y los términos de uso.
8. Las funciones Edge de pagos no están desplegadas; no activar anuncios destacados pagos hasta implementar y probar preferencia de pago y webhook.

## Primer administrador
Después de crear y confirmar la cuenta que será administradora, obtené su UUID en Supabase Auth y asigná el rol manualmente en SQL Editor. Reemplazá el marcador por el UUID correcto:

```sql
update public.profiles
set role = 'admin'
where id = 'UUID-DE-LA-CUENTA-ADMIN';
```

No agregues una opción pública para que un usuario se asigne a sí mismo el rol administrador.

## Claves
La clave publicable se puede incluir en la aplicación. Las claves secretas y service-role son privadas y nunca deben almacenarse en GitHub, HTML, JavaScript ni APK.
