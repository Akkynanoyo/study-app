# iOS Build and Deployment Guide

## Prerequisites

- Mac with Xcode installed
- Flutter SDK installed and configured
- Project synced from Windows

## Step 1: Project Setup on Mac

After cloning/syncing the project to Mac:

```bash
cd ~/path/to/studyapp
flutter pub get
```

## Step 2: Configure Firebase on Mac

### Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### Configure Firebase

```bash
flutterfire configure
```

This will prompt you to:
1. Select your Firebase project
2. Select iOS platforms to configure

This will update:
- `lib/firebase_options.dart` with your Firebase credentials
- iOS project configuration files

## Step 3: Install iOS Dependencies

```bash
cd ios
pod deintegrate
pod install
cd ..
```

## Step 4: Build for iOS

### Development Build

```bash
flutter build ios --debug
```

### Release Build

```bash
flutter build ios --release
```

## Step 5: Open in Xcode

```bash
open ios/Runner.xcworkspace
```

**Important**: Always use `.xcworkspace` not `.xcodeproj`

## Step 6: Run on Simulator or Device

### Using Flutter CLI (Recommended)

```bash
flutter run
```

This will automatically select available simulator or connected device.

### Using Xcode

1. Open `ios/Runner.xcworkspace`
2. Select Runner scheme
3. Select target device/simulator
4. Click Play button or press ⌘R

## Step 7: Deploy to App Store

### Create App Store Connect Account

1. Go to https://appstoreconnect.apple.com
2. Create app record with bundle ID: `com.example.scheduleApp`

### Configuration Steps

1. In Xcode, select Runner project
2. Go to Signing & Capabilities
3. Select team and verify provisioning profile
4. Set version and build numbers

### Build Archive

```bash
flutter build ios --release
```

Then in Xcode:
1. Product → Archive
2. Validate with App Store credentials
3. Upload to App Store

## Troubleshooting

### Pod Installation Issues

```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
```

### Firebase Configuration Issues

```bash
flutterfire configure --override
```

### Build Cache Issues

```bash
flutter clean
flutter pub get
flutter build ios --release
```

### iOS Version Compatibility

Check `ios/Podfile` and ensure minimum iOS version is 11.0 or higher:

```ruby
platform :ios, '11.0'
```

## Signing Certificates

### Development Certificate

- Automatic signing (Xcode managed)
- Select team in Xcode

### Release Certificate

For App Store release:
1. Generate certificate in Apple Developer Account
2. Download and double-click to install in Keychain
3. In Xcode, set Signing Certificate to the uploaded certificate

## Bundle ID

Current: `com.example.scheduleApp`

To change:
1. Open `ios/Runner.xcworkspace`
2. Select Runner → Runner project
3. General tab → Bundle Identifier
4. Update in `pubspec.yaml` and Firebase config

## Testing on Physical Device

1. Connect iPhone via USB
2. Trust computer on device
3. In Xcode, select device from dropdown
4. Click Play (⌘R)

## Performance Optimization

### Enable Release Mode

```bash
flutter run --release
```

### Profiling

```bash
flutter run --profile
```

## Monitoring

### View Logs

```bash
flutter logs
```

### Firebase Analytics

Configure in `lib/main.dart`:

```dart
// Add Firebase Analytics
import 'package:firebase_analytics/firebase_analytics.dart';
// ... setup in main()
```

## Common Issues

| Issue | Solution |
|-------|----------|
| "Xcode not found" | Install Xcode from App Store |
| "Pod cannot find Firebase" | Run: `cd ios && pod install` |
| "Signing error" | Check certificate in Keychain |
| "Device locked" | Unlock and trust computer on device |

## Next Steps

1. Test on iOS simulator
2. Configure Firebase Auth rules
3. Add push notifications
4. Set up TestFlight for beta testing
5. Submit to App Store
