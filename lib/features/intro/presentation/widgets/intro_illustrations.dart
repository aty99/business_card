import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';

class IntroIllustrations {
  static Widget getIllustration(String illustrationType, {double? width, double? height}) {
    switch (illustrationType) {
      case "intro_1":
        return _buildIntro1Illustration(width: width, height: height);
      case "intro_2":
        return _buildIntro2Illustration(width: width, height: height);
      case "intro_3":
        return _buildIntro3Illustration(width: width, height: height);
      default:
        return Container();
    }
  }

  // First intro illustration - Person holding a card
  static Widget _buildIntro1Illustration({double? width, double? height}) {
    return SizedBox(
      width: width ?? 280,
      height: height ?? 200,
      child: Stack(
        children: [
          // Person figure
          Positioned(
            left: 80,
            top: 40,
            child: SizedBox(
              width: 80,
              height: 120,
              child: CustomPaint(
                painter: _PersonPainter(),
              ),
            ),
          ),
          // Business card
          Positioned(
            left: 140,
            top: 20,
            child: Container(
              width: 100,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.textSecondary.withOpacity(0.3), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Card elements
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      width: 12,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 8,
                    child: Container(
                      width: 60,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 20,
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.introTeal, AppColors.introBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Stack(
                        children: [
                          for (int i = 0; i < 3; i++)
                            Positioned(
                              left: 2 + (i * 5),
                              top: 2,
                              child: Container(
                                width: 3,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Decorative plants
          Positioned(
            left: 60,
            bottom: 20,
            child: SizedBox(
              width: 16,
              height: 20,
              child: CustomPaint(
                painter: _PlantPainter(),
              ),
            ),
          ),
          Positioned(
            right: 60,
            bottom: 30,
            child: SizedBox(
              width: 12,
              height: 16,
              child: CustomPaint(
                painter: _FlowerPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Second intro illustration - Phone with card and person
  static Widget _buildIntro2Illustration({double? width, double? height}) {
    return SizedBox(
      width: width ?? 280,
      height: height ?? 200,
      child: Stack(
        children: [
          // Phone
          Positioned(
            left: 80,
            top: 30,
            child: Container(
              width: 80,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.textSecondary, width: 2),
              ),
              child: Stack(
                children: [
                  // Phone notch
                  Positioned(
                    top: 8,
                    left: 25,
                    child: Container(
                      width: 30,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  // Card inside phone
                  Positioned(
                    top: 40,
                    left: 15,
                    child: Container(
                      width: 50,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.textSecondary, width: 1),
                      ),
                      child: Stack(
                        children: [
                          // Card elements
                          Positioned(
                            top: 4,
                            left: 4,
                            child: Container(
                              width: 8,
                              height: 6,
                              decoration: BoxDecoration(
                                color: AppColors.introGreen,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            left: 4,
                            child: Container(
                              width: 30,
                              height: 3,
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              width: 12,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.introTeal,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Person figure
          Positioned(
            right: 80,
            top: 50,
            child: SizedBox(
              width: 60,
              height: 100,
              child: CustomPaint(
                painter: _PersonSilhouettePainter(),
              ),
            ),
          ),
          // Decorative elements
          Positioned(
            top: 10,
            left: 40,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.lightGrey, width: 2),
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 40,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.lightGrey, width: 2),
              ),
            ),
          ),
          Positioned(
            left: 50,
            bottom: 20,
            child: SizedBox(
              width: 12,
              height: 16,
              child: CustomPaint(
                painter: _PlantPainter(),
              ),
            ),
          ),
          Positioned(
            right: 50,
            bottom: 30,
            child: SizedBox(
              width: 10,
              height: 12,
              child: CustomPaint(
                painter: _FlowerPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Third intro illustration - Two people sharing
  static Widget _buildIntro3Illustration({double? width, double? height}) {
    return SizedBox(
      width: width ?? 280,
      height: height ?? 200,
      child: Stack(
        children: [
          // Left person
          Positioned(
            left: 60,
            top: 50,
            child: SizedBox(
              width: 60,
              height: 100,
              child: CustomPaint(
                painter: _PersonDarkPainter(),
              ),
            ),
          ),
          // Right person
          Positioned(
            right: 60,
            top: 50,
            child: SizedBox(
              width: 60,
              height: 100,
              child: CustomPaint(
                painter: _PersonLightPainter(),
              ),
            ),
          ),
          // Connection circle with chain icon
          Positioned(
            left: 130,
            top: 70,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.textSecondary, width: 2),
                color: Colors.white,
              ),
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 30,
                  child: CustomPaint(
                    painter: _ChainLinkPainter(),
                  ),
                ),
              ),
            ),
          ),
          // Decorative plants
          Positioned(
            left: 40,
            bottom: 20,
            child: SizedBox(
              width: 12,
              height: 16,
              child: CustomPaint(
                painter: _PlantPainter(),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: 20,
            child: SizedBox(
              width: 12,
              height: 16,
              child: CustomPaint(
                painter: _PlantPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painters for the illustrations
class _PersonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textSecondary
      ..style = PaintingStyle.fill;


    // Head
    canvas.drawCircle(Offset(size.width / 2, 20), 15, paint);
    
    // Body
    canvas.drawRect(Rect.fromLTWH(15, 35, 50, 60), paint);
    
    // Arms
    canvas.drawRect(Rect.fromLTWH(5, 40, 15, 40), paint);
    canvas.drawRect(Rect.fromLTWH(60, 40, 15, 40), paint);
    
    // Legs
    canvas.drawRect(Rect.fromLTWH(25, 95, 15, 25), paint);
    canvas.drawRect(Rect.fromLTWH(40, 95, 15, 25), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PersonSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textSecondary
      ..style = PaintingStyle.fill;

    // Head (filled circle)
    canvas.drawCircle(Offset(size.width / 2, 15), 12, paint);
    
    // Body (outline)
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    canvas.drawRect(Rect.fromLTWH(10, 27, 40, 50), paint);
    
    // Arms
    canvas.drawRect(Rect.fromLTWH(2, 32, 12, 35), paint);
    canvas.drawRect(Rect.fromLTWH(46, 32, 12, 35), paint);
    
    // Legs
    canvas.drawRect(Rect.fromLTWH(20, 77, 12, 23), paint);
    canvas.drawRect(Rect.fromLTWH(28, 77, 12, 23), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PersonDarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.fill;

    // Head
    canvas.drawCircle(Offset(size.width / 2, 15), 12, paint);
    
    // Body
    canvas.drawRect(Rect.fromLTWH(10, 27, 40, 50), paint);
    
    // Arms
    canvas.drawRect(Rect.fromLTWH(2, 32, 12, 35), paint);
    canvas.drawRect(Rect.fromLTWH(46, 32, 12, 35), paint);
    
    // Legs
    canvas.drawRect(Rect.fromLTWH(20, 77, 12, 23), paint);
    canvas.drawRect(Rect.fromLTWH(28, 77, 12, 23), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PersonLightPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textSecondary
      ..style = PaintingStyle.fill;

    // Head
    canvas.drawCircle(Offset(size.width / 2, 15), 12, paint);
    
    // Body
    canvas.drawRect(Rect.fromLTWH(10, 27, 40, 50), paint);
    
    // Arms
    canvas.drawRect(Rect.fromLTWH(2, 32, 12, 35), paint);
    canvas.drawRect(Rect.fromLTWH(46, 32, 12, 35), paint);
    
    // Legs
    canvas.drawRect(Rect.fromLTWH(20, 77, 12, 23), paint);
    canvas.drawRect(Rect.fromLTWH(28, 77, 12, 23), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PlantPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.introGreen
      ..style = PaintingStyle.fill;

    // Stem
    canvas.drawRect(Rect.fromLTWH(size.width / 2 - 1, 0, 2, size.height * 0.6), paint);
    
    // Leaves
    canvas.drawOval(Rect.fromLTWH(0, size.height * 0.2, size.width, size.height * 0.3), paint);
    canvas.drawOval(Rect.fromLTWH(0, size.height * 0.5, size.width, size.height * 0.3), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FlowerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.pink.shade300
      ..style = PaintingStyle.fill;

    // Stem
    canvas.drawRect(Rect.fromLTWH(size.width / 2 - 1, 0, 2, size.height * 0.7), paint);
    
    // Flowers
    canvas.drawCircle(Offset(size.width / 2, size.height * 0.8), 3, paint);
    canvas.drawCircle(Offset(size.width / 2, size.height * 0.9), 3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ChainLinkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.introGreen, AppColors.introBlue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // First chain link
    canvas.drawOval(Rect.fromLTWH(0, 5, 20, 15), paint);
    
    // Second chain link
    canvas.drawOval(Rect.fromLTWH(20, 5, 20, 15), paint);
    
    // Connection
    canvas.drawRect(Rect.fromLTWH(18, 10, 4, 5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
