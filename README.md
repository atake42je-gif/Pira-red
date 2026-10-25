# PiraRed — proyecto inicial para continuar desde Android

**Marca:** PiraRed  
**Lema de marca definido:** “Pirané capital provincial del folklore”  
**División de movilidad:** PiraRed Móvil

## Qué incluye
- Interfaz adaptable a celulares.
- Pantalla de inicio con espacio preparado para la foto local del tren de Pirané.
- Secciones Compra/Venta, Trabajos y Changas, Comercios y Ofertas, PiraRed Móvil, Servicios y Turnos.
- Perfil local y creación de publicaciones de demostración usando `localStorage`.
- Estilo de tarjetas y botones translúcidos.
- Archivos HTML, CSS y JavaScript sin necesidad de instalar herramientas para revisar el prototipo.

## Importante
Este ZIP es un **prototipo inicial**, no una app de producción. Las publicaciones y el perfil se guardan únicamente en el navegador del dispositivo; no están sincronizados entre usuarios. No están conectados Supabase, Mercado Pago, verificación de identidad, mapas/GPS en tiempo real, notificaciones ni un panel de administrador seguro. Esas funciones necesitan desarrollo e integración antes de ofrecer servicios reales.

Los viajes comerciales de pasajeros —especialmente en moto— deben habilitarse solo tras verificar las normas, permisos y seguros aplicables en cada localidad. La documentación de la moto no se configuró como campo obligatorio del registro interno, pero siguen vigentes las obligaciones legales aplicables para circular.

## Cómo probar desde Android
1. Descomprimí el ZIP.
2. Abrí `index.html` en un navegador o subí los archivos a un repositorio de GitHub.
3. Para GitHub Pages, subí `index.html`, `styles.css`, `app.js` y la carpeta `assets` al directorio principal y activá Pages en la configuración del repositorio.

## Fotos locales
Las imágenes reales que el usuario elija deben guardarse dentro de `assets/` con estos nombres:
- `tren-pirane.jpg` — fondo de inicio, foto real del tren/rieles de Pirané.
- `festival.jpg` — imagen local del festival, sin bailarines ni público si se mantiene esa preferencia.
- `camping-la-esperanza.jpg` — foto local del camping La Esperanza.

Por ahora se incluyen archivos de texto como guía porque no se han añadido las fotos originales del usuario. Si los nombres de archivo no existen, el diseño muestra un fondo de color alternativo.

## Siguiente etapa recomendada
1. Añadir las fotos originales/locales.
2. Conectar Supabase (tablas, autenticación y reglas de acceso).
3. Implementar roles reales de usuario, conductor y administrador.
4. Integrar proveedor de identidad y pagos.
5. Integrar mapas, ubicación y asignación de pedidos.
6. Pruebas de seguridad, accesibilidad y cumplimiento local antes del lanzamiento.
