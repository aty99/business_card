import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Utility class for handling image storage
class ImageStorage {
  static const String _imagesFolder = 'business_cards';

  /// Save image to permanent storage and return the new path
  static Future<String> saveImage(String temporaryPath) async {
    try {
      print('🔄 Saving image from: $temporaryPath');
      
      // Get the app's documents directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String imagesDir = path.join(appDir.path, _imagesFolder);
      
      print('📁 Images directory: $imagesDir');
      
      // Create the images directory if it doesn't exist
      final Directory dir = Directory(imagesDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
        print('✅ Created images directory');
      }

      // Generate a unique filename
      final String fileName = 'card_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String permanentPath = path.join(imagesDir, fileName);

      print('💾 Saving to permanent path: $permanentPath');

      // Copy the temporary file to permanent storage
      final File tempFile = File(temporaryPath);
      if (!await tempFile.exists()) {
        print('❌ Temporary file does not exist: $temporaryPath');
        return temporaryPath;
      }
      
      final File permanentFile = await tempFile.copy(permanentPath);
      print('✅ Image saved successfully to: ${permanentFile.path}');

      // Delete the temporary file
      if (await tempFile.exists()) {
        await tempFile.delete();
        print('🗑️ Deleted temporary file');
      }

      return permanentFile.path;
    } catch (e) {
      print('❌ Error saving image: $e');
      // Return original path if saving fails
      return temporaryPath;
    }
  }

  /// Delete an image from permanent storage
  static Future<void> deleteImage(String imagePath) async {
    try {
      final File file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  /// Check if an image file exists
  static Future<bool> imageExists(String imagePath) async {
    try {
      print('🔍 Checking if image exists: $imagePath');
      final File file = File(imagePath);
      final exists = await file.exists();
      print('📋 Image exists: $exists');
      return exists;
    } catch (e) {
      print('❌ Error checking image existence: $e');
      return false;
    }
  }

  /// Get the images directory path
  static Future<String> getImagesDirectory() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    return path.join(appDir.path, _imagesFolder);
  }

  /// Clean up any temporary files that might be left behind
  static Future<void> cleanupTempFiles() async {
    try {
      final Directory tempDir = Directory.systemTemp;
      final List<FileSystemEntity> tempFiles = tempDir.listSync()
          .where((file) => file is File && file.path.contains('image_picker'))
          .toList();
      
      for (final file in tempFiles) {
        try {
          await file.delete();
          print('🗑️ Cleaned up temp file: ${file.path}');
        } catch (e) {
          print('⚠️ Could not delete temp file ${file.path}: $e');
        }
      }
    } catch (e) {
      print('❌ Error during temp cleanup: $e');
    }
  }
}
