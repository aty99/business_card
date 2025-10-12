# Project Structure Documentation

## 📁 Folder Organization

```
business_card_app/
│
├── lib/
│   ├── features/                    # Feature-based organization
│   │   ├── auth/                    # Authentication feature
│   │   │   ├── bloc/               # BLoC for authentication
│   │   │   │   ├── auth_bloc.dart
│   │   │   │   ├── auth_event.dart
│   │   │   │   └── auth_state.dart
│   │   │   └── screens/            # Auth UI screens
│   │   │       ├── sign_in_screen.dart
│   │   │       └── sign_up_screen.dart
│   │   │
│   │   └── cards/                   # Card management feature
│   │       ├── bloc/               # BLoC for cards
│   │       │   ├── card_bloc.dart
│   │       │   ├── card_event.dart
│   │       │   └── card_state.dart
│   │       └── screens/            # Card UI screens
│   │           ├── home_screen.dart
│   │           ├── add_card_screen.dart
│   │           └── card_detail_screen.dart
│   │
│   ├── models/                      # Data models
│   │   ├── user_model.dart         # User entity with Hive adapter
│   │   ├── user_model.g.dart       # Generated Hive adapter
│   │   ├── business_card_model.dart
│   │   └── business_card_model.g.dart
│   │
│   ├── repositories/                # Data layer
│   │   ├── auth_repository.dart    # Handles user authentication
│   │   └── card_repository.dart    # Handles card CRUD operations
│   │
│   ├── utils/                       # Utility classes
│   │   ├── validators.dart         # Form validation functions
│   │   └── app_colors.dart         # Color constants and themes
│   │
│   ├── widgets/                     # Reusable widgets (if needed)
│   │
│   └── main.dart                    # App entry point
│
├── android/                         # Android-specific files
├── ios/                            # iOS-specific files
├── test/                           # Unit and widget tests
├── pubspec.yaml                    # Dependencies
├── README.md                       # Main documentation
├── QUICK_START.md                  # Getting started guide
└── PROJECT_STRUCTURE.md            # This file
```

## 🏗️ Architecture Pattern

This project follows **Clean Architecture** principles with **BLoC** state management:

### Layers

1. **Presentation Layer** (UI)
   - Screens and widgets
   - BLoC for state management
   - User interaction handling

2. **Business Logic Layer**
   - BLoCs handle business logic
   - Events trigger actions
   - States represent UI state

3. **Data Layer**
   - Repositories abstract data sources
   - Models represent data structures
   - Hive for local storage

## 📊 Data Flow

```
User Action → Event → BLoC → Repository → Hive → State → UI Update
```

### Example: Adding a Card

1. User taps "Save Card" button
2. `AddCard` event dispatched to `CardBloc`
3. `CardBloc` calls `CardRepository.saveCard()`
4. Repository saves to Hive database
5. `CardBloc` emits `CardAdded` state
6. UI shows success message and navigates back

## 🔄 State Management (BLoC)

### AuthBloc

**Events:**
- `CheckAuthStatus` - Check if user is logged in
- `SignUpRequested` - Register new user
- `SignInRequested` - Authenticate user
- `SignOutRequested` - Logout user

**States:**
- `AuthInitial` - Initial state
- `AuthLoading` - Processing authentication
- `Authenticated` - User logged in
- `Unauthenticated` - User not logged in
- `AuthError` - Authentication failed

### CardBloc

**Events:**
- `LoadCards` - Load all cards for user
- `AddCard` - Add new card
- `UpdateCard` - Update existing card
- `DeleteCard` - Delete card
- `SearchCards` - Search cards by query

**States:**
- `CardInitial` - Initial state
- `CardLoading` - Loading cards
- `CardLoaded` - Cards loaded successfully
- `CardEmpty` - No cards found
- `CardError` - Error occurred
- `CardAdded` - Card added successfully
- `CardUpdated` - Card updated successfully
- `CardDeleted` - Card deleted successfully

## 💾 Data Models

### UserModel
```dart
- id: String
- email: String
- password: String
- fullName: String
- createdAt: DateTime
```

