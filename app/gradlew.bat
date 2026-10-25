@echo off
where gradle >nul 2>&1
if errorlevel 1 (
  echo Gradle no está instalado o no está en el PATH.
  echo Instalá Gradle 8.9+ y volvé a ejecutar este script.
  exit /b 1
)

gradle %*
