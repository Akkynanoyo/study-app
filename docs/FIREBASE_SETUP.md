# Firebase Setup Guide

## Overview

This guide covers setting up Firebase for the Schedule Manager app.

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create a project"
3. Enter project name: `schedule-manager`
4. Accept terms and create project

## Step 2: Add Apps to Firebase

### Register iOS App

1. In Firebase Console, click "iOS" icon
2. Bundle ID: `com.example.scheduleApp`
3. Download `GoogleService-Info.plist`
4. Place in `ios/Runner/` folder
5. In Xcode project, drag-and-drop the file and select "Copy items if needed"

### Register Android App

1. In Firebase Console, click "Android" icon
2. Package name: `com.example.schedule_app`
3. SHA-1 fingerprint:
   ```bash
   keytool -exportcert -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore
   ```
4. Download `google-services.json`
5. Place in `android/app/`

## Step 3: Enable Authentication

1. Go to Authentication in left sidebar
2. Click "Get Started"
3. Enable "Email/Password"
   - Click "Enable"
   - Save

## Step 4: Create Firestore Database

1. Go to Firestore Database in left sidebar
2. Click "Create Database"
3. Choose region: `us-central1` (or closest)
4. Start in "Production mode"

### Create Collections

#### schedules

1. Click "Start collection"
2. Collection ID: `schedules`
3. Create first document with:
   - Document ID: `auto-generated`
   - Fields:
     - `title` (string): "Sample Schedule"
     - `description` (string): "Example"
     - `date` (timestamp): Today's date
     - `time` (string): "10:30"
     - `userId` (string): Your UID
     - `createdAt` (timestamp): Now

## Step 5: Set Firestore Rules

1. Go to Firestore Database → Rules
2. Replace default rules with:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read/write only to authenticated users for their own data
    match /schedules/{document=**} {
      allow read, write: if request.auth.uid == resource.data.userId;
      allow create: if request.auth.uid == request.resource.data.userId;
    }
  }
}
```

3. Click "Publish"

## Step 6: Get Firebase Configuration

### iOS Configuration

File: `ios/Runner/GoogleService-Info.plist`

### Android Configuration

File: `android/app/google-services.json`

### Dart Configuration

Run on each platform:

```bash
# For iOS
flutterfire configure --platforms ios

# For Android
flutterfire configure --platforms android

# For both
flutterfire configure
```

This updates `lib/firebase_options.dart` automatically.

## Step 7: Enable Additional Features (Optional)

### Cloud Storage

For future profile pictures, schedule attachments:

1. Go to Storage in left sidebar
2. Click "Get Started"
3. Use default bucket location

### Cloud Functions

For scheduled notifications:

1. Go to Functions in left sidebar
2. Create new function for scheduled tasks

## Step 8: Configure Email Verification (Optional)

1. Go to Authentication → Users
2. Templates tab
3. Customize email verification template

## Step 9: Set Up Backups (Optional)

1. Go to Backups
2. Enable automated backups for Firestore

## Step 10: Monitor Usage

### Firestore Quotas

Free tier limits:
- 50,000 reads/day
- 20,000 writes/day
- 20,000 deletes/day
- 1GB stored data

Check Usage in Firebase Console:
1. Left sidebar → Quotas
2. Monitor daily usage

## Troubleshooting

### Firebase Options Not Updated

```bash
flutterfire configure --override
```

### Missing google-services.json

Ensure file is in correct location:
- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`

### Authentication Not Working

1. Check Email/Password is enabled in Firebase Console
2. Verify firebase_options.dart has correct projectId
3. Check Firestore Rules allow read/write

### Firestore Rules Rejection

If getting "missing or insufficient permissions":
1. Check Firestore Rules syntax
2. Verify userId field exists in document
3. Check Firebase auth is initialized in main.dart

## Testing Firebase Locally

### Firebase Emulator

Install Firebase CLI:

```bash
npm install -g firebase-tools
firebase login
firebase init emulators
```

Start emulator:

```bash
firebase emulators:start
```

Update `lib/main.dart` for emulator:

```dart
if (kDebugMode) {
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}
```

## Environment Variables (Optional)

Create `.env` file:

```
FIREBASE_PROJECT_ID=schedule-app-xxx
FIREBASE_API_KEY=AIza...
```

Load in `lib/main.dart`:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  // ...
}
```

## Security Best Practices

1. **Never commit secret keys** to Git
2. **Use Environment Variables** for sensitive data
3. **Enable Firestore Rules** to restrict access
4. **Rotate API Keys** periodically
5. **Monitor Usage** to detect abuse
6. **Enable Cloud Audit Logs** for compliance

## Monitoring and Logging

### Enable Analytics

In Firebase Console:
1. Go to Analytics
2. View user behavior by events

### Set Up Alerts

1. Go to Monitoring → Alerting Policies
2. Create alerts for quota thresholds

## Scaling Considerations

As app grows:

1. **Database Indexing**: Create composite indexes for complex queries
2. **Security**: Move to custom claims and service accounts
3. **Caching**: Implement client-side caching with `cached_network_image`
4. **Pagination**: Limit query results

## References

- [Firebase Documentation](https://firebase.google.com/docs)
- [Firestore Best Practices](https://firebase.google.com/docs/firestore/best-practices)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
