# PiraRed — pendientes y revisión visual

PiraRed es una app Android para la comunidad de Pirané. El registro de cambios realizados está en [Léeme Pepe](LEEME_PEPE.md). Este README se usa para seguir lo que falta y revisar los recursos visuales; no debe interpretarse como prueba de que una función ya funciona en el teléfono.

## Estado visual comprobado en el código

Los cambios de interfaz y la galería que ya se incorporaron no se repiten como tareas pendientes. Quedan abajo únicamente las comprobaciones que todavía requieren validación o trabajo nuevo.

## Estilo visual acordado (mantener en todas las pantallas)

- Identidad moderna, simple, distintiva y claramente de Pirané; las fotos originales del pueblo son protagonistas.
- Fondo con fotografía original de Pirané, algo más claro que la versión oscura anterior, con contornos/detalles sutiles; evitar que la app quede negra.
- Mantener el fondo y las fotos visibles (la preferencia expresada fue alrededor del 90% de visibilidad), con buena calidad y sin deformarlas.
- La portada de tren aprobada es una imagen terminada: se muestra grande y a pantalla completa, sin ningún texto, logo, botón visible, filtro ni capa superpuesta. No recrearla con HTML ni reemplazarla por otra foto.
- Separar completamente la portada de la pantalla de inicio de sesión/registro. Las zonas táctiles pueden ser transparentes, pero no deben cambiar visualmente la imagen.
- En pantallas internas usar una interfaz limpia, fácil de navegar, con tonos celestes/azules claros, paneles sutiles y contraste legible, conservando la identidad local.
- Usar exclusivamente las imágenes originales que envió el usuario; no sustituirlas por imágenes generadas ni fotos parecidas.
- Referencia anterior de la imagen de portada/logo: imagen grande, centrada, proporcional y sin deformación. La portada actual elegida por el usuario prevalece sobre cualquier diseño anterior.

- La portada de Inicio usa `app/Img/01-inicio-pirared.png`, renombrada conservando exactamente el mismo archivo original del tren con PiraRed.
- La pantalla Información usa `app/Img/04-informacion-pirared.jpg`.
- La portada se ajustó a pantalla completa y se quitaron los textos/capas duplicados sobre la imagen. Se conservaron zonas táctiles para los accesos; su alineación con los botones dibujados en la foto debe probarse en un teléfono.
- La imagen original se muestra sin filtro ni capa oscura añadida; el recorte final depende de la proporción de cada dispositivo. Hay que comprobar la APK instalada porque el código del repositorio no demuestra qué versión está en el teléfono.
- Se agregó a `index.html` una pantalla **Fotos** con las 14 imágenes del directorio canónico. La galería se ordenó para respetar primero la secuencia principal solicitada (portada, imagen pendiente de confirmar como estatua, placita, monumento de los 50 años, cartel YO ❤️ PIRANÉ e información); después aparecen los recursos complementarios. Las fotos genéricas siguen identificadas como pendientes. La galería aún requiere prueba visual en la APK instalada.
- Se limpiaron copias idénticas de imágenes. Se conservaron archivos visualmente distintos aunque todavía falte clasificarlos.

## Pendientes reales de desarrollo y verificación

### 1. APK y teléfono
- [ ] Esperar que termine la compilación más reciente y revisar si finaliza correctamente.
- [ ] Descargar e instalar la APK nueva en el teléfono.
- [ ] Probar todas las pantallas, botones, navegación atrás, orientación y distintos tamaños de pantalla.
- [ ] Confirmar que la portada original no tenga elementos visuales superpuestos y que las zonas táctiles invisibles coincidan con los botones dibujados.
- [ ] Confirmar que la APK instalada contiene la última interfaz y las imágenes correctas.
- [ ] Configurar y probar una firma estable de lanzamiento para futuras actualizaciones; no guardar keystore ni contraseñas en GitHub.

### 2. Supabase y seguridad
- [ ] Confirmar que la URL y la clave pública configuradas en la app correspondan al proyecto Supabase correcto.
- [ ] Confirmar que las migraciones SQL estén aplicadas en ese proyecto y que tablas y columnas coincidan con las consultas de la interfaz.
- [ ] Verificar RLS y permisos de perfiles, comercios y promociones, incluyendo intentos de acceso no autorizado.
- [ ] Probar registro, inicio/cierre de sesión, sesión persistente y recuperación de contraseña.
- [ ] Probar errores de red, falta de conexión y respuestas inválidas sin exponer tokens ni datos privados.
- [ ] No incluir claves service-role, credenciales administrativas ni contraseñas en el cliente o en GitHub.

