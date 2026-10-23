# PiraRed — pagos con Mercado Pago + Supabase

Esta carpeta agrega una **base de integración**, no una activación de pagos lista para producción. No contiene claves secretas y no activa publicaciones/anuncios: eso requiere conectar estas órdenes con las tablas reales de publicaciones y publicidad de PiraRed.

## Qué incluye

- Migración SQL para órdenes de pago en ARS, con RLS para que cada usuario autenticado solo lea sus propias órdenes.
- `create-payment-preference`: crea una orden con precio decidido por variables del servidor y solicita una preferencia de Checkout Pro.
- `mercadopago-webhook`: valida la firma HMAC, consulta el pago directamente a la API de Mercado Pago y compara importe/moneda antes de actualizar la orden.

## Requisitos antes de probar

1. Crear un proyecto Supabase y ejecutar el SQL de `migrations/20261023000100_pirared_payments.sql` desde SQL Editor.
2. Instalar/configurar Supabase CLI localmente y desplegar las funciones:
   - `supabase functions deploy create-payment-preference` (requiere JWT de Supabase).
   - `supabase functions deploy mercadopago-webhook --no-verify-jwt` (endpoint público, protegido por firma HMAC).
3. Configurar secretos **solo en Supabase**, nunca en el APK ni en GitHub:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY` (secreto)
   - `MP_ACCESS_TOKEN` (credencial privada de Mercado Pago)
   - `MP_WEBHOOK_SECRET` (clave de firma de Webhooks de Mercado Pago)
   - `MP_WEBHOOK_URL` (URL HTTPS de la función webhook desplegada)
   - `PIRARED_RETURN_URL` (URL HTTPS de retorno configurada para Checkout Pro)
   - `PIRARED_ALLOWED_ORIGIN` (origen permitido; reemplazar el valor abierto por el dominio final)
   - `PIRARED_PRICE_FEATURED_7D_ARS` y `PIRARED_PRICE_AD_7D_ARS` (precios enteros en pesos, elegidos por el administrador)
4. En el panel de Mercado Pago, configurar Webhooks para eventos de pagos y copiar el secreto de firma a `MP_WEBHOOK_SECRET`.
5. Probar primero con credenciales y usuarios de prueba, y confirmar pagos aprobados, rechazados, pendientes, firmas inválidas y notificaciones repetidas.

## Llamar a crear preferencia

Desde una sesión autenticada de Supabase, enviar POST a la función con el encabezado `Authorization: Bearer <JWT_DEL_USUARIO>` y JSON:
```json
{ "product_type": "featured_post_7d" }
```
o
```json
{ "product_type": "advertising_7d" }
```

La respuesta incluye `checkout_url`, `order_id`, `amount_ars` y `currency`. El importe no se acepta desde el teléfono; lo fija la configuración del servidor.

## Pendiente antes de vender

- Añadir autenticación real de usuarios en PiraRed y obtener el JWT de Supabase de forma segura.
- Conectar el flujo de compra de la interfaz a `create-payment-preference`.
- Crear la lógica de activación y vencimiento de publicaciones destacadas/anuncios después de verificar el pago aprobado.
- Añadir conciliación/reembolsos y pruebas de integración.
- Configurar un origen CORS concreto, URLs reales y secretos de producción.
- Revisar el modelo de amenazas, límites y requisitos comerciales de Mercado Pago/Supabase antes de lanzar.

**No activar ventas reales hasta completar los puntos pendientes y probar la integración.**