### BusinessCardModel
```dart
- id: String
- userId: String
- fullName: String
- companyName: String
- jobTitle: String
- email: String
- phone: String
- website: String?
- address: String?
- imagePath: String?
- createdAt: DateTime
```

## 🗄️ Local Storage (Hive)

### Boxes

1. **users** - Stores user accounts
   - Type: `Box<UserModel>`
   - Key: User ID
   - TypeId: 0

2. **business_cards** - Stores business cards
   - Type: `Box<BusinessCardModel>`
   - Key: Card ID
   - TypeId: 1

3. **preferences** - Stores app preferences
   - Type: `Box`
   - Stores: Current user ID

## 🎨 UI Components

### Common Widgets

- Text fields with validation
- Gradient containers
- Card widgets
- Icon buttons
- Floating action buttons
- Search bars
- Empty state views

### Screens

1. **SignInScreen** - User login with animations
2. **SignUpScreen** - User registration with validation
3. **HomeScreen** - List of cards with search
4. **AddCardScreen** - Camera/gallery + form
5. **CardDetailScreen** - Detailed card view

## 🔐 Security & Validation

### Validation Rules

- **Email**: Valid email format required
- **Password**: Minimum 6 characters
- **Name**: Minimum 2 characters
- **Phone**: Valid phone format
- **URL**: Valid URL format (optional)

### Security Notes

- Passwords stored locally (production should use encryption)
- No network calls - all data local
- Session managed with Hive preferences

## 📱 Features Implementation

### Authentication Flow

```
App Start
    ↓
Check Auth Status
    ↓
[Logged In] → Home Screen
[Not Logged In] → Sign In Screen
```

### Card Scanning Flow

```
Tap Add Card
    ↓
Open Camera/Gallery
    ↓
Capture Image
    ↓
Mock OCR Extraction
    ↓
Fill Form Fields
    ↓
User Edits (Optional)
    ↓
Save to Hive
    ↓
Return to Home
```

## 🧪 Testing Strategy

### Unit Tests
- Repository logic
- BLoC events and states
- Validation functions

### Widget Tests
- Screen rendering
- User interactions
- Navigation flows

### Integration Tests
- Complete user flows
- Database operations
- State management

## 📦 Dependencies Explained

### Core Dependencies
- **flutter_bloc** - State management with BLoC pattern
- **equatable** - Value equality for models
- **hive** - NoSQL local database
- **hive_flutter** - Flutter integration for Hive
- **image_picker** - Camera and gallery access
- **uuid** - Generate unique IDs

### Dev Dependencies
- **hive_generator** - Generate type adapters
- **build_runner** - Run code generation
- **flutter_lints** - Code quality and linting

## 🔧 Code Generation

### Hive Type Adapters

Run this command to generate adapters after model changes:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- `user_model.g.dart`
- `business_card_model.g.dart`

## 🎯 Best Practices Applied

1. **Separation of Concerns**: Features, business logic, and data are separated
2. **Single Responsibility**: Each class has one responsibility
3. **DRY Principle**: Reusable components and utilities
4. **Clean Code**: Well-commented and documented
5. **Error Handling**: Try-catch blocks with user feedback
6. **Input Validation**: All forms validated before submission
7. **State Management**: Predictable state with BLoC
8. **Type Safety**: Strong typing throughout

## 🚀 Performance Considerations

- Hive is very fast (NoSQL key-value store)
- Lazy loading of images
- Efficient list building with ListView.builder
- State management prevents unnecessary rebuilds
- Image compression when picking from camera/gallery

## 🔄 Future Scalability

The architecture supports easy addition of:
- More features (folders in `features/`)
- More repositories (new data sources)
- More BLoCs (new state management)
- Backend integration (add API service layer)
- Caching strategies
- Offline sync

## 📚 Learning Resources

- [BLoC Pattern](https://bloclibrary.dev/)
- [Hive Documentation](https://docs.hivedb.dev/)
- [Flutter Clean Architecture](https://pub.dev/packages/flutter_clean_architecture)
- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)

---

This structure ensures:
- ✅ Maintainability
- ✅ Testability
- ✅ Scalability
- ✅ Readability
- ✅ Reusability

