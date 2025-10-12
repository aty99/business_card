import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../../utils/app_colors.dart';

/// A reusable animated card widget with staggered animation support
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration? duration;
  final Duration? delay;
  final Curve curve;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double borderRadius;
  final double? elevation;
  final BoxShadow? shadow;
  final bool enableStaggeredAnimation;
  final VoidCallback? onTap;

  const AnimatedCard({
    Key? key,
    required this.child,
    this.index = 0,
    this.duration,
    this.delay,
    this.curve = Curves.easeOutCubic,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius = AppConstants.mediumRadius,
    this.elevation,
    this.shadow,
    this.enableStaggeredAnimation = true,
    this.onTap,
  }) : super(key: key);

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimation();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: widget.duration ?? AppConstants.cardAnimationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.curve,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.curve,
    ));
  }

  void _startAnimation() {
    if (widget.enableStaggeredAnimation && widget.delay != null) {
      Future.delayed(widget.delay!, () {
        if (mounted) {
          _animationController.forward();
        }
      });
    } else if (widget.enableStaggeredAnimation) {
      final delay = Duration(milliseconds: widget.index * AppConstants.cardStaggerDelay.inMilliseconds);
      Future.delayed(delay, () {
        if (mounted) {
          _animationController.forward();
        }
      });
    } else {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Card(
                margin: widget.margin ?? const EdgeInsets.all(AppConstants.smallSpacing),
                elevation: widget.elevation ?? AppConstants.smallElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                color: widget.backgroundColor ?? AppColors.white,
                shadowColor: AppColors.textSecondary.withOpacity(0.1),
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Container(
                    padding: widget.padding ?? const EdgeInsets.all(AppConstants.mediumSpacing),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      boxShadow: widget.shadow != null ? [widget.shadow!] : null,
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Extension for easy animated card creation
extension AnimatedCardExtensions on BuildContext {
  /// Create an animated card with default styling
  AnimatedCard animatedCard({
    required Widget child,
    int index = 0,
    Duration? duration,
    Duration? delay,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return AnimatedCard(
      child: child,
      index: index,
      duration: duration,
      delay: delay,
      onTap: onTap,
      padding: padding,
      margin: margin,
    );
  }

  /// Create an animated card with custom styling
  AnimatedCard styledAnimatedCard({
    required Widget child,
    int index = 0,
    Color? backgroundColor,
    double borderRadius = AppConstants.mediumRadius,
    double? elevation,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return AnimatedCard(
      child: child,
      index: index,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      elevation: elevation,
      onTap: onTap,
      padding: padding,
      margin: margin,
    );
  }
}
