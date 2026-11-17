# PiraRed — auditoría técnica y estado de pruebas

Fecha de actualización: 17 de noviembre de 2026  
Rama: `main`  
Cambios visuales: `422a2773e1bb364841bd7f7784e1b5ce5458f584` y `363e06e1e66393b58c0adb568843d8b1af398912`  
Validaciones CI ampliadas: `2fd0084849e1c7fb56b1c165bd9d85e631c436ce`

## Mejoras aplicadas en el código

- Portada de bienvenida cambiada a la imagen vertical original de PiraRed con el paisaje al atardecer y la identidad visual completa.
- Portada adaptada con `object-fit: cover`, conservando proporciones; puede recortar bordes proporcionalmente según el formato de pantalla, nunca estira la fotografía.
- Botones de acceso ubicados como controles reales sobre la portada, sin duplicar el logo y el lema que ya forman parte de la imagen.
- Pantallas interiores simplificadas a un fondo claro para mejorar contraste y lectura.
- Tarjetas con fotografía ordenadas para que la miniatura conserve proporción y el texto no se superponga.
- Panel de administración ampliado para mostrar denuncias pendientes y marcarlas en revisión o resueltas.
- La interfaz ya incluye selector de imagen JPG/PNG/WebP (máximo 5 MB), carga al bucket `community-images`, denuncia, bloqueo y solicitud de eliminación de cuenta.

## Backend y migraciones

- Existe la migración `supabase/migrations/202611170001_pirared_community_images.sql`, que agrega `image_url`, crea el bucket público y define políticas de lectura/carga/borrado.
- La carga se restringe al directorio cuyo primer segmento es el UUID del usuario autenticado.
- La función Edge `supabase/functions/delete-account/index.ts` elimina objetos del bucket y luego elimina la cuenta autenticada con credenciales de servidor.
- Las migraciones y funciones guardadas en GitHub no significan que estén aplicadas/desplegadas en el proyecto Supabase. Hay que confirmar su estado real en el panel de Supabase.

## Pruebas estáticas incorporadas a CI

El workflow ahora verifica:
- HTML sin IDs duplicados y recursos locales existentes.
- Sintaxis de JavaScript con `node --check`.
- Presencia de los siete formularios principales y sus manejadores.
- Presencia de los flujos de carga de fotos, denuncia, bloqueo y eliminación de cuenta.
- Existencia de la portada vertical y de la migración del bucket de imágenes.
- Uso de reglas de imagen que evitan deformaciones.

## Resultado de compilación anterior comprobado

La ejecución [#44042024779](https://github.com/atake42je-gif/Pira-red/actions/runs/44042024779) terminó correctamente y generó una APK DEBUG. Esa ejecución es anterior a las últimas mejoras visuales y al conjunto ampliado de validaciones; no debe usarse como certificación de los cambios nuevos.

## Pendientes para aprobar el lanzamiento

1. Ejecutar y aprobar el nuevo workflow que se dispara con los últimos commits.
2. Aplicar y verificar la migración de fotos en el proyecto Supabase activo; comprobar carga real, lectura pública y borrado de imágenes con cuentas de prueba.
3. Desplegar la función Edge `delete-account` con `SUPABASE_SERVICE_ROLE_KEY` configurada únicamente como secreto del servidor y probar eliminación completa.
4. Probar registro, confirmación de correo, inicio, cierre, renovación y recuperación de contraseña desde un dispositivo Android real.
5. Probar dos usuarios normales y un administrador: publicación, aprobación, mensajes privados, denuncia, bloqueo y permisos RLS. Verificar que el bloqueo funcione en ambos sentidos.
6. Verificar que el panel de denuncias admin reciba y cierre reportes sin exponer datos a otros usuarios.
7. Habilitar la protección contra contraseñas filtradas en Supabase Auth.
8. Completar datos reales del responsable y correo de privacidad; revisar legalmente política y términos antes de publicarlos.
9. Configurar los secretos de firma release y validar que la APK release conserva la misma firma de futuras actualizaciones.
10. No habilitar pagos ni destacados hasta desplegar y probar íntegramente el endpoint de creación de preferencias y el webhook de Mercado Pago.

## Veredicto

Hay mejoras reales implementadas y validaciones estáticas más completas, pero aún no se certificaron los flujos de extremo a extremo en Supabase ni la instalación en un teléfono físico. La app sigue **pendiente de aprobación para lanzamiento público** hasta completar los puntos anteriores.
