import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class LogoFromImage extends StatelessWidget {
  final double size;
  final double fontSize;

  const LogoFromImage({
    super.key,
    this.size = 120,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon part - overlapping brackets/circles
        _buildLogoIcon(),
        const SizedBox(width: 8),
        // Text part
        _buildLogoText(),
      ],
    );
  }

  Widget _buildLogoIcon() {
    return SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        children: [
          // Blue circle (back)
          Positioned(
            left: 2,
            top: 6,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3), // Blue
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
            ),
          ),
          // Green circle (front, slightly overlapping)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50), // Green
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
            ),
          ),
          // Small connecting line
          Positioned(
            left: 12,
            top: 15,
            child: Container(
              width: 8,
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.textPrimary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoText() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        Text(
          'Code',
          style: TextStyle(
            fontSize: fontSize * 0.9,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2196F3),
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}
