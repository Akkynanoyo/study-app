# Schedule Manager App

A cross-platform Flutter application for managing and sharing schedules with Firebase backend.

## Features

- **User Authentication**: Sign up and sign in with Firebase Auth
- **Schedule Management**: Create, read, and delete schedules
- **Real-time Synchronization**: Cloud Firestore for instant data sync
- **Multi-user Sharing**: Schedules are user-specific and synced in real-time
- **iOS & Android Support**: Native support for both platforms

## Project Structure

```
lib/
├── main.dart                    # Application entry point
├── firebase_options.dart        # Firebase configuration
├── screens/
│   ├── auth_screen.dart        # Sign in/up screen
│   └── schedule_screen.dart    # Main schedule management
├── models/
│   └── schedule.dart           # Schedule data model
└── services/
    └── firestore_service.dart  # Firebase/Firestore operations
```

## Development Setup

### Prerequisites

- **Windows**: Flutter SDK, VS Code, Git
- **Mac**: Xcode, Flutter SDK
- **Firebase Project**: Created and configured

### Step 1: Install Flutter Dependencies on Windows

```bash
cd path/to/studyapp
flutter pub get
```

### Step 2: Configure Firebase

1. Create a Firebase project at https://console.firebase.google.com
2. Add iOS and Android apps
3. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
4. Update `lib/firebase_options.dart` with your Firebase config

For Android:
- Place `google-services.json` in `android/app/`

For iOS:
- Add `GoogleService-Info.plist` to Xcode project

### Step 3: Build and Test on iOS (Mac)

```bash
# On Mac, after syncing code
cd path/to/studyapp
flutter clean
flutter pub get
flutter build ios
```

Then open in Xcode:
```bash
open ios/Runner.xcworkspace
```

Select target: `Runner` → `Scheme: Runner` → Run on simulator or device.

### Step 4: Build for Android (Optional)

```bash
flutter build apk
# or for App Bundle
flutter build appbundle
```

## Firebase Firestore Structure

```
firestore/
└── schedules/
    └── documents
        ├── id
        ├── title
        ├── description
        ├── date
        ├── time
        ├── userId
        └── createdAt
```

## Firestore Rules (Security)

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /schedules/{document=**} {
      allow read, write: if request.auth.uid == resource.data.userId;
      allow create: if request.auth.uid == request.resource.data.userId;
    }
  }
}
```

## Firebase Authentication Setup

1. Enable Email/Password authentication in Firebase Console
2. Set authentication methods in Project Settings

## Hot Reload & Development

```bash
# Run on connected device or emulator
flutter run

# Enable verbose logging
flutter run -v
```

## Troubleshooting

### iOS Build Issues
- Clear pod cache: `cd ios && rm -rf Pods && pod install`
- Update CocoaPods: `sudo gem install cocoapods`

### Firebase Integration Issues
- Run: `flutterfire configure`
- Ensure GoogleService-Info.plist is properly added to Xcode

### Android Build Issues
- Ensure `google-services.json` is in `android/app/`
- Sync Gradle: `./gradlew sync`

## Release Build

### iOS
```bash
flutter build ios --release
```

### Android
```bash
flutter build apk --release
```

## Future Enhancements

- [ ] Schedule notifications
- [ ] Share schedules with other users
- [ ] Calendar view
- [ ] Recurring schedules
- [ ] Export to calendar apps
- [ ] Dark mode support

## License

MIT License - Feel free to use this project for your needs.
