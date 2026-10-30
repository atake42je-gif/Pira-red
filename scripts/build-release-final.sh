#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

if [[ ! -d "app" ]]; then
  echo "No existe el directorio app/"
  exit 1
fi

if [[ -z "${ANDROID_KEYSTORE_PATH:-}" || -z "${ANDROID_KEYSTORE_PASSWORD:-}" || -z "${ANDROID_KEY_ALIAS:-}" || -z "${ANDROID_KEY_PASSWORD:-}" ]]; then
  echo "Faltan variables de entorno para firma de release."
  echo "Ejemplo:"
  echo "  export ANDROID_KEYSTORE_PATH=\"/ruta/tu-keystore.jks\""
  echo "  export ANDROID_KEYSTORE_PASSWORD=\"tu_password\""
  echo "  export ANDROID_KEY_ALIAS=\"tu_alias\""
  echo "  export ANDROID_KEY_PASSWORD=\"tu_password_alias\""
  exit 1
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
