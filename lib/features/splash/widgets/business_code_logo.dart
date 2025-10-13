import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';

class BusinessCodeLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final double fontSize;
  final bool showIcon;

  const BusinessCodeLogo({
    super.key,
    this.width,
    this.height,
    this.fontSize = 32,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Business Code Text
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Business',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Code',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.introBlue,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          
          if (showIcon) ...[
            const SizedBox(width: 12),
            _buildIcon(),
          ],
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        children: [
          // Outer brackets
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.introGreen.withOpacity(0.3),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          
          // Inner brackets
          Positioned(
            left: 8,
            top: 8,
            right: 8,
            bottom: 8,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.introGreen.withOpacity(0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          
          // Arc elements
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.introBlue,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.introGreen,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          
          // Center connecting line
          Positioned(
            left: 20,
            top: 22,
            child: Container(
              width: 8,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Splash Screen Logo Widget
class SplashLogo extends StatelessWidget {
  final double size;

  const SplashLogo({
    Key? key,
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          SizedBox(
            width: size * 0.4,
            height: size * 0.4,
            child: Stack(
              children: [
                // Outer brackets
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.introGreen.withOpacity(0.3),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                
                // Inner brackets
                Positioned(
                  left: 16,
                  top: 16,
                  right: 16,
                  bottom: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.introGreen.withOpacity(0.5),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                
                // Arc elements
                Positioned(
                  left: 24,
                  top: 24,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.introBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                
                Positioned(
                  right: 24,
                  top: 24,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.introGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                
                // Center connecting line
                Positioned(
                  left: 40,
                  top: 44,
                  child: Container(
                    width: 16,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Text
          Column(
            children: [
              Text(
                'Business',
                style: TextStyle(
                  fontSize: size * 0.16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  letterSpacing: -1,
                ),
              ),
              Text(
                'Code',
                style: TextStyle(
                  fontSize: size * 0.16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.introBlue,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
