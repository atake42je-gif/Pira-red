#!/usr/bin/env bash
set -euo pipefail

if ! command -v gradle >/dev/null 2>&1; then
  echo "Gradle no está instalado o no está en el PATH."
  echo "Instalá Gradle 8.9+ y volvé a ejecutar este script."
  echo "Ejemplo: SDKMAN, Homebrew, apt o descarga oficial."
  exit 1
fi

exec gradle "$@"
