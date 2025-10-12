import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../../utils/app_colors.dart';

/// A reusable animated button widget with loading state
class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? loadingColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? icon;
  final bool isOutlined;

  const AnimatedButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.loadingColor,
    this.width,
    this.height,
    this.borderRadius = AppConstants.mediumRadius,
    this.padding,
    this.icon,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.shortAnimationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isLoading) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ?? AppColors.primary;
    final textColor = widget.textColor ?? AppColors.white;
    final loadingColor = widget.loadingColor ?? AppColors.white;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height ?? 56.0,
              padding: widget.padding ?? const EdgeInsets.symmetric(
                horizontal: AppConstants.mediumSpacing,
                vertical: AppConstants.smallSpacing,
              ),
              decoration: BoxDecoration(
                color: widget.isOutlined ? Colors.transparent : backgroundColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: widget.isOutlined
                    ? Border.all(color: backgroundColor, width: 2.0)
                    : null,
                boxShadow: widget.isOutlined
                    ? null
                    : [
                        BoxShadow(
                          color: backgroundColor.withOpacity(0.3),
                          blurRadius: AppConstants.smallElevation,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: widget.isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.isOutlined ? backgroundColor : loadingColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppConstants.smallSpacing),
                          Text(
                            widget.text,
                            style: TextStyle(
                              color: widget.isOutlined ? backgroundColor : textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            widget.icon!,
                            const SizedBox(width: AppConstants.smallSpacing),
                          ],
                          Text(
                            widget.text,
                            style: TextStyle(
                              color: widget.isOutlined ? backgroundColor : textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Extension for easy button creation
extension AnimatedButtonExtensions on BuildContext {
  /// Create a primary animated button
  AnimatedButton primaryButton({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    Widget? icon,
    double? width,
  }) {
    return AnimatedButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: AppColors.primary,
      textColor: AppColors.white,
      icon: icon,
      width: width,
    );
  }

  /// Create an outlined animated button
  AnimatedButton outlinedButton({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    Widget? icon,
    double? width,
  }) {
    return AnimatedButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: AppColors.primary,
      textColor: AppColors.primary,
      isOutlined: true,
      icon: icon,
      width: width,
    );
  }

  /// Create a secondary animated button
  AnimatedButton secondaryButton({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    Widget? icon,
    double? width,
  }) {
    return AnimatedButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: AppColors.background,
      textColor: AppColors.textPrimary,
      icon: icon,
      width: width,
    );
  }
}
