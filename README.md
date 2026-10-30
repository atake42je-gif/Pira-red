# PiraRed

PiraRed es una app Android con una interfaz web embebida en WebView, enfocada en la comunidad de Pirané y zonas cercanas. La app está pensada para presentar contenido local, explorar anuncios, publicar, acceder a perfiles y mantener una identidad visual clara y moderna basada en imágenes reales del pueblo.

## Estado final de la preparación

Se corrigieron las rutas de assets y la shell web en:

- `app/src/main/assets/www/index.html`

Se ajustó la referencia de imágenes para que coincida con la estructura real del proyecto y no apunte a rutas rotas o inexistentes.

También quedaron agregados los scripts de release y la guía de entrega:

- `README-release.md`
- `build-debug.sh`
- `build-release.sh`

## Cambios aplicados

- Corrección de referencias a assets en la portada y shell de la app.
- Ajuste de rutas para que apunten a la carpeta real `app/src/main/assets/www/img`.
- Revisión del HTML/CSS para evitar imágenes rotas y problemas visuales en la portada.
- Preparación del proyecto para compilar en entorno local y generar APK/AAB de release.

## Compilar localmente

### Debug
```bash
cd app
./gradlew assembleDebug
```

### Release
```bash
cd app
./gradlew assembleRelease
```

## Firma de release

Si se quiere generar una APK firmada, configurar antes:

```bash
export ANDROID_KEYSTORE_PATH="/ruta/tu-keystore.jks"
export ANDROID_KEYSTORE_PASSWORD="tu_password"
export ANDROID_KEY_ALIAS="tu_alias"
export ANDROID_KEY_PASSWORD="tu_password_alias"
```

Luego ejecutar:

```bash
cd app
./gradlew assembleRelease
```

## Artefactos esperados

- APK debug: `app/build/outputs/apk/debug/`
- APK release: `app/build/outputs/apk/release/`
- AAB release: `app/build/outputs/bundle/release/`

## Validación final requerida antes del lanzamiento

La preparación ya quedó lista, pero la validación real en Android sigue siendo necesaria antes de declarar la app completamente terminada:

- compilar sin errores
- instalar en emulador o dispositivo real
- verificar portada
- verificar navegación
- verificar imágenes
- verificar pantallas internas
- confirmar que no faltan recursos ni hay rutas rotas

## Recomendación de entrega

- APK: para pruebas rápidas o entrega directa.
- AAB: para Google Play.

## Nota de estado

El proyecto quedó preparado para release y la corrección principal de recursos ya fue aplicada en el repositorio. La validación final en un dispositivo Android sigue siendo el último paso obligatorio antes de darlo por 100% probado.
