# PiraRed — pendientes y revisión visual

PiraRed es una app Android para la comunidad de Pirané. El registro de lo realizado está en [Léeme Pepe](LEEME_PEPE.md). Este README queda dedicado a lo que falta, las verificaciones y las imágenes de referencia.

## Pendientes de desarrollo y verificación

### 1. APK y teléfono
- [ ] Descargar e instalar la APK más reciente en el teléfono.
- [ ] Probar todas las pantallas, botones, navegación atrás, orientación y distintos tamaños de pantalla.
- [ ] Confirmar que la APK instalada contiene la última interfaz y las imágenes correctas.
- [ ] Confirmar y probar una firma estable de lanzamiento antes de distribuir actualizaciones; no guardar keystore ni contraseñas en GitHub.

### 2. Supabase y seguridad
- [ ] Confirmar que la URL y la clave pública configuradas en la app correspondan al proyecto Supabase correcto.
- [ ] Confirmar que las migraciones SQL estén aplicadas en ese proyecto y que tablas y columnas coincidan con las consultas de la interfaz.
- [ ] Verificar RLS y permisos de perfiles, comercios y promociones, incluyendo intentos de acceso no autorizado.
- [ ] Probar registro, inicio/cierre de sesión, sesión persistente y recuperación de contraseña.
- [ ] Probar errores de red, falta de conexión y respuestas inválidas sin exponer tokens ni datos privados.
- [ ] No incluir service-role keys, credenciales administrativas ni contraseñas en el cliente o en GitHub.

### 3. Diseño, imágenes y navegación
- [ ] Confirmar visualmente que la portada de inicio sea la imagen original del tren con PiraRed, grande y legible.
- [ ] Identificar cuál de las imágenes originales sin nombre descriptivo corresponde a la estatua; no asignar una foto por suposición.
- [ ] Verificar el orden de la galería: **tren/inicio → estatua → placita/parque → monumento de los 50 años → cartel “YO ❤️ PIRANÉ” → información de la app**.
- [ ] Revisar carga, calidad, recorte y legibilidad de cada imagen en el teléfono.
- [ ] Comprobar que no aparezca un fondo negro involuntario.
- [ ] Probar cada botón, enlace y regreso a Inicio; corregir los que no tengan una acción funcional.
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

> Estas son imágenes originales del repositorio, no capturas de pantallas en ejecución. La segunda foto (estatua) queda pendiente de identificación visual porque el nombre de los archivos restantes no permite confirmar cuál es sin adivinar.

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

**Regla:** no marcar una función como terminada hasta probarla en la APK y, cuando corresponda, contra Supabase.