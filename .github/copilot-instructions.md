# Flutter Schedule Management App - Setup Instructions

## Project Overview
A Flutter-based cross-platform schedule management application with:
- iOS and Android support (iOS priority)
- Real-time data synchronization with Firebase
- Multi-user schedule sharing
- Firestore as backend database
- User authentication

## Development Environment
- **Windows**: Flutter development (Dart code)
- **Mac**: iOS/Android build and testing with Xcode
- **Cloud**: Firebase backend

## Project Structure

```
lib/
├── main.dart                    # App entry point with Firebase init
├── firebase_options.dart        # Firebase configuration (update with your config)
├── screens/
│   ├── auth_screen.dart        # Email/password authentication UI
│   └── schedule_screen.dart    # Main schedule management interface
├── models/
│   └── schedule.dart           # Schedule data model
└── services/
    └── firestore_service.dart  # Firestore CRUD operations
```

## Setup Progress

- [x] Create Flutter project structure
- [x] Add Firebase dependencies (firebase_core, cloud_firestore, firebase_auth)
- [x] Create authentication system (email/password)
- [x] Create schedule management features
- [x] Create Firestore service layer
- [x] Set up Windows development environment with Flutter SDK
- [ ] Configure Firebase project with credentials
- [ ] Build and test on iOS (Mac required)
- [ ] Build and test on Android
- [ ] Deploy to App Store and Play Store

## Implementation Details

### Authentication (AuthScreen)
- Email/password sign-up and sign-in
- Error handling for invalid credentials
- Navigation to ScheduleScreen on successful auth
- Logout functionality

### Schedule Management (ScheduleScreen)
- Create schedules with title, description, date, and time
- View all user's schedules in real-time
- Delete schedules
- Firebase Firestore integration for data persistence

### Data Model (Schedule)
- Fields: id, title, description, date, time, userId, createdAt
- Serialization to/from Firestore documents
- TimeOfDay support for time input

### Firestore Service
- addSchedule(): Add new schedule to Firestore
- getSchedules(): Stream user's schedules with real-time updates
- deleteSchedule(): Remove schedule by ID
- updateSchedule(): Modify existing schedule

## Next Steps

1. **Setup Firebase Project**:
   - Create Firebase project at https://console.firebase.google.com
   - Enable Firestore Database (Production mode)
   - Enable Authentication (Email/Password)
   - Register iOS and Android apps
   - See `docs/FIREBASE_SETUP.md` for detailed instructions

2. **Update Firebase Credentials**:
   - Update `lib/firebase_options.dart` with your Firebase config
   - Or run: `flutterfire configure` on Mac

3. **Build for iOS (On Mac)**:
   ```bash
   cd ~/path/to/studyapp
   flutter clean
   flutter pub get
   flutter build ios
   # Then open in Xcode and deploy
   ```
   See `docs/iOS_BUILD_GUIDE.md`

4. **Build for Android**:
   ```bash
   flutter build apk --release
   # Or for Play Store:
   flutter build appbundle --release
   ```
   See `docs/ANDROID_BUILD_GUIDE.md`

## Documentation Files

- `README.md` - Project overview and quick start
- `docs/FIREBASE_SETUP.md` - Firebase configuration guide
- `docs/iOS_BUILD_GUIDE.md` - iOS build and deployment
- `docs/ANDROID_BUILD_GUIDE.md` - Android build and deployment

## Running the App

### Windows Development
```bash
# Install dependencies
flutter pub get

# Run with hot reload (requires iOS/Android device or emulator)
flutter run
```

### Mac (iOS)
```bash
# Get latest code
flutter pub get

# Run on iOS simulator
flutter run

# Build for release
flutter build ios --release
```

### Mac (Android)
```bash
flutter run --device emulator
# Or for connected device
flutter run
```

## Firestore Database Structure

```
Schedule Collection:
├── Document ID (auto-generated)
├── title (string)
├── description (string)
├── date (timestamp)
├── time (string, format: "HH:mm")
├── userId (string, current user's UID)
└── createdAt (timestamp)
```

## Security Rules

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

## Troubleshooting

### Windows
- `flutter not found`: Add C:\flutter\bin to PATH
- `pub get fails`: Ensure internet connection and firewall allows access

### Mac
- `Pod install error`: Run `cd ios && pod install`
- `Firebase init missing`: Run `flutterfire configure`
- `Xcode build error`: Check iOS version (min 11.0)

### Firebase
- `Permission denied`: Check Firestore rules and user authentication
- `App ID mismatch`: Verify Firebase config matches app IDs

## Important Notes

1. **Firebase Credentials**: `lib/firebase_options.dart` contains placeholder values
   - Must be updated with actual Firebase project credentials
   - NEVER commit real credentials to version control

2. **iOS Bundle ID**: Currently `com.example.scheduleApp`
   - Update in Firebase, Xcode, and Dart code before release

3. **Android Package Name**: Currently `com.example.schedule_app`
   - Update in Firebase and `android/app/build.gradle.kts`

4. **Development vs Release**:
   - Development mode ignores some Firestore rules for testing
   - Always test in production-equivalent environment before release

## Dependencies

- **flutter**: ^3.11.0
- **firebase_core**: ^3.3.0
- **cloud_firestore**: ^5.0.0
- **firebase_auth**: ^5.1.0
- **provider**: ^6.1.5
- **intl**: ^0.19.0

See `pubspec.yaml` for full dependency list.

## Building Release Versions

### iOS
```bash
flutter build ios --release
# Then archive in Xcode for App Store
```

### Android
```bash
# Create signing key if not exists
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Build signed APK
flutter build apk --release

# Or App Bundle for Play Store
flutter build appbundle --release
```

## Performance Optimization

- Use `--release` flag for production builds
- Enable minification for Android
- Profile with `flutter run --profile`
- Monitor Firestore read/write counts

## Version Management

Update as you release:
- `pubspec.yaml`: `version: 1.0.0+1`
- `ios/Runner/Info.plist`: CFBundleShortVersionString
- `android/app/build.gradle.kts`: versionCode and versionName

