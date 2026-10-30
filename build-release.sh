#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/app"

if [ -n "${ANDROID_KEYSTORE_PATH:-}" ] && [ -n "${ANDROID_KEYSTORE_PASSWORD:-}" ] && [ -n "${ANDROID_KEY_ALIAS:-}" ] && [ -n "${ANDROID_KEY_PASSWORD:-}" ]; then
  echo "Using Android signing configuration from environment variables."
else
  echo "Warning: release signing environment variables are not set."
  echo "Set ANDROID_KEYSTORE_PATH, ANDROID_KEYSTORE_PASSWORD, ANDROID_KEY_ALIAS, and ANDROID_KEY_PASSWORD before release builds."
fi

./gradlew assembleRelease
