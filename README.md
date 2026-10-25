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
