import 'package:bcode/core/utils/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool hasBorder;
  final VoidCallback? onTap;

  const DrawerItem({
    super.key,
    required this.title,
    this.icon,
    this.hasBorder = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(12),
          border: hasBorder ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.black87),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title.tr(),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
