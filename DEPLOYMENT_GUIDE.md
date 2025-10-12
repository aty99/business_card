# Deployment & Submission Guide

## 📤 GitHub Submission

### 1. Initialize Git Repository

```bash
cd business_card_app
git init
git add .
git commit -m "Initial commit: Business Card Manager App with BLoC and Hive"
```

### 2. Create GitHub Repository

1. Go to https://github.com
2. Click "New Repository"
3. Name: `business-card-manager-flutter`
4. Description: "Flutter app for managing business cards with camera scanning, BLoC state management, and local storage"
5. Set to **Public**
6. Don't initialize with README (we already have one)
7. Click "Create Repository"

### 3. Push to GitHub

```bash
git remote add origin https://github.com/YOUR_USERNAME/business-card-manager-flutter.git
git branch -M main
git push -u origin main
```

## 📱 Building APK for Submission

### Debug APK (For Testing)
```bash
flutter build apk --debug
```
Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK (For Submission)
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Split APKs (Smaller File Size)
```bash
flutter build apk --split-per-abi
```
Outputs:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM - most common)
- `app-x86_64-release.apk` (64-bit x86)

**Recommendation**: Submit `app-arm64-v8a-release.apk` or the universal `app-release.apk`

## 🎥 Screen Recording

### Option 1: Android Device (ADB)

```bash
# Start recording
adb shell screenrecord /sdcard/business_card_demo.mp4

# Use the app (max 3 minutes)
# Press Ctrl+C when done

# Pull the video
adb pull /sdcard/business_card_demo.mp4
```

### Option 2: Android Emulator

1. Open emulator
2. Click the **three dots** (⋮) on the side panel
3. Click **Screen record**
4. Click **Start Recording**
5. Use the app
6. Click **Stop Recording**
7. Save the video

### Option 3: Using scrcpy (Better Quality)

```bash
# Install scrcpy first
brew install scrcpy  # macOS
# or download from: https://github.com/Genymobile/scrcpy

# Record with scrcpy
scrcpy --record business_card_demo.mp4
```

### Option 4: iOS (QuickTime)

1. Connect iPhone via USB
2. Open QuickTime Player
3. File → New Movie Recording
4. Click dropdown next to record button
5. Select your iPhone
6. Click Record
7. Use the app
8. Stop recording and save

### Option 5: Screen Recording Software

- **OBS Studio** (Free, Windows/Mac/Linux)
- **Loom** (Easy, browser-based)
- **Camtasia** (Professional)

## 📋 Pre-Submission Checklist

### Code Quality
- [ ] Code compiles without errors
- [ ] No critical linter warnings
- [ ] All features working as expected
- [ ] Validation working on all forms
- [ ] Error handling in place

### Documentation
- [ ] README.md is complete and accurate
- [ ] Code is well-commented
- [ ] Project structure is clear

### Testing
- [ ] Sign up flow works
- [ ] Sign in flow works
- [ ] Camera/Gallery access works
- [ ] Card scanning works (mock OCR)
- [ ] Add card works
- [ ] View cards works
- [ ] Search works
- [ ] Edit card works
- [ ] Delete card works
- [ ] Logout works

### Build
- [ ] APK builds successfully
- [ ] APK installs on device
- [ ] All permissions granted and working
- [ ] No crashes or major bugs

### Recording
- [ ] Video shows complete user flow
- [ ] Video demonstrates all features
- [ ] Video quality is good (720p minimum)
- [ ] Video length is reasonable (3-5 minutes)
- [ ] Audio narration (optional but recommended)

### GitHub
- [ ] Repository is public
- [ ] All files committed and pushed
- [ ] README is visible
- [ ] .gitignore is working (no build files in repo)

## 📮 Submission Format

### Email Template

```
Subject: Flutter Developer Assessment - Business Card Manager - Mohamed

Dear Eng. [Name],

Please find my submission for the Flutter developer assessment:

📱 App Features:
- User Authentication (Sign Up/Sign In)
- Business Card Scanning (Camera/Gallery)
- Mock OCR Data Extraction
- Card Management (Add/Edit/Delete/View)
- Search Functionality
- BLoC State Management
- Hive Local Storage

🔗 GitHub Repository:
https://github.com/YOUR_USERNAME/business-card-manager-flutter

🎥 Demo Video:
[YouTube/Google Drive/Dropbox Link]

📦 APK File:
[Google Drive/Dropbox Link to APK]

📚 Documentation:
- README.md - Complete overview and features
- QUICK_START.md - Setup and running instructions
- PROJECT_STRUCTURE.md - Architecture documentation
- DEPLOYMENT_GUIDE.md - Build and deployment guide

⚙️ Technical Stack:
- Flutter 3.9.2
- Dart 3.9.2
- BLoC for state management
- Hive for local storage
- Image Picker for camera access

✨ Highlights:
- Clean architecture with feature-based organization
- Comprehensive input validation
- Smooth animations and modern UI
- Search functionality with real-time filtering
- Copy-to-clipboard for contact info
- Mock OCR simulation

Thank you for the opportunity. I look forward to your feedback!

Best regards,
Mohamed
```

## 🔗 File Sharing Options

### For APK (Large Files)
- Google Drive
- Dropbox
- WeTransfer
- GitHub Releases (recommended)

### For Video
- YouTube (Unlisted)
- Google Drive
- Dropbox
- Loom
- Vimeo

## 🌟 Tips for Best Submission

### Video Recording Tips
1. **Start Fresh**: Clear app data before recording
2. **Show Everything**: Sign up → Add cards → Search → View → Edit → Delete
3. **Speed**: Don't rush, but don't linger
4. **Audio**: Add narration explaining what you're doing
5. **Quality**: Record at 720p or 1080p
6. **Length**: 3-5 minutes is ideal

### GitHub Tips
1. **Good Commit Messages**: Be descriptive
2. **README First**: Make sure README renders correctly
3. **Clean Repo**: No unnecessary files
4. **Professional**: Proper formatting and documentation

### APK Tips
1. **Test First**: Install and test on real device
2. **Right Version**: Submit release APK, not debug
3. **File Size**: If too large, use split APKs
4. **Verify**: Double-check APK works before submitting

## 🚨 Common Issues & Solutions

### APK Build Fails
```bash
flutter clean
flutter pub get
flutter build apk --release
```

### Camera Permission Denied
- Check AndroidManifest.xml has permissions
- Check Info.plist has usage descriptions
- Manually grant permissions in device settings

### Hive Error
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Large APK Size
```bash
# Use split APKs
flutter build apk --split-per-abi

# Or enable ProGuard/R8 in android/app/build.gradle
```

## ⏱️ Timeline

**Recommended Schedule:**
- Day 1: Testing and fixes
- Day 2: Record video and prepare APK
- Day 3: Push to GitHub and submit

**Remember**: Speed is part of evaluation criteria!

## 📞 Support

If you encounter issues:
1. Check documentation files
2. Review error messages
3. Check Flutter doctor
4. Review this guide
5. Contact the team if needed

---

**Good luck with your submission! 🚀**

You've built something great - make sure your submission reflects that!

