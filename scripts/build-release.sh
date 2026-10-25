#!/usr/bin/env bash
set -euo pipefail

if ! command -v keytool >/dev/null 2>&1; then
  echo "Java / keytool no está instalado o no está en el PATH."
  echo "Instalá JDK 17+ y volvé a ejecutar este script."
  exit 1
fi

./scripts/generate-release-keystore.sh "$@"
