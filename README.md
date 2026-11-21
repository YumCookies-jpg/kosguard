# Kosguard for Android

Kosguard is a Flutter app for residents to register belongings kept in shared
laundry and chiller spaces, browse the shared inventory, and report incidents.
This project is configured for Android development.

## Run on Android

1. Install Flutter and Android Studio, then connect an Android device with USB
   debugging enabled or start an emulator.
2. From this folder, run:

   ```powershell
   flutter pub get
   flutter run -d <android-device-id>
   ```

Use `flutter devices` to find the device ID. The add-item flow opens the Android
camera, previews the captured photo, and saves it with the item in the current
app session.

## Build a debug APK

```powershell
flutter build apk --debug
```

The APK is written to `build/app/outputs/flutter-apk/app-debug.apk`.
