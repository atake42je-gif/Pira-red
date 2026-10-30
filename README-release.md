# PiraRed – Release Guide

## Build commands

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

## Keystore configuration (only for signed release)
```bash
export ANDROID_KEYSTORE_PATH="/ruta/tu-keystore.jks"
export ANDROID_KEYSTORE_PASSWORD="tu_password"
export ANDROID_KEY_ALIAS="tu_alias"
export ANDROID_KEY_PASSWORD="tu_password_alias"
```

Then:
```bash
cd app
./gradlew assembleRelease
```

## Output paths
- APK Debug: `app/build/outputs/apk/debug/`
- APK Release: `app/build/outputs/apk/release/`
- AAB Release: `app/build/outputs/bundle/release/`

## Final validation
- Open the app in an emulator or device
- Check the landing screen loads
- Check navigation works
- Verify images load correctly
- Confirm there are no broken asset paths
- Confirm the app runs without errors

## Delivery recommendation
- APK: for testing or direct delivery
- AAB: for Google Play submission

## Final command
```bash
cd app
./gradlew assembleRelease
```
