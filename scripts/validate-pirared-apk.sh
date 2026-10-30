#!/usr/bin/env bash
set -euo pipefail

APK_PATH="${1:-app/build/outputs/apk/debug/app-debug.apk}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

if [[ ! -f "$APK_PATH" ]]; then
  echo "APK no encontrado: $APK_PATH"
  echo "Primero ejecutá:"
  echo "  cd app && ./gradlew assembleDebug"
  exit 1
fi

if [[ -z "${ANDROID_HOME:-}" ]]; then
  echo "ANDROID_HOME no está definido. Configurá el SDK de Android antes de validar el APK."
  exit 1
fi

AAPT_PATH=""
for candidate in \
  "$ANDROID_HOME/build-tools/35.0.0/aapt" \
  "$ANDROID_HOME/build-tools/34.0.0/aapt" \
  "$ANDROID_HOME/build-tools/33.0.0/aapt"; do
  if [[ -x "$candidate" ]]; then
    AAPT_PATH="$candidate"
    break
  fi
done

if [[ -z "$AAPT_PATH" ]]; then
  echo "No se encontró un aapt en build-tools. Revisá tu Android SDK."
  exit 1
fi

APKSIGNER_PATH=""
for candidate in \
  "$ANDROID_HOME/build-tools/35.0.0/apksigner" \
  "$ANDROID_HOME/build-tools/34.0.0/apksigner" \
  "$ANDROID_HOME/build-tools/33.0.0/apksigner"; do
  if [[ -x "$candidate" ]]; then
    APKSIGNER_PATH="$candidate"
    break
  fi
done

if [[ -z "$APKSIGNER_PATH" ]]; then
  echo "No se encontró apksigner en build-tools. Revisá tu Android SDK."
  exit 1
fi

required_images=(
  "app/src/main/assets/www/app/Img/01-inicio-pirared.png"
  "app/src/main/assets/www/app/Img/02-monumento-plaza.jpg"
  "app/src/main/assets/www/app/Img/03-plaza-juegos.jpg"
  "app/src/main/assets/www/app/Img/04-informacion-pirared.jpg"
  "app/src/main/assets/www/app/Img/05-yo-amo-pirane.jpg"
  "app/src/main/assets/www/app/Img/06-logo-pirared.png"
)

for image in "${required_images[@]}"; do
  if [[ ! -s "$image" ]]; then
    echo "Falta la imagen original: $image"
    exit 1
  fi
done

if [[ ! -s "app/src/main/assets/www/index.html" ]]; then
  echo "No existe app/src/main/assets/www/index.html"
  exit 1
fi

python3 - "$APK_PATH" <<'PY'
from pathlib import Path
import re
from urllib.parse import unquote
import sys

apk_path = Path(sys.argv[1])
if not apk_path.is_file():
    raise SystemExit(f"APK no encontrado: {apk_path}")

html = Path('app/src/main/assets/www/index.html').read_text(encoding='utf-8')
refs = sorted(set(unquote(ref) for ref in re.findall(r'''(?:src|href)=['"](app/Img/[^'"#?]+)''', html)))
missing = [ref for ref in refs if not (Path('app/src/main/assets/www') / ref).is_file()]
if missing:
    raise SystemExit('Referencias de imagen inexistentes en index.html: ' + ', '.join(missing))
print(f"Verificadas {len(refs)} referencias locales a imágenes usadas por la interfaz.")
PY

BADGING=$("$AAPT_PATH" dump badging "$APK_PATH")
"$APKSIGNER_PATH" verify "$APK_PATH" >/dev/null

grep -F "package: name='ar.pirared.app'" <<< "$BADGING" >/dev/null || {
  echo "El APK no contiene el package esperado: ar.pirared.app"
  exit 1
}

grep -F "application-label:'PiraRed'" <<< "$BADGING" >/dev/null || {
  echo "El APK no tiene la etiqueta esperada: PiraRed"
  exit 1
}

if [[ ! -s "app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" ]]; then
  echo "Falta el icono xxhdpi: app/src/main/res/mipmap-xxxhdpi/ic_launcher.png"
  exit 1
fi

if [[ ! -s "app/src/main/res/drawable-nodpi/pirared_logo_foreground.png" ]]; then
  echo "Falta la imagen de foreground: app/src/main/res/drawable-nodpi/pirared_logo_foreground.png"
  exit 1
fi

if [[ ! -f "app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml" ]]; then
  echo "Falta app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml"
  exit 1
fi

if [[ ! -f "app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml" ]]; then
  echo "Falta app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml"
  exit 1
fi

grep -q '@drawable/pirared_logo_foreground' app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml || {
  echo "ic_launcher.xml no referencia a @drawable/pirared_logo_foreground"
  exit 1
}

grep -q '@drawable/pirared_logo_foreground' app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml || {
  echo "ic_launcher_round.xml no referencia a @drawable/pirared_logo_foreground"
  exit 1
}

echo "Validación del APK exitosa: $APK_PATH"
echo "Revisión completada: package, label, icono, imágenes principales y referencias locales de la UI."
