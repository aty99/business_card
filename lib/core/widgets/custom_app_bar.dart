import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../utils/app_colors.dart';

/// A customizable app bar with animations and modern styling
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool enableTitleAnimation;
  final bool enableActionsAnimation;
  final Duration animationDuration;

  const CustomAppBar({
    Key? key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.showBackButton = true,
    this.onBackPressed,
    this.enableTitleAnimation = true,
    this.enableActionsAnimation = true,
    this.animationDuration = AppConstants.mediumAnimationDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: enableTitleAnimation && title != null
          ? _AnimatedTitle(
              title: title!,
              duration: animationDuration,
            )
          : title != null
              ? Text(title!)
              : null,
      leading: leading ?? (showBackButton ? _buildBackButton(context) : null),
      actions: enableActionsAnimation && actions != null
          ? [
              _AnimatedActions(
                actions: actions!,
                duration: animationDuration,
              )
            ]
          : actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.white,
      elevation: elevation ?? 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Animated title widget
class _AnimatedTitle extends StatefulWidget {
  final String title;
  final Duration duration;

  const _AnimatedTitle({
    Key? key,
    required this.title,
    required this.duration,
  }) : super(key: key);

  @override
  State<_AnimatedTitle> createState() => _AnimatedTitleState();
}

class _AnimatedTitleState extends State<_AnimatedTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Text(widget.title),
          ),
        );
      },
    );
  }
}

/// Animated actions widget
class _AnimatedActions extends StatefulWidget {
  final List<Widget> actions;
  final Duration duration;

  const _AnimatedActions({
    Key? key,
    required this.actions,
    required this.duration,
  }) : super(key: key);

  @override
  State<_AnimatedActions> createState() => _AnimatedActionsState();
}

class _AnimatedActionsState extends State<_AnimatedActions>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = widget.actions.map((_) {
      final controller = AnimationController(
        duration: widget.duration,
        vsync: this,
      );
      return controller;
    }).toList();

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
      );
    }).toList();

    // Start animations with stagger
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: widget.actions.asMap().entries.map((entry) {
        final index = entry.key;
        final action = entry.value;
        
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return FadeTransition(
              opacity: _animations[index],
              child: Transform.translate(
                offset: Offset(20 * (1 - _animations[index].value), 0),
                child: action,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

/// Extension for easy custom app bar creation
extension CustomAppBarExtensions on BuildContext {
  /// Create a primary app bar
  CustomAppBar primaryAppBar({
    String? title,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = true,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
    );
  }

  /// Create a transparent app bar
  CustomAppBar transparentAppBar({
    String? title,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = true,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      elevation: 0,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
    );
  }

  /// Create a simple app bar without animations
  CustomAppBar simpleAppBar({
    String? title,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = true,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      enableTitleAnimation: false,
      enableActionsAnimation: false,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
    );
  }
}
