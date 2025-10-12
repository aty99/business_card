import 'package:hive_flutter/hive_flutter.dart';

class IntroHelper {
  /// Check if intro has been completed
  static Future<bool> isIntroCompleted() async {
    try {
      final box = await Hive.openBox('app_settings');
      return box.get('intro_completed', defaultValue: false);
    } catch (e) {
      return false;
    }
  }

  /// Mark intro as completed
  static Future<void> markIntroCompleted() async {
    try {
      final box = await Hive.openBox('app_settings');
      await box.put('intro_completed', true);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Reset intro status (useful for testing)
  static Future<void> resetIntroStatus() async {
    try {
      final box = await Hive.openBox('app_settings');
      await box.put('intro_completed', false);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Clear all app settings
  static Future<void> clearAllSettings() async {
    try {
      final box = await Hive.openBox('app_settings');
      await box.clear();
    } catch (e) {
      // Handle error silently
    }
  }
}
