#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KEYSTORE_DIR="${1:-$APP_DIR/keystore}"
ALIAS="${ANDROID_KEY_ALIAS:-pirared}"
STORE_PASS="${ANDROID_KEYSTORE_PASSWORD:-}"
KEY_PASS="${ANDROID_KEY_PASSWORD:-}"

mkdir -p "$KEYSTORE_DIR"

if [ -z "$STORE_PASS" ]; then
  echo "Ingrese la contraseña de la keystore (no se guarda en Git):"
  read -rsp "Keystore password: " STORE_PASS
  echo
fi

if [ -z "$KEY_PASS" ]; then
  echo "Ingrese la contraseña de la clave privada:"
  read -rsp "Key password: " KEY_PASS
  echo
fi

KEYSTORE_PATH="$KEYSTORE_DIR/pirared-release.keystore"

if [ -f "$KEYSTORE_PATH" ]; then
  echo "La keystore ya existe en: $KEYSTORE_PATH"
  echo "Eliminá ese archivo o elegí otra ruta si querés regenerarla."
  exit 1
fi

keytool -genkeypair -v \
  -keystore "$KEYSTORE_PATH" \
  -alias "$ALIAS" \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -storepass "$STORE_PASS" \
  -keypass "$KEY_PASS" \
  -dname "CN=PiraRed, OU=PiraRed, O=PiraRed, L=Argentina, ST=Argentina, C=AR"

echo
printf '\nKeystore creada correctamente en: %s\n' "$KEYSTORE_PATH"
printf 'export ANDROID_KEYSTORE_PATH="%s"\n' "$KEYSTORE_PATH"
printf 'export ANDROID_KEYSTORE_PASSWORD="%s"\n' "$STORE_PASS"
printf 'export ANDROID_KEY_ALIAS="%s"\n' "$ALIAS"
printf 'export ANDROID_KEY_PASSWORD="%s"\n' "$KEY_PASS"
printf '\nLuego ejecutá:\n./gradlew assembleRelease\n'
