# Léeme Pepe — registro de avances de PiraRed

Este archivo es el **registro de lo que ya se hizo** en PiraRed. La lista de errores, tareas pendientes y verificaciones sigue estando en el [README principal](README.md). Se actualizarán ambos archivos a medida que avance el trabajo.

## Avances realizados

### Interfaz y pantallas
- [x] Se mantuvo la interfaz principal dentro de `app/src/main/assets/www/index.html`, para que Android la abra desde los recursos locales de la app.
- [x] Se preparó una portada de bienvenida grande, con la imagen de inicio y botones de acceso superpuestos.
- [x] Se definió una interfaz clara, con tonos celestes, paneles translúcidos y navegación inferior.
- [x] Se agregaron las secciones de Inicio, Explorar, Publicar, Comercios, Perfil/Mi cuenta e Información.
- [x] Se incluyeron mensajes para estados sin publicaciones y errores de conexión, evitando inventar avisos para rellenar la pantalla.
- [x] Se añadió una pantalla de información de PiraRed que explica el propósito comunitario de la app.

### Cuenta y comercios
- [x] Se incorporaron solicitudes de registro e inicio de sesión usando Supabase Auth.
- [x] Se incorporó recuperación de contraseña.
- [x] Se añadió cierre de sesión y conservación local de la sesión.
- [x] Se prepararon formularios para solicitar el alta de un comercio y enviar promociones a revisión.
- [x] La interfaz consulta promociones y comercios aprobados, y no debe mostrar promociones pendientes como públicas.
- [x] Se mantuvo la clave pública/publicable de Supabase en el cliente; no se agregó una clave service-role al APK.

### Android y compilación
- [x] Se corrigió el tema Android que impedía enlazar recursos: se reemplazó `Theme.Material3.DayNight.NoActionBar`, que no estaba disponible en el proyecto, por el tema del sistema `Theme.Material.Light.NoActionBar`.
- [x] Se ajustaron las instrucciones de Supabase para que coincidan con el proyecto configurado en la interfaz.
- [x] El workflow [40175958981](https://github.com/atake42je-gif/Pira-red/actions/runs/40175958981) terminó correctamente: compilación de APK, validación de JavaScript, comprobación del APK e imágenes, y guardado del artefacto completados.
- [x] Se documentaron en el README principal los pendientes y las verificaciones que faltan.

## Archivos importantes

- Interfaz: `app/src/main/assets/www/index.html`
- Tema Android: `app/src/main/res/values/themes.xml`
- Configuración de la app Android: `app/src/main/AndroidManifest.xml`
- Actividad que muestra la interfaz: `app/src/main/java/ar/pirared/app/MainActivity.java`
- Migración SQL prevista: `supabase/migrations/202610230001_pirared_commerce_ads.sql`
- Lista de pendientes y galería visual: [README.md](README.md)

## Imágenes originales y orden solicitado

La referencia de orden que debe respetarse es:

1. Tren con la portada PiraRed y el lema “Todo cerca. Todo conectado”.
2. Estatua.
3. Placita/parque.
4. Monumento de los 50 años.
5. Cartel “YO ❤️ PIRANÉ”.
6. Imagen de información de la app al final.

Los recursos visuales que hay en el repositorio incluyen, entre otros:

- `app/src/main/assets/www/app/Img/Inicio login pira red.png`
- `app/src/main/assets/www/app/Img/02-monumento-plaza.jpg`
- `app/src/main/assets/www/app/Img/03-plaza-juegos.jpg`
- `app/src/main/assets/www/app/Img/04-informacion-pirared.jpg`
- `app/src/main/assets/www/app/Img/08-monumento-50-anios.jpg`
- `app/src/main/assets/www/app/Img/09-cartel-yo-amo-pirane.jpg`

El README principal incluye una galería de estos recursos. Por ahora está identificada como **referencia de archivos de imagen, no como captura real de cada pantalla**.

## Importante: qué todavía no está confirmado

Que la compilación haya terminado bien **no demuestra por sí solo que todas las funciones estén listas**. Todavía se debe:

- Instalar y probar esta APK en el teléfono, incluyendo navegación y visualización de cada pantalla.
- Tomar capturas reales de Inicio, Explorar, Publicar, Comercios, Perfil e Información y agregarlas al README.
- Confirmar que la migración SQL esté aplicada en el proyecto Supabase correcto y que las tablas/columnas coincidan con lo que consulta la app.
- Probar registro, inicio/cierre de sesión y recuperación de contraseña con una cuenta de prueba.
- Probar el alta de comercios y promociones con permisos reales y RLS.
- Implementar publicaciones comunitarias de productos, changas y servicios.
- Implementar mensajería privada sin mostrar números de teléfono.
- Incorporar exploración como invitado, denuncias, bloqueo y panel administrativo seguro.
- Preparar política de privacidad y términos de uso.
- Confirmar una firma estable para futuras actualizaciones sin subir keystore ni contraseñas al repositorio.

## Regla para mantener este archivo

Solo registrar como realizado lo que tenga un cambio concreto en el repositorio o una prueba confirmada. Si algo está escrito pero no se ejecutó o no se probó, debe figurar como pendiente en el [README principal](README.md).


### Limpieza del catálogo de imágenes
- Se revisaron las imágenes del repositorio comparando hashes para distinguir duplicados exactos de fotos distintas.
- Se usa `app/src/main/assets/www/app/Img/` como carpeta canónica y se eliminan copias idénticas de otras rutas y duplicados internos con nombres diferentes.
- El README principal organiza la galería según la secuencia solicitada. La estatua queda pendiente de identificar visualmente; no se asigna una foto al azar.
- La limpieza elimina copias exactas únicamente. Las imágenes distintas sin clasificar se conservan.
