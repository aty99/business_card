import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AppIconGenerator {
  static Future<void> generateAppIcon() async {
    try {
      // Generate 1024x1024 icon
      final bytes = await _generateIconBytes(1024);
      
      // Save to documents directory first
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/business_code_logo.png');
      await file.writeAsBytes(bytes);
      
      print('App icon generated successfully at: ${file.path}');
      print('Copy this file to assets/logo/business_code_logo.png');
    } catch (e) {
      print('Error generating app icon: $e');
    }
  }

  static Future<Uint8List> _generateIconBytes(int size) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();
    
    // White background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
      Paint()..color = Colors.white,
    );
    
    // Green border
    paint
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size / 50;
    
    final borderRect = Rect.fromLTWH(
      size / 50,
      size / 50,
      size - (size / 25),
      size - (size / 25),
    );
    canvas.drawRRect(RRect.fromRectAndRadius(borderRect, Radius.circular(size / 20)), paint);
    
    // Blue circle in center
    paint
      ..color = const Color(0xFF2196F3)
      ..style = PaintingStyle.fill;
    
    final center = Offset(size / 2, size / 2);
    final radius = size / 4;
    canvas.drawCircle(center, radius, paint);
    
    // Add "BC" text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'BC',
        style: TextStyle(
          fontSize: size / 4,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
    
    // Convert to image
    final picture = recorder.endRecording();
    final image = await picture.toImage(size, size);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    
    return byteData!.buffer.asUint8List();
  }
}
