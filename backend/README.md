# Backend de pagos de PiraRed (base inicial)

Este directorio contiene el esquema de Supabase y un receptor de notificaciones de Mercado Pago. **Todavía no está activo**: el APK actual necesita un proyecto Supabase configurado y desplegado antes de recibir pagos reales.

## Qué hace el webhook
- Verifica la firma HMAC de Mercado Pago (`x-signature` y `x-request-id`).
- Consulta el pago directamente a la API de Mercado Pago.
- Compara importe y moneda con la orden almacenada en el servidor.
- Activa una promoción solo si el estado del proveedor es `approved`.
- Rechaza IDs de pago reutilizados y registra vencimiento de la promoción.

## Pasos necesarios antes de cobrar
1. Crear un proyecto Supabase y ejecutar `supabase/migrations/202610230001_pirared_promotions.sql` en SQL Editor.
2. Desplegar `supabase/functions/mercadopago-webhook` con Supabase CLI.
3. Configurar en el servidor `MP_ACCESS_TOKEN`, `MP_WEBHOOK_SECRET`, `SUPABASE_URL` y `SUPABASE_SERVICE_ROLE_KEY`. Nunca guardar secretos en APK, HTML ni repositorio.
4. Configurar la URL HTTPS de la función en Mercado Pago como webhook de pagos.
5. Crear el endpoint autenticado que genera órdenes y preferencias de pago; debe comprobar que la publicación pertenece al usuario y obtener precio/duración del servidor.
6. Probar pagos aprobados, pendientes, rechazados, firma inválida, importes alterados, duplicados y vencimientos antes de aceptar dinero real.

El webhook no crea cobros ni órdenes por sí solo. No mostrar una promoción como pagada hasta que el backend la confirme. Este repositorio no contiene credenciales ni una URL desplegada, por lo que esta base **no significa que los pagos ya funcionen**.
