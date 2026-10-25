# PiraRed — pendientes y revisión visual

PiraRed es una app Android para la comunidad de Pirané. El registro de cambios realizados está en [Léeme Pepe](LEEME_PEPE.md). Este README se usa para seguir lo que falta y revisar los recursos visuales; no debe interpretarse como prueba de que una función ya funciona en el teléfono.

## Estado visual comprobado en el código

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
- La galería ordenada de abajo es una referencia de los archivos originales. **No significa que ya existan cinco pantallas separadas para mostrar esas fotos**: por ahora, las otras imágenes siguen siendo recursos que deben identificarse e integrarse donde corresponda.
- Se limpiaron copias idénticas de imágenes. Se conservaron archivos visualmente distintos aunque todavía falte clasificarlos.

## Pendientes de desarrollo y verificación

### 1. APK y teléfono
- [ ] Generar/descargar e instalar la APK más reciente en el teléfono.
- [ ] Probar todas las pantallas, botones, navegación atrás, orientación y distintos tamaños de pantalla.
- [ ] Confirmar que la portada original no tenga ningún elemento visual superpuesto; las zonas táctiles invisibles no deben dibujar botones ni textos.
- [ ] Confirmar que la APK instalada contiene la última interfaz y las imágenes correctas.
- [ ] Confirmar y probar una firma estable de lanzamiento antes de distribuir actualizaciones; no guardar keystore ni contraseñas en GitHub.

### 2. Supabase y seguridad
- [ ] Confirmar que la URL y la clave pública configuradas en la app correspondan al proyecto Supabase correcto.
- [ ] Confirmar que las migraciones SQL estén aplicadas en ese proyecto y que tablas y columnas coincidan con las consultas de la interfaz.
- [ ] Verificar RLS y permisos de perfiles, comercios y promociones, incluyendo intentos de acceso no autorizado.
- [ ] Probar registro, inicio/cierre de sesión, sesión persistente y recuperación de contraseña.
- [ ] Probar errores de red, falta de conexión y respuestas inválidas sin exponer tokens ni datos privados.
- [ ] No incluir claves service-role, credenciales administrativas ni contraseñas en el cliente o en GitHub.

### 3. Diseño, imágenes y navegación
- [ ] Confirmar visualmente que la portada de inicio sea la imagen original del tren con PiraRed, grande y legible.
- [ ] Identificar cuál de las imágenes originales sin nombre descriptivo corresponde a la estatua; no asignar una foto por suposición.
- [ ] Verificar el orden solicitado: **tren/inicio → estatua → placita/parque → monumento de los 50 años → cartel “YO ❤️ PIRANÉ” → información de la app**.
- [ ] Integrar las imágenes 2 a 5 en la experiencia visual donde corresponda; no basta con que existan en la carpeta.
- [ ] Revisar carga, calidad, recorte y legibilidad de cada imagen en el teléfono.
- [ ] Comprobar que no aparezca un fondo negro involuntario.
- [ ] Probar cada botón, enlace y regreso a Inicio; corregir los que no tengan una acción funcional.
- [ ] Mantener separada la portada de Inicio del formulario de acceso: Iniciar sesión y Crear cuenta deben abrir la pantalla de cuenta; Acceso para comercios debe abrir su sección independiente.
- [ ] Tomar capturas reales de Inicio, Explorar, Publicar, Comercios, Perfil e Información para documentar el aspecto real de la APK.

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

## Galería de imágenes originales — orden solicitado

> Son archivos originales del repositorio, no capturas de la app funcionando. La estatua todavía debe identificarse visualmente. Los enlaces muestran los recursos disponibles, pero no prueban que todos estén conectados a una pantalla de la app.

### 1. Inicio — tren con PiraRed
![Portada original de inicio PiraRed con el tren](app/src/main/assets/www/app/Img/Inicio%20login%20pira%20red.png)

### 2. Estatua
**Pendiente:** identificar la foto original correcta entre los archivos restantes antes de mostrarla aquí.

### 3. Placita / parque
![Placita y juegos de Pirané](app/src/main/assets/www/app/Img/03-plaza-juegos.jpg)

### 4. Monumento de los 50 años
![Monumento de los 50 años de Pirané](app/src/main/assets/www/app/Img/08-monumento-50-anios.jpg)

### 5. Cartel “YO ❤️ PIRANÉ”
![Cartel Yo amo Pirané](app/src/main/assets/www/app/Img/05-yo-amo-pirane.jpg)

### 6. Información de la app — última imagen
![Información de PiraRed](app/src/main/assets/www/app/Img/04-informacion-pirared.jpg)

## Otras imágenes originales por clasificar

Se conservan porque son distintas y todavía no se ha confirmado si corresponden a otra sección o a una de las fotos que faltan por identificar:

- [Vista aérea de Pirané](app/src/main/assets/www/app/Img/07-vista-aerea-pirane.jpg)
- [Imagen de detalles de la app con tren](app/src/main/assets/www/app/Img/11-detalles%20de%20la%20app%20-tren.jpg)
- [Imagen original 1 sin nombre descriptivo](app/src/main/assets/www/app/Img/images%20(3).jpeg)
- [Imagen original 2 sin nombre descriptivo](app/src/main/assets/www/app/Img/images%20(4).jpeg)
- [Imagen original 3 sin nombre descriptivo](app/src/main/assets/www/app/Img/images%20(9).jpeg)
- [Logo original de PiraRed](app/src/main/assets/www/app/Img/logo-pirared-original.png)

**Regla de seguimiento:** no marcar una función como terminada hasta que exista un cambio concreto y se haya probado; cuando corresponda, verificar también contra Supabase y en la APK instalada.
