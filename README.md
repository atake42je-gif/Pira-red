# PiraRed

PiraRed es una app Android con una interfaz web embebida en `app/src/main/assets/www/index.html` para la comunidad de Pirané.

## Estado del proyecto

La app ya está preparada como WebView local y se ejecuta desde `file:///android_asset/www/index.html`. La capa Android tiene la base mínima necesaria para compilar y la interfaz web queda embebida sin depender de un backend externo para arrancar.

## Configuración necesaria de Supabase

La app usa dos variables globales dentro del archivo HTML principal:

- `app/src/main/assets/www/index.html`

Debés definirlas con tus valores reales del proyecto Supabase:

```javascript
const PIRARED_SUPABASE_URL = 'https://TU-PROYECTO.supabase.co';
const PIRARED_SUPABASE_KEY = 'TU_ANON_PUBLIC_KEY';
```

Importante:
- Usá la URL real del proyecto.
- Usá la anon/public key, no la service role key.
- Nunca subas claves privadas ni secretas al repositorio.
- Si aún no tenés el proyecto de Supabase configurado, la app queda en estado seguro con placeholders y sin conexión real.

## Base de datos y seguridad

La migración SQL principal está en:

- `supabase/migrations/202610230001_pirared_commerce_ads.sql`

Eso define perfiles, comercios, anuncios y políticas RLS para la aplicación.

Antes de usar la app con datos reales:

1. Crear el proyecto en Supabase.
2. Ejecutar la migración en el SQL Editor.
3. Verificar que las políticas RLS estén activas.
4. Registrar una cuenta real y luego asignar el primer administrador manualmente desde SQL Editor.

Ejemplo:

```sql
update public.profiles
set role = 'admin'
where id = 'UUID-DE-TU-CUENTA';
```

## Funcionalidades activas

- Registro e inicio de sesión con Supabase Auth.
- Recuperación de contraseña.
- Perfiles privados con RLS.
- Alta de comercios en estado pendiente.
- Promociones para comercios aprobados.
- Listado público limitado a contenido aprobado.
- Moderación y validación por base de datos.

## Funcionalidades pendientes para lanzamiento completo

- Publicaciones comunitarias de productos, changas y servicios.
- Mensajería privada entre vecinos.
- Panel administrativo dentro de la app.
- Denuncias, bloqueo y moderación avanzada.
- Política de privacidad y términos legales refinados.
- Pruebas funcionales en dispositivo real.

## APK y firma

La app ya está preparada para compilar en Android con una firma local.

Se usan estas variables de entorno:

```bash
export ANDROID_KEYSTORE_PATH="/ruta/completa/a/pirared-release.keystore"
export ANDROID_KEYSTORE_PASSWORD="PiraRed2026!"
export ANDROID_KEY_ALIAS="pirared"
export ANDROID_KEY_PASSWORD="PiraRed2026!"
```

Luego:

```bash
./gradlew assembleRelease
```

La APK firmada queda en:

```bash
app/build/outputs/apk/release/app-release.apk
```

La keystore no debe subirse a GitHub ni guardarse dentro del repositorio.

## Generación local de keystore

El proyecto incluye un script para preparar la firma localmente:

```bash
chmod +x scripts/*.sh
./scripts/build-release.sh
```

Eso genera una keystore local y muestra las variables necesarias para compilar la release.

## Estructura relevante

- `app/src/main/AndroidManifest.xml` — manifest principal.
- `app/src/main/java/ar/pirared/app/MainActivity.java` — WebView principal.
- `app/src/main/assets/www/index.html` — interfaz embebida.
- `supabase/migrations/202610230001_pirared_commerce_ads.sql` — SQL principal del backend de comercios.
- `scripts/build-release.sh` — generación de la firma y build final.

## Antes del lanzamiento público

1. Completar las variables reales de Supabase.
2. Ejecutar la migración SQL en el proyecto correcto.
3. Probar registro, inicio de sesión y recuperación de contraseña.
4. Validar el alta y aprobación de comercios y anuncios.
5. Verificar RLS y permisos de acceso.
6. Generar la APK firmada con la clave estable.
7. Probar la actualización en un dispositivo real y en uno con la versión previa.

## Resumen

La app queda lista para funcionar como WebView local; la parte que falta para uso real es completar la configuración de Supabase y la firma digital local. El repositorio ya está preparado para eso y esta documentación deja claro el flujo correcto para compilar y publicar la app.


## Pendientes de desarrollo y verificación (lista maestra)

**Regla del proyecto:** todo lo que falte, falle o todavía no se haya probado debe registrarse aquí. No marcar una función como terminada hasta probarla en la APK y, cuando corresponda, contra Supabase.

