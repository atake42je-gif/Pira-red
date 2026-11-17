# PiraRed — auditoría técnica y pruebas

Fecha: 17 de noviembre de 2026  
Rama revisada: `main`  
Commit de la interfaz auditada: `0c2d71191d8a345ee4518074b1cc2aca4297f1e4`  
Compilación: [GitHub Actions #44042024779](https://github.com/atake42je-gif/Pira-red/actions/runs/44042024779)

## Resultado comprobable

- [x] El workflow de validación HTML/JavaScript y recursos locales terminó correctamente.
- [x] Java 17, Gradle y Android SDK quedaron configurados.
- [x] `assembleDebug` terminó con `BUILD SUCCESSFUL`.
- [x] Se generó una APK Android de depuración de aproximadamente 9,5 MB.
- [x] La APK contiene `assets/www/index.html`, el código DEX y los iconos de launcher.
- [x] Las 8 imágenes web empaquetadas se pudieron abrir y verificar; no se detectaron archivos de imagen corruptos.
- [x] Las referencias locales CSS de imágenes se resolvieron contra los recursos empaquetados.
- [x] El manifiesto declara INTERNET y una Activity de inicio exportada.
- [x] El código JavaScript contiene manejadores para los siete formularios presentes.
- [x] El registro usa Supabase Auth; la recuperación solicita el enlace de restablecimiento; el cierre intenta revocar la sesión.
- [x] Las publicaciones y solicitudes de comercio se envían como pendientes; el feed solicita solo contenido aprobado.
- [x] Los guardados se persisten localmente.
- [x] La moderación está condicionada al rol admin y los mensajes usan participantes autenticados.

## Hallazgos que impiden declarar el lanzamiento listo

### Bloqueantes funcionales

1. **Fotos de publicaciones y anuncios:** no existe ningún campo `type=file` ni flujo de subida a Supabase Storage en la interfaz. Las tarjetas se generan como texto; no muestran imágenes del usuario. La actividad Android tiene selector de archivos, pero no hay un control web que lo invoque. Debe implementarse el bucket, políticas Storage, validación de tipo/tamaño, subida, URL y visualización; después probarlo con cuentas reales.
2. **Denuncias y bloqueos:** existen tablas/migraciones, pero la interfaz no ofrece botones ni formularios para denunciar o bloquear.
3. **Eliminación de cuenta:** no hay acción de borrado de cuenta ni procedimiento operativo implementado.
4. **Verificación de identidad:** el registro es por correo; no verifica DNI, teléfono ni identidad. No debe anunciarse como cuenta verificada.
5. **Pagos:** el build actual es DEBUG y las funciones de pago no están desplegadas/verificadas. No habilitar publicaciones destacadas ni cobros reales hasta probar preferencia, webhook firmado, conciliación y reembolsos en servidor.
6. **Firma de lanzamiento:** faltan secretos válidos de firma release en GitHub; esta compilación se firmó como DEBUG y no es una actualización de producción garantizada.

### Pruebas externas todavía necesarias

- Registro y confirmación de correo en Supabase con una cuenta de prueba nueva.
- Inicio, cierre, expiración y renovación de sesión.
- Recuperación real de contraseña y enlace de retorno.
- Dos usuarios distintos: publicar, aprobar, consultar, contactar, responder y verificar que no puedan leer conversaciones ajenas.
- Pruebas RLS como anónimo, usuario normal y administrador, incluyendo intentos de elevar el rol.
- Alta y aprobación de comercio; anuncio básico y visibilidad pública.
- Pruebas de red lenta/sin conexión, respuestas 401/403/429/500 y reintentos.
- Instalación, navegación, teclado, botones, zonas táctiles, rotación/tamaños y accesibilidad en teléfonos reales.
- Confirmar configuración actual de Supabase, protección contra contraseñas filtradas y despliegue de migraciones/funciones.

## Alcance y límites de esta auditoría

La compilación y la inspección del paquete se realizaron en CI/entorno de análisis. No se ejecutó la APK en un teléfono físico ni en un emulador Android; tampoco se crearon cuentas ni se hicieron escrituras sobre el proyecto Supabase real. Por lo tanto, los flujos conectados al backend se inspeccionaron estáticamente, no se certifican como pruebas end-to-end.

**Veredicto:** compilación DEBUG correcta; aplicación todavía NO APROBADA para lanzamiento público. No distribuir esta APK como versión final.
