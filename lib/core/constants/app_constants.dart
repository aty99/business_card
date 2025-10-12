/// Application-wide constants
class AppConstants {
  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const Duration extraLongAnimationDuration = Duration(milliseconds: 800);

  // Card animations
  static const Duration cardStaggerDelay = Duration(milliseconds: 100);
  static const Duration cardAnimationDuration = Duration(milliseconds: 400);
  static const Duration cardSlideDuration = Duration(milliseconds: 600);

  // SnackBar duration
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration longSnackBarDuration = Duration(seconds: 5);

  // Scroll animations
  static const Duration scrollAnimationDuration = Duration(milliseconds: 500);
  static const Duration scrollToTopDuration = Duration(milliseconds: 800);

  // Image dimensions
  static const double avatarSize = 48.0;
  static const double largeAvatarSize = 80.0;
  static const double cardImageHeight = 200.0;

  // Spacing
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;

  // Border radius
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 24.0;

  // Elevation
  static const double smallElevation = 2.0;
  static const double mediumElevation = 4.0;
  static const double largeElevation = 8.0;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxCompanyLength = 100;
  static const int maxJobTitleLength = 100;

  // Database
  static const String userBoxName = 'users';
  static const String cardBoxName = 'business_cards';

  // File paths
  static const String translationsPath = 'assets/translations';
  static const String imagesPath = 'assets/images';
  static const String logoPath = 'assets/logo';

  // Supported locales
  static const List<String> supportedLocales = ['en', 'ar'];

  // Default values
  static const String defaultLanguage = 'en';
  static const String defaultDateFormat = 'MMM dd, yyyy';
}