### Prioridad 1 — compilación y APK
- [x] Identificar el error de compilación: faltaba el recurso `Theme.Material3.DayNight.NoActionBar` porque el proyecto no incorpora la dependencia Material Components.
- [x] Corregir el tema Android para usar el tema del sistema `Theme.Material.Light.NoActionBar` sin dependencia adicional.
- [ ] Confirmar que el workflow posterior al arreglo compile correctamente y entregue la APK.
- [ ] Corregir el error de compilación y ejecutar nuevamente el workflow.
- [ ] Confirmar que la APK se genere como artefacto descargable y que incluya la última versión de `index.html` e imágenes.
- [ ] Verificar instalación y apertura en Android, navegación hacia atrás, orientación y diferentes tamaños de pantalla.
- [ ] Confirmar una firma de lanzamiento estable antes de distribuir actualizaciones; no guardar keystore ni contraseñas en el repositorio.

### Prioridad 2 — Supabase y seguridad
- [ ] Confirmar que la URL y la clave pública de Supabase configuradas en la app correspondan al proyecto correcto.
- [ ] Localizar y verificar la migración SQL real; confirmar que las tablas y columnas usadas por la interfaz coincidan con el esquema desplegado.
- [ ] Ejecutar las migraciones pendientes en Supabase y revisar que RLS esté habilitado en todas las tablas con datos privados.
- [ ] Probar registro, inicio de sesión, cierre de sesión, sesión persistente y recuperación de contraseña.
- [ ] Manejar errores de red, falta de conexión, respuestas no válidas y límites de solicitudes sin mostrar datos privados.
- [ ] No incluir service-role keys, credenciales administrativas ni contraseñas en el cliente o en GitHub.
- [ ] Definir reglas seguras para perfiles, roles, permisos de comercios, anuncios y moderadores; probar accesos no autorizados.

### Prioridad 3 — pantallas y navegación
- [ ] Probar todos los botones y enlaces de cada pantalla; eliminar enlaces sin acción y destinos incorrectos.
- [ ] Verificar que la pantalla inicial use la imagen original del tren con PiraRed, a tamaño grande y legible.
- [ ] Verificar el orden de las imágenes originales: tren/inicio; estatua; placita/parque; monumento de los 50 años; cartel “YO ❤️ PIRANÉ”; imagen de información al final.
- [ ] Revisar rutas y nombres de archivos de imagen, carga de imágenes, calidad, recorte y legibilidad en móviles.
- [ ] Revisar que no aparezca fondo negro involuntario y que las fotos originales de Pirané se vean correctamente.
- [ ] Comprobar accesibilidad básica: contraste, tamaño de letra, etiquetas de campos y mensajes de error claros.
- [ ] Probar la navegación directa a Información de PiraRed y el regreso a Inicio.

### Prioridad 4 — cuentas y comunidad
- [ ] Implementar y probar exploración como invitado con permisos limitados.
- [ ] Definir qué acciones requieren cuenta completa y un método de verificación gratuito y seguro.
- [ ] Implementar publicaciones comunitarias de productos, changas y servicios, con formularios, validación y estados.
- [ ] Implementar edición y eliminación autorizada de publicaciones propias.
- [ ] Implementar mensajería privada entre usuarios sin revelar números de teléfono.
- [ ] Añadir bloqueo de usuarios, denuncias y controles contra spam/abuso.
- [ ] Definir flujo de aprobación de comercios y promociones; comprobar que solo se publiquen elementos aprobados.
- [ ] Crear un panel administrativo seguro para revisar cuentas, comercios, anuncios y denuncias.

### Prioridad 5 — privacidad y lanzamiento
- [ ] Redactar y publicar una política de privacidad clara y términos de uso adaptados al funcionamiento real.
- [ ] Explicar qué datos se recopilan, por qué, cuánto tiempo se conservan y cómo solicitar su eliminación.
- [ ] Probar la app con cuentas de prueba: invitado, usuario común, comercio pendiente, comercio aprobado y administrador.
- [ ] Hacer pruebas funcionales de cada pantalla y flujo en un dispositivo Android real.
- [ ] Revisar registros y mensajes de error para evitar exponer tokens, claves o datos personales.
- [ ] Preparar instrucciones de instalación/actualización y documentar cómo recuperar la firma de lanzamiento de forma segura.

### Estado de la última compilación revisada
- Commit de interfaz: `298b589ac76b831aaa9acf0f6164d6f2b92ac4b5`.
- Workflow: [Generar APK de PiraRed](https://github.com/atake42je-gif/Pira-red/actions/runs/40175677335).
- Resultado del commit `298b589ac76b831aaa9acf0f6164d6f2b92ac4b5`: **falló** en `:app:processDebugResources` porque no se encontró `Theme.Material3.DayNight.NoActionBar`.
- Corrección aplicada en el commit `6662eb03bcead6164bf3601a40bd1784a80e9024`, archivo `app/src/main/res/values/themes.xml`.
- Pendiente: comprobar el workflow que se dispara con esta corrección. La APK solo se considerará validada si la compilación y la comprobación del artefacto terminan correctamente.