### 3. Diseño e imágenes — comprobaciones pendientes
- [ ] Confirmar en el teléfono que las 14 imágenes de la galería carguen correctamente en la APK.
- [ ] Identificar cuál de las imágenes originales corresponde a la estatua; no asignar una foto por suposición.
- [ ] Comprobar que no aparezca un fondo negro involuntario.
- [ ] Probar cada botón, enlace y regreso a Inicio; corregir los que no tengan una acción funcional.
- [ ] Mantener separada la portada de Inicio del formulario de acceso: Iniciar sesión y Crear cuenta deben abrir la pantalla de cuenta; Acceso para comercios debe abrir su sección independiente.
- [ ] Tomar capturas reales de Inicio, Explorar, Publicar, Comercios, Perfil e Información para documentar el aspecto real de la APK.
- [ ] Confirmar la ubicación exacta de la foto del paseo al atardecer y la del Camping La Esperanza.
- [ ] Verificar que la foto nocturna del cartel de ingreso esté guardada en versión limpia y de alta calidad.
- [ ] Confirmar que cada archivo de la galería exista en la ruta indicada y se vea correctamente en el teléfono.

### 4. Funciones comunitarias
- [ ] Implementar exploración como invitado con permisos limitados.
- [ ] Definir las acciones que requieren cuenta completa y un método de verificación gratuito y seguro.
- [ ] Implementar publicaciones comunitarias de productos, changas y servicios, con validación y moderación.
- [ ] Implementar edición y eliminación autorizada de publicaciones propias.
- [ ] Implementar mensajería privada entre vecinos sin mostrar números de teléfono.
- [ ] Añadir bloqueo, denuncias y medidas contra spam y abuso.
- [ ] Crear un panel administrativo seguro para revisar cuentas, comercios, promociones y denuncias.

### 5. Privacidad y lanzamiento
- [ ] Publicar una política de privacidad y términos de uso acordes a las funciones reales.
- [ ] Explicar qué datos se recopilan, por qué, cuánto tiempo se conservan y cómo solicitar su eliminación.
- [ ] Probar con cuentas de invitado, usuario común, comercio pendiente, comercio aprobado y administrador.
- [ ] Revisar mensajes y registros para evitar exponer tokens, claves o datos personales.
- [ ] Documentar instalación, actualización y recuperación segura de la firma.

## Galería de imágenes — archivos actuales del repositorio

**Las imágenes se enlazan desde la carpeta real** `app/src/main/assets/www/app/Img/`. Esta lista refleja los 14 archivos que están actualmente en esa carpeta de `main`. GitHub puede mostrar las vistas previas al abrir el README.

### Secuencia principal obligatoria

**1. Inicio — tren con PiraRed.** Portada completa, sin textos, lema, botones visibles ni capas superpuestas.
![Portada original de PiraRed con el tren](app/src/main/assets/www/app/Img/01-inicio-pirared.png)

**2. Estatua / monumento de plaza.** El archivo está presente, pero hay que confirmar que sea exactamente la estatua pedida antes de etiquetarlo definitivamente.
![Monumento de la plaza — identificación pendiente](app/src/main/assets/www/app/Img/02-monumento-plaza.jpg)

**3. Placita / parque con juegos.**
![Placita y juegos](app/src/main/assets/www/app/Img/03-plaza-juegos.jpg)

**4. Monumento de los 50 años.**
![Monumento de los 50 años de Pirané](app/src/main/assets/www/app/Img/08-monumento-50-anios.jpg)

**5. Cartel nocturno “YO ❤️ PIRANÉ”.**
![Cartel Yo amo Pirané](app/src/main/assets/www/app/Img/05-yo-amo-pirane.jpg)

**6. Información de la app.** Cierra la secuencia principal.
![Información de PiraRed](app/src/main/assets/www/app/Img/04-informacion-pirared.jpg)

### Imágenes complementarias y archivos conservados

**7. Vista aérea de Pirané.**
![Vista aérea](app/src/main/assets/www/app/Img/07-vista-aerea-pirane.jpg)

**8. Logo de PiraRed.** Recurso del logo; no reemplaza la portada del tren.
![Logo de PiraRed](app/src/main/assets/www/app/Img/06-logo-pirared.png)

**9. Detalles de la app — imagen del tren.**
![Detalles de la app con el tren](app/src/main/assets/www/app/Img/11-detalles%20de%20la%20app%20-tren.jpg)

**10. Foto original pendiente de identificar — `images (3).jpeg`.**
![Foto original 3 pendiente de identificar](app/src/main/assets/www/app/Img/images%20(3).jpeg)

**11. Foto original pendiente de identificar — `images (4).jpeg`.**
![Foto original 4 pendiente de identificar](app/src/main/assets/www/app/Img/images%20(4).jpeg)

**12. Foto original pendiente de identificar — `images (9).jpeg`.**
![Foto original 9 pendiente de identificar](app/src/main/assets/www/app/Img/images%20(9).jpeg)

**13. Logo original conservado.**
![Logo original de PiraRed](app/src/main/assets/www/app/Img/logo-pirared-original.png)

**14. Portada original alternativa conservada.** La portada aprobada para Inicio sigue siendo `01-inicio-pirared.png`.
![Portada PiraRed conservada](app/src/main/assets/www/app/Img/portada-pirared.png)

### Fotos reales solicitadas que todavía deben cotejarse

Las siguientes fotos/temas se mencionaron en la conversación, pero no se les asigna un nombre de archivo sin comprobar que la foto correcta esté entre los archivos anteriores: torre azul de la plaza, plaza con mástil y banderas, paseo junto al agua al atardecer, cartel de ingreso a Pirané de noche, Camping La Esperanza, pareja bailando folclore y capullo de algodón. No sustituirlas por imágenes inventadas o paisajes parecidos.

### Comprobaciones pendientes

- Confirmar si `02-monumento-plaza.jpg` es la estatua exacta solicitada.
- Identificar las tres fotos con nombres genéricos antes de atribuirles un lugar.
- Comparar las imágenes complementarias solicitadas con los archivos originales enviados y agregar las que falten usando sus fotos auténticas.
- Abrir la APK en el teléfono y comprobar que las imágenes se carguen y se vean completas. Que aparezcan en este README solo documenta los archivos del repositorio; no prueba por sí solo su presentación en la app.

## Referencia visual acordada: vidrio claro (glassmorphism)

La imagen de pantallas compartida por el usuario es **una referencia de diseño**, no una captura de la app actual ni una orden de copiar cada pantalla literalmente. La app debe conservar las funciones y las fotos reales de Pirané que el usuario adjunta y tiene en el repositorio.

- Usar paneles tipo vidrio translúcido (glassmorphism): superficies celestes/blancas semitransparentes, bordes suaves, esquinas redondeadas y sombras discretas.
- Aclarar la interfaz respecto de la versión oscura: el fondo fotográfico real debe seguir viéndose claramente a través de los paneles; evitar una capa negra dominante.
- Mantener contraste suficiente para leer textos y distinguir botones; el efecto vidrio nunca debe perjudicar accesibilidad ni legibilidad.
- Usar azul/celeste PiraRed para acciones principales, iconos y estados seleccionados; verde solo como acento de estado cuando corresponda.
- Las fotografías reales de Pirané son el fondo y contenido visual principal. No reemplazarlas por las fotos de muestra de la maqueta ni por imágenes generadas. Mantener proporciones, calidad y recortes cuidadosos.
- Mantener consistencia entre portada, Inicio, Compra/Venta, Trabajos y Changas, cajeros, publicaciones/reclamos, Policía, perfil y administración. La maqueta es orientativa: no afirmar que esas pantallas/funciones están implementadas hasta probarlas.
- Revisar en teléfono el equilibrio entre transparencia y lectura, especialmente con fondos claros y nocturnos.

### Fotografías reenviadas para cotejar

El usuario volvió a adjuntar las fotografías reales del pueblo, el logo y la imagen de información. Antes de agregarlas o reemplazar recursos, comparar cada archivo con los recursos existentes en `app/src/main/assets/www/app/Img/`, identificar duplicados y conservar los originales distintos. No asignar una foto a la estatua ni a otro lugar por suposición. Registrar en este README cualquier recurso nuevo y su función solo después de verificarlo.


## Última compilación verificada — 25 de octubre de 2026

- La ejecución de GitHub Actions [40181089631](https://github.com/atake42je-gif/Pira-red/actions/runs/40181089631) compiló y verificó la APK correctamente para el commit `31907a51ad5c952e23edcda57cb6fed063e834ef`.
- Artefacto `PiraRed-APK`: [descargar desde los artefactos de Actions](https://github.com/atake42je-gif/Pira-red/actions/runs/40181089631).
- **Pendiente importante:** el éxito de compilación no demuestra que se instale sobre la versión ya instalada. El workflow genera una APK de prueba si no están configurados los secretos privados de firma (`ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`). Una APK firmada con otra clave no puede actualizar la instalación existente; no subir el keystore ni sus contraseñas al repositorio.


## Actualización visual — 25 de octubre de 2026

- Se ajustó la galería para preservar la fotografía completa y evitar recortes agresivos, manteniendo tarjetas claras, bordes suaves y fondo celeste translúcido.
- Se corrigió la cuadrícula de navegación inferior: ahora contempla las seis secciones visibles.
- Se mantuvo intacta la portada original elegida por el usuario; no se agregó un lema ni textos visuales nuevos sobre la imagen.
- Estos cambios ya están en `main`. La compilación automática y la prueba en el teléfono son pasos separados; no declarar terminada la app hasta revisar el resultado real.
