import 'package:bcode/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AuthLogo extends StatelessWidget {
  final String? label;
  const AuthLogo({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.credit_card,
            size: 50,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          label ?? 'Business Code',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
