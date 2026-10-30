#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

if [[ ! -d "app" ]]; then
  echo "No existe el directorio app/"
  exit 1
fi

HAS_SIGNING=1
if [[ -z "${ANDROID_KEYSTORE_PATH:-}" || -z "${ANDROID_KEYSTORE_PASSWORD:-}" || -z "${ANDROID_KEY_ALIAS:-}" || -z "${ANDROID_KEY_PASSWORD:-}" ]]; then
  HAS_SIGNING=0
  echo "Advertencia: faltan credenciales de firma de release."
  echo "Se continuará con una build sin firma para debug/release temporal."
  echo "Para firmar la release real, ejecutá:"
  echo "  export ANDROID_KEYSTORE_PATH=\"/ruta/tu-keystore.jks\""
  echo "  export ANDROID_KEYSTORE_PASSWORD=\"tu_password\""
  echo "  export ANDROID_KEY_ALIAS=\"tu_alias\""
  echo "  export ANDROID_KEY_PASSWORD=\"tu_password_alias\""
fi

if [[ "$HAS_SIGNING" -eq 1 ]] && [[ ! -f "${ANDROID_KEYSTORE_PATH}" ]]; then
  HAS_SIGNING=0
  echo "Advertencia: la ruta del keystore no existe: ${ANDROID_KEYSTORE_PATH}"
  echo "Se continuará con una build sin firma para debug/release temporal."
  echo "Para crear un keystore nuevo:"
  echo "  keytool -genkeypair -v -keystore my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias pirared"
fi

cd app
./gradlew assembleDebug
cd "$REPO_ROOT"
./scripts/validate-pirared-apk.sh app/build/outputs/apk/debug/app-debug.apk

cd app
./gradlew assembleRelease
cd "$REPO_ROOT"
./scripts/validate-pirared-apk.sh app/build/outputs/apk/release/app-release.apk

mkdir -p dist
cp app/build/outputs/apk/release/app-release.apk dist/PiraRed.apk
./gradlew bundleRelease >/dev/null 2>&1 || true

echo "Release final generada: $REPO_ROOT/dist/PiraRed.apk"
echo "AAB opcional: $REPO_ROOT/app/build/outputs/bundle/release/"

if [[ "$HAS_SIGNING" -eq 0 ]]; then
  echo ""
  echo "IMPORTANTE: la build fue creada sin firma."
  echo "Para firmarla de verdad, crea o ubica el keystore y reexportá las variables de entorno."
fi
