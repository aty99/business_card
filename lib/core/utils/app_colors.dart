import 'package:flutter/material.dart';

/// Application color scheme
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF26A69A); // Teal color from image
  static const Color primaryDark = Color(0xFF1E8B7F);
  static const Color primaryLight = Color(0xFF4DB6AC);
  
  // Secondary colors
  static const Color secondary = Color(0xFF81C784); // Light green from image
  static const Color secondaryDark = Color(0xFF66BB6A);
  
  // Background colors
  static const Color background = Colors.white; // Pure white like in image
  static const Color cardBackground = Colors.white;
  static const Color darkBackground = Color(0xFF1A1A2E);
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121); // Darker for white background
  static const Color textSecondary = Color(0xFF757575); // Medium gray
  static const Color textLight = Color(0xFFBDBDBD); // Light gray
  
  // Status colors
  static const Color success = Color(0xFF00B894);
  static const Color error = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color info = Color(0xFF74B9FF);
  
  // Link colors
  static const Color linkBlue = Color(0xFF2196F3);
  
  // Home screen specific colors
  static const Color tealPrimary = Color(0xFF26A69A);
  static const Color cardBorderGreen = Color(0xFF4CAF50);
  static const Color cardBorderBlue = Color(0xFF2196F3);
  
  // Neutral colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFFB2BEC3);
  static const Color lightGrey = Color(0xFFDFE6E9);
  
  // Gradient colors
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const Gradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Intro specific colors
  static const Color introGreen = Color(0xFF4CAF50);
  static const Color introTeal = Color(0xFF26A69A);
  static const Color introLightGreen = Color(0xFF81C784);
  static const Color introBlue = Color(0xFF2196F3);
  
  // Intro gradients
  static const Gradient introButtonGradient = LinearGradient(
    colors: [introLightGreen, introTeal],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  static const Gradient introButtonGradientBlue = LinearGradient(
    colors: [introLightGreen, introBlue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

