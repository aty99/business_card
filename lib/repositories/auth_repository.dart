import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

/// Repository for handling authentication operations
/// Manages user registration, login, and session
class AuthRepository {
  static const String _usersBoxName = 'users';
  static const String _currentUserKey = 'current_user_id';

  Box<UserModel>? _usersBox;
  Box? _prefsBox;

  /// Initialize Hive boxes
  Future<void> init() async {
    _usersBox = await Hive.openBox<UserModel>(_usersBoxName);
    _prefsBox = await Hive.openBox('preferences');
  }

  /// Register a new user
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    // Check if email already exists
    if (_usersBox!.values.any(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
    )) {
      throw Exception('Email already registered');
    }

    // Create new user
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      password: password,
      fullName: fullName,
      createdAt: DateTime.now(),
    );

    // Save user
    await _usersBox!.put(user.id, user);

    // Set as current user
    await _prefsBox!.put(_currentUserKey, user.id);

    return user;
  }

  /// Sign in with email and password
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    // Find user by email
    if (!_usersBox!.values.any(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
    )) {
      throw Exception('Invalid email or password');
    }

    final foundUser = _usersBox!.values.firstWhere(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
    );

    // Verify password
    if (foundUser.password != password) {
      throw Exception('Invalid email or password');
    }

    // Set as current user
    await _prefsBox!.put(_currentUserKey, foundUser.id);

    return foundUser;
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _prefsBox!.delete(_currentUserKey);
  }

  /// Get current logged-in user
  UserModel? getCurrentUser() {
    final userId = _prefsBox?.get(_currentUserKey);
    if (userId == null) return null;
    return _usersBox?.get(userId);
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return getCurrentUser() != null;
  }

  /// Get all users (for debugging)
  List<UserModel> getAllUsers() {
    return _usersBox?.values.toList() ?? [];
  }
}

