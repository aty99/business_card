import 'package:easy_localization/easy_localization.dart';

/// Validation utilities for form fields
class Validators {
  /// Validate email format
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  /// Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Validate full name
  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'name_is_required'.tr();
    }

    if (value.length < 2) {
      return 'name_must_be_at_least_2_characters'.tr();
    }

    return null;
  }

  /// Validate phone number
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^\+?[\d\s-()]+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Validate required field
  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'filed_is_required'.tr();
    }
    return null;
  }

  /// Validate URL
  String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }

    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  String? validateConfPassword(String? password, String? confPassword) {
    if (password == null || password.isEmpty || password != confPassword) {
      return tr("does_not_match_with_password");
    } else {
      return null;
    }
  }
}
