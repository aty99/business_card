import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../widgets/splash_logo_painter.dart';

class LogoGeneratorUtils {
  static Future<void> generateLogos() async {
    // Generate different sizes for different platforms
    await _generateLogo(size: 512, name: 'business_code_logo_512.png');
    await _generateLogo(size: 256, name: 'business_code_logo_256.png');
    await _generateLogo(size: 128, name: 'business_code_logo_128.png');
    await _generateLogo(size: 64, name: 'business_code_logo_64.png');
  }

  static Future<void> _generateLogo({required int size, required String name}) async {
    try {
      final bytes = await LogoGenerator.generateLogoBytes(size: size.toDouble());
      
      // Get the documents directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$name');
      await file.writeAsBytes(bytes);
      print('Generated logo: ${file.path}');
    } catch (e) {
      print('Error generating logo $name: $e');
    }
  }

  static Future<void> generateSplashAssets() async {
    // This is a helper method to generate assets for native splash
    // You can call this from a test or development script
    
    print('Generating logo assets...');
    await generateLogos();
    print('Logo generation complete!');
    print('');
    print('To use these logos:');
    print('1. Copy the generated files from your app documents directory');
    print('2. Place them in assets/logo/ folder');
    print('3. Run: flutter pub run flutter_native_splash:create');
  }
}
