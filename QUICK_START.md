# Quick Start Guide

## 🚀 Running the App

### 1. Install Dependencies
```bash
cd business_card_app
flutter pub get
```

### 2. Run the App
```bash
flutter run
```

Select your device (Android emulator, iOS simulator, or physical device) when prompted.

## 📱 Building APK

### Release APK
```bash
flutter build apk --release
```

The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

### Split APKs (smaller size)
```bash
flutter build apk --split-per-abi
```

This generates separate APKs for different architectures in:
`build/app/outputs/flutter-apk/`

## 🎥 Recording Screen for Submission

### Android (Using ADB)
```bash
adb shell screenrecord /sdcard/demo.mp4
# Use the app
# Press Ctrl+C to stop recording
adb pull /sdcard/demo.mp4
```

### iOS (Using QuickTime or Xcode)
1. Connect your iPhone
2. Open QuickTime Player
3. File → New Movie Recording
4. Select your iPhone from the dropdown
5. Click record and use the app

### Alternative: Screen Recording Apps
- **Android**: AZ Screen Recorder, Screen Recorder
- **iOS**: Built-in screen recording (Control Center)

## 👤 Demo Account

You can create a test account:
- **Email**: test@example.com
- **Password**: test123
- **Full Name**: Test User

Or create your own during sign up!

## 📝 Testing the App Flow

### Sign Up Flow
1. Open the app
2. Tap "Sign Up"
3. Enter your details:
   - Full Name: John Doe
   - Email: john@example.com
   - Password: john123
   - Confirm Password: john123
4. Tap "Sign Up"

### Add Card Flow
1. After login, tap the "Add Card" button
2. Tap the scan area
3. Choose "Camera" or "Gallery"
4. Select/take a photo
5. Review the mock-generated data
6. Edit fields if needed
7. Tap "Save Card"

### View and Manage Cards
1. See all cards on home screen
2. Use search bar to filter cards
3. Tap a card to view details
4. Tap edit icon to modify
5. Tap delete icon to remove

## 🎨 App Features to Showcase in Video

1. **Authentication**
   - Sign up with validation
   - Sign in
   - Error handling (wrong password, etc.)

2. **Card Scanning**
   - Camera/Gallery access
   - Mock OCR data generation
   - Manual editing

3. **Card Management**
   - View all cards
   - Search functionality
   - Card details view
   - Copy to clipboard feature
   - Edit and delete

4. **UI/UX**
   - Smooth animations
   - Gradient backgrounds
   - Search functionality
   - User feedback (snackbars)

## 🐛 Troubleshooting

### Build Issues
```bash
flutter clean
flutter pub get
flutter run
```

### Hive Issues
If you get Hive errors:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Android Permission Issues
Make sure these permissions are in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

## 📤 Submission Checklist

- [ ] Code pushed to GitHub
- [ ] README.md included
- [ ] Screen recording video created
- [ ] APK built and tested
- [ ] All features demonstrated in video
- [ ] Repository link shared
- [ ] Video link shared
- [ ] APK shared (optional)

## 🔗 Useful Commands

```bash
# Check Flutter installation
flutter doctor

# Run on specific device
flutter devices
flutter run -d <device-id>

# Build for different flavors
flutter build apk --debug
flutter build apk --profile
flutter build apk --release

# Generate Hive adapters
flutter pub run build_runner build

# Check for issues
flutter analyze

# Format code
flutter format .
```

## 💡 Tips for Best Demo

1. **Clear Data**: Start with fresh data for the demo
2. **Good Lighting**: Ensure good lighting for screen recording
3. **Narration**: Consider adding voice-over explaining features
4. **Show Errors**: Demonstrate error handling (wrong password, validation)
5. **Speed**: Don't rush - show features clearly
6. **Complete Flow**: Show full user journey from sign up to card management

## 📞 Need Help?

If you encounter any issues:
1. Check `flutter doctor` for setup issues
2. Review error messages in console
3. Clean and rebuild the project
4. Check this guide for common solutions

---

**Good luck with your submission! 🚀**

