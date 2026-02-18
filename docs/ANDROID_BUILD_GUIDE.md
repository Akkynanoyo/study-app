# Android Build and Deployment Guide

## Prerequisites

- Android SDK installed
- Android Studio installed
- Connected Android device or emulator
- Firebase project configured

## Step 1: Configure Firebase

### Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### Configure Firebase

```bash
flutterfire configure --platforms android
```

This will:
1. Download `google-services.json`
2. Place it in `android/app/`
3. Update `lib/firebase_options.dart`

## Step 2: Android Configuration

### Update Build Gradle

Check `android/app/build.gradle.kts`:

```kotlin
android {
    compileSdk = 34
    
    defaultConfig {
        applicationId = "com.example.schedule_app"
        minSdk = 21
        targetSdk = 34
    }
}
```

### Verify google-services.json

Ensure `android/app/google-services.json` exists and contains Firebase config.

## Step 3: Build APK

### Debug Build

```bash
flutter build apk --debug
```

### Release Build

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

## Step 4: Build App Bundle (For Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

## Step 5: Test on Device/Emulator

### Start Emulator

```bash
emulator -avd Pixel_4 &
```

### Run App

```bash
flutter run
```

### Run with Release Mode

```bash
flutter run --release
```

## Step 6: Deploy to Google Play Store

### Prerequisites

1. Google Play Developer Account ($25 one-time fee)
2. App signing key
3. Release notes

### Setup App Signing

```bash
keytool -genkey -v -keystore ~/key.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload
```

Configure in `android/key.properties`:

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=key.jks
```

Update `android/app/build.gradle.kts`:

```kotlin
signingConfigs {
    release {
        keyAlias = keystoreProperties['keyAlias']
        keyPassword = keystoreProperties['keyPassword']
        storeFile = file(keystoreProperties['storeFile'])
        storePassword = keystoreProperties['storePassword']
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.release
    }
}
```

### Build Signed Release

```bash
flutter build appbundle --release
```

### Upload to Play Store

1. Go to Google Play Console
2. Create app
3. Upload `.aab` file to Internal Testing
4. Complete store listing
5. Submit for review

## Step 7: Version Management

Update in `pubspec.yaml`:

```yaml
version: 1.0.0+1
```

And in `android/app/build.gradle.kts`:

```kotlin
versionCode = 1
versionName = "1.0.0"
```

## Troubleshooting

### gradle Build Fail

```bash
cd android && ./gradlew clean && cd ..
flutter pub get
flutter build apk
```

### Firebase Plugin Issues

```bash
flutter clean
flutter pub get
flutterfire configure --platforms android
```

### Gradle Version Issues

Update `gradle/wrapper/gradle-wrapper.properties`:

```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.x-all.zip
```

## Performance Optimization

### Enable Minification

In `android/app/build.gradle.kts`:

```kotlin
buildTypes {
    release {
        minifyEnabled = true
        shrinkResources = true
    }
}
```

### Check App Size

```bash
flutter build apk --analyze-size
```

## Push Notifications

Add Firebase Cloud Messaging:

```bash
flutter pub add firebase_messaging
flutterfire configure --platforms android
```

## Monitoring

### View Logs

```bash
adb logcat
flutter logs
```

### Firebase Crashlytics

Add dependency:

```bash
flutter pub add firebase_crashlytics
```

## Testing

### Unit Tests

```bash
flutter test
```

### Integration Tests

Create `test_driver/app.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:schedule_app/main.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(const ScheduleApp());
    expect(find.byType(ScheduleApp), findsOneWidget);
  });
}
```

Run:

```bash
flutter test
```

## Common Issues

| Issue | Solution |
|-------|----------|
| "Gradle sync failed" | Run: `cd android && ./gradlew --version` |
| "firebase-messaging error" | Check google-services.json location |
| "Build cache" | Run: `flutter clean` |
| "Device not detected" | Enable USB debugging on device |

## Release Checklist

- [ ] Update version in pubspec.yaml
- [ ] Test on physical device
- [ ] Generate signed APK/AAB
- [ ] Add release notes
- [ ] Test on multiple Android versions
- [ ] Upload to Firebase Test Lab
- [ ] Submit to Play Store

## References

- [Flutter Android Build Documentation](https://docs.flutter.dev/deployment/android)
- [Google Play Store Publishing](https://developer.android.com/studio/publish)
- [Material Design Guidelines](https://material.io/design)
