# Léeme Pepe — registro de avances de PiraRed

Este archivo es el **registro de lo que ya se hizo** en PiraRed. La lista de errores, tareas pendientes y verificaciones sigue estando en el [README principal](README.md). Se actualizarán ambos archivos a medida que avance el trabajo.

## Avances realizados

### Interfaz y pantallas
- [x] Se mantuvo la interfaz principal dentro de `app/src/main/assets/www/index.html`, para que Android la abra desde los recursos locales de la app.
- [x] Se configuró la portada original del tren en `app/Img/01-inicio-pirared.png`, conservando el contenido de imagen sin alterarlo.
- [x] Se amplió la portada a pantalla completa y se retiraron el título, el texto y la capa oscura añadidos por encima para evitar duplicados.
- [x] Se dejaron zonas táctiles invisibles, sin elementos visuales superpuestos, sobre los botones que ya están dibujados en la portada original.
- [x] Se separó el flujo de la portada del formulario de inicio de sesión/registro: el acceso de inicio de sesión y Crear cuenta navegan a Mi cuenta; el acceso de comercios navega a su sección.
- [ ] Verificar en el teléfono que la portada se vea exactamente igual al archivo original y que las zonas táctiles coincidan con cada botón. Las zonas se definieron por proporciones estimadas y necesitan prueba real.
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


### Registro de decisión — 25 de octubre de 2026
- La imagen enviada nuevamente por el usuario es la portada oficial de Inicio. Debe mostrarse tal cual, sin añadir logo, textos, botones visibles, filtros ni capas encima.
- La pantalla de Inicio y la pantalla de autenticación son independientes. No se deben mostrar campos de correo o contraseña sobre la portada.
- La portada incluye visualmente tres accesos: Iniciar sesión, Crear cuenta y Acceso exclusivo para comercios. Se conservan zonas táctiles transparentes; hay que probar sus coordenadas en un teléfono real.
- El usuario pidió que todo avance, decisión y pendiente quede anotado en este archivo y en README.md.

### Registro de estilo visual — 25 de octubre de 2026
- El usuario pidió conservar el estilo que ya habíamos elegido, no rediseñarlo desde cero.
- Estilo general: moderno, simple y distintivo, con identidad de Pirané; fotos originales protagonistas, navegación fácil, fondos claros celestes/azules y detalles/contornos muy sutiles.
- Evitar el fondo negro dominante. El fondo fotográfico de Pirané debe verse bien y las imágenes conservar buena calidad, sin deformación.
- La portada del tren enviada nuevamente es la imagen final elegida: mostrarla grande/a pantalla completa, exactamente como es, sin superponer ningún elemento visual.
- Inicio y acceso de cuenta deben estar separados. Cualquier zona táctil sobre la portada debe ser completamente invisible.
- No usar fotos sustitutas ni generar versiones parecidas de las imágenes originales. Este acuerdo queda como referencia para futuras modificaciones.


### Registro de avance — 25 de octubre de 2026
- Se reordenó la galería de `index.html`: primero las seis imágenes de la secuencia principal, luego los recursos complementarios, manteniendo las 14 imágenes.
- Se dejó explícito que `02-monumento-plaza.jpg` no está confirmado como la estatua; no se inventa esa identificación.
- Se comprobó que GitHub Actions compiló y verificó la APK para el commit `31907a51ad5c952e23edcda57cb6fed063e834ef`. Sigue pendiente resolver la instalación sobre la versión previa: hace falta confirmar si la APK es de prueba y mantener la misma firma de lanzamiento.


### Ajustes visuales adicionales — 25 de octubre de 2026
- [x] La navegación inferior contempla seis secciones en la cuadrícula, evitando que el diseño reserve solo cinco columnas.
- [x] La galería usa un ajuste de imagen que prioriza mostrar las fotos completas y no cortar detalles importantes; se conserva el estilo claro de tarjetas con efecto vidrio.
- [x] Se dejó documentado que la prueba visual final debe realizarse sobre la APK instalada y que no se debe sumar texto o lema sobre la portada original.
- [ ] Verificar la galería y el menú en el teléfono, porque una modificación de código y una compilación correcta no reemplazan la prueba real.


### Revisión técnica — 28 de octubre de 2026

- [x] Se ajustó la portada para conservar la proporción original y mantener las zonas táctiles alineadas en pantallas Android con distintas proporciones; los laterales usan la misma foto como fondo cuando sobra espacio.
- [x] Se quitó la restricción de zoom del navegador para mejorar accesibilidad.
- [x] Se eliminó el segundo elemento HTML de portada de carga y su espera de 1,25 segundos; la portada principal queda como única portada de la interfaz.
- [x] Se amplió moderadamente el área de contenido en tabletas (ancho de pantalla desde 600 px CSS).
- [x] Se dejó el registro de cuenta con correo, contraseña y nombre; DNI y selfie no se solicitan ni se guardan hasta implementar una verificación de identidad segura, privada y real. No presentar la cuenta como identidad verificada.
- [x] Se mantuvo el WebView con depuración desactivada, acceso universal desde archivos desactivado, contenido mixto bloqueado y navegación restringida a recursos locales.
- [x] Se cambió el fondo del icono adaptativo a azul PiraRed.
- [ ] Confirmar que GitHub Actions compile correctamente los últimos commits y publique una APK nueva.
- [ ] Probar en el Moto G51 y, si es posible, en otro móvil y una tableta: botones de portada, zoom, registro, vuelta atrás, imágenes y navegación entre pantallas.
- [ ] Confirmar una firma estable para actualizaciones; no está demostrado que el APK de prueba pueda actualizar una instalación firmada con otra clave.

**Commits de esta revisión:** `82785294b16e2c1ab10f14e9848658052fd4b041`, `b17812b51a60a8ce1aedf0a734a59cdbd4286e24`, `41281d9d06952b6d62276a4dbafadb58552fb3ad`. El cambio de fondo del icono quedó en `0e83a7d1b09a3c70a70adb442785105b4ca379e4`.

Estos cambios están guardados en GitHub. La compilación y la prueba visual en dispositivos todavía deben confirmarse antes de declarar la APK lista.
