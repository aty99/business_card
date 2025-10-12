import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

class SplashLogoPainter extends CustomPainter {
  final double size;

  SplashLogoPainter({required this.size});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint();
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    
    // Draw white background
    canvas.drawRect(Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height), 
                   Paint()..color = Colors.white);
    
    // Draw outer brackets (green border)
    paint
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size / 64;
    
    final outerRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: size * 0.8, height: size * 0.8),
      Radius.circular(size / 12),
    );
    canvas.drawRRect(outerRect, paint);
    
    // Draw inner brackets
    paint.strokeWidth = size / 128;
    final innerRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: size * 0.64, height: size * 0.64),
      Radius.circular(size / 16),
    );
    canvas.drawRRect(innerRect, paint);
    
    // Draw left arc (blue circle)
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF2196F3);
    
    final leftArcCenter = Offset(center.dx - size * 0.15, center.dy - size * 0.1);
    canvas.drawCircle(leftArcCenter, size / 12, paint);
    
    // Draw right arc (green circle)
    paint.color = const Color(0xFF26A69A);
    final rightArcCenter = Offset(center.dx + size * 0.15, center.dy - size * 0.1);
    canvas.drawCircle(rightArcCenter, size / 12, paint);
    
    // Draw center connecting line
    paint.color = const Color(0xFF636E72);
    final lineRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + size * 0.05),
      width: size / 8,
      height: size / 32,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(lineRect, Radius.circular(size / 64)), paint);
    
    // Draw text
    _drawText(canvas, center, size);
  }

  void _drawText(Canvas canvas, Offset center, double size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    // Draw "Business" text
    textPainter.text = TextSpan(
      text: 'Business',
      style: TextStyle(
        fontSize: size / 12,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF2D3436),
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy + size * 0.15),
    );
    
    // Draw "Code" text
    textPainter.text = TextSpan(
      text: 'Code',
      style: TextStyle(
        fontSize: size / 12,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF2196F3),
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy + size * 0.25),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LogoGenerator {
  static Future<Uint8List> generateLogoBytes({required double size}) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final painter = SplashLogoPainter(size: size);
    
    painter.paint(canvas, Size(size, size));
    
    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    
    return byteData!.buffer.asUint8List();
  }
}
