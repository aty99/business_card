# Business Card Manager App

A modern Flutter application for managing business cards with scanning capabilities, built with BLoC state management and local storage.

## 📱 Features

### Core Functionality
- **User Authentication**
  - Sign Up with email and password
  - Sign In with validation
  - Secure local session management
  - Logout functionality

- **Business Card Management**
  - Scan business cards using camera or gallery
  - Mock OCR data extraction (generates dummy data for demonstration)
  - Add/Edit card details manually
  - View all saved cards in a list
  - Search cards by name, company, or job title
  - View detailed card information
  - Delete cards with confirmation
  - Copy contact information to clipboard

### Technical Features
- **State Management**: BLoC pattern for predictable state management
- **Local Storage**: Hive database for offline data persistence
- **Clean Architecture**: Organized folder structure with separation of concerns
- **Form Validation**: Comprehensive input validation for all forms
- **Error Handling**: User-friendly error messages and feedback
- **Modern UI**: Clean and intuitive design with smooth animations
- **Responsive Design**: Works on different screen sizes

## 🏗️ Architecture

```
lib/
├── features/
│   ├── auth/
│   │   ├── bloc/           # Authentication BLoC
│   │   └── screens/        # Sign In & Sign Up screens
│   └── cards/
│       ├── bloc/           # Card management BLoC
│       └── screens/        # Home, Add Card, Card Detail screens
├── models/                 # Data models with Hive adapters
├── repositories/           # Data layer (Auth & Card repositories)
├── utils/                  # Utilities (validators, colors)
└── widgets/                # Reusable widgets
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK (3.9.2 or higher)
- Android Studio / VS Code with Flutter extensions
- Android SDK for Android builds
- Xcode for iOS builds (Mac only)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd business_card_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building APK

To build a release APK:
```bash
flutter build apk --release
```

The APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

## 📦 Dependencies

### Core
- `flutter_bloc: ^8.1.3` - State management
- `equatable: ^2.0.5` - Value equality

### Local Storage
- `hive: ^2.2.3` - NoSQL database
- `hive_flutter: ^1.1.0` - Hive Flutter integration

### Camera & Image
- `image_picker: ^1.0.4` - Camera and gallery access

### Utilities
- `uuid: ^4.2.1` - Unique ID generation

### Dev Dependencies
- `hive_generator: ^2.0.1` - Code generation for Hive
- `build_runner: ^2.4.6` - Code generation runner

## 🎯 How to Use

### First Time Setup
1. **Sign Up**: Create a new account with your email and password
2. **Sign In**: Use your credentials to log in

### Managing Business Cards

#### Adding a New Card
1. Tap the **"Add Card"** floating action button
2. Tap on the **scan area** to open camera/gallery
3. Choose **Camera** for live scan or **Gallery** to select existing image
4. Review the auto-filled information (mock OCR)
5. Edit any fields as needed
6. Tap **"Save Card"** to store the card

#### Viewing Cards
- All cards are displayed on the home screen
- Use the **search bar** to filter cards by name, company, or job title
- Tap on any card to view detailed information

#### Card Details
- View complete contact information
- **Tap any field** to copy it to clipboard
- Use the **edit icon** to modify card details
- Use the **delete icon** to remove the card

#### Logout
- Tap the **menu icon** in the top-right corner
- Select **"Logout"** to sign out

## 🎨 Design Highlights

- **Modern UI**: Clean and professional interface
- **Gradient Backgrounds**: Eye-catching gradient effects
- **Card-based Layout**: Material Design principles
- **Smooth Animations**: Fade and slide transitions
- **Color Scheme**: Primary purple with complementary colors
- **Icons**: Intuitive Material icons throughout

## 🔐 Security Notes

- Passwords are stored locally (in production, use proper encryption)
- No backend connection required - all data stored locally
- Data persists between app sessions using Hive

## 📝 Code Quality

- **Clean Code**: Well-commented and documented
- **BLoC Pattern**: Separation of business logic and UI
- **Repository Pattern**: Abstracted data layer
- **Validation**: Input validation on all forms
- **Error Handling**: Graceful error handling with user feedback

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 📱 Screens Overview

1. **Sign In Screen**: User authentication with email and password
2. **Sign Up Screen**: New user registration
3. **Home Screen**: List of all business cards with search
4. **Add/Edit Card Screen**: Scan and add new cards
5. **Card Detail Screen**: View complete card information

## 🔄 State Management

The app uses **BLoC (Business Logic Component)** pattern:

### AuthBloc
- Handles authentication state (sign in, sign up, logout)
- Manages user session

### CardBloc
- Manages card CRUD operations
- Handles search functionality

## 💾 Local Storage

Uses **Hive** for local storage:
- `users` box: Stores user accounts
- `business_cards` box: Stores business cards
- `preferences` box: Stores app preferences (current user)

## 🎯 Future Enhancements

- Real OCR integration using ML Kit or Tesseract
- Export cards to contacts
- Share cards via QR code
- Cloud sync with Firebase
- Dark mode support
- Multi-language support
- Card categories and tags
- Analytics dashboard

## 👨‍💻 Developer Information

**Developed by**: Mohamed  
**Date**: 2025  
**Flutter Version**: 3.9.2  
**Dart Version**: 3.9.2

## 📄 License

This project is created for evaluation purposes.

## 🤝 Contributing

This is an evaluation project. For questions or clarifications, please contact the development team.

## 📞 Support

For any issues or questions, please reach out through the provided communication channels.

---

**Note**: This app uses mock OCR functionality. In a production environment, integrate with real OCR services like Google ML Kit, Tesseract OCR, or cloud-based OCR APIs for actual business card text extraction.
