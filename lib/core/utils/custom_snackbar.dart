import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../constants/app_constants.dart';

class CustomSnackBar {
  static const Duration _animationDuration = AppConstants.mediumAnimationDuration;
  static const Duration _displayDuration = AppConstants.snackBarDuration;
  
  /// Default positioning for snackbars
  static const EdgeInsets _defaultMargin = EdgeInsets.symmetric(horizontal: AppConstants.mediumSpacing);
  static const double _defaultTopMargin = AppConstants.smallSpacing;

  /// Show success snackbar with green color and checkmark animation
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration? duration,
  }) {
    _showSnackBar(
      context,
      message: message,
      type: SnackBarType.success,
      duration: duration,
    );
  }

  /// Show error snackbar with red color and error icon animation
  static void showError(
    BuildContext context, {
    required String message,
    Duration? duration,
  }) {
    _showSnackBar(
      context,
      message: message,
      type: SnackBarType.error,
      duration: duration,
    );
  }

  /// Show warning snackbar with orange color and warning icon animation
  static void showWarning(
    BuildContext context, {
    required String message,
    Duration? duration,
  }) {
    _showSnackBar(
      context,
      message: message,
      type: SnackBarType.warning,
      duration: duration,
    );
  }

  /// Show info snackbar with blue color and info icon animation
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration? duration,
  }) {
    _showSnackBar(
      context,
      message: message,
      type: SnackBarType.info,
      duration: duration,
    );
  }

  /// Show snackbar at the top of the screen
  static void showTop(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    Duration? duration,
  }) {
    _showSnackBar(
      context,
      message: message,
      type: type,
      duration: duration,
      position: SnackBarPosition.top,
    );
  }

  /// Show snackbar at the bottom of the screen
  static void showBottom(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    Duration? duration,
  }) {
    _showSnackBar(
      context,
      message: message,
      type: type,
      duration: duration,
      position: SnackBarPosition.bottom,
    );
  }

  static void _showSnackBar(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    Duration? duration,
    SnackBarPosition position = SnackBarPosition.top,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _AnimatedSnackBar(
        message: message,
        type: type,
        duration: duration ?? _displayDuration,
        position: position,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);
  }
}

enum SnackBarType {
  success,
  error,
  warning,
  info,
}

enum SnackBarPosition {
  top,
  bottom,
}

class _AnimatedSnackBar extends StatefulWidget {
  final String message;
  final SnackBarType type;
  final Duration duration;
  final SnackBarPosition position;
  final VoidCallback onDismiss;

  const _AnimatedSnackBar({
    required this.message,
    required this.type,
    required this.duration,
    required this.position,
    required this.onDismiss,
  });

  @override
  State<_AnimatedSnackBar> createState() => _AnimatedSnackBarState();
}

class _AnimatedSnackBarState extends State<_AnimatedSnackBar>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _iconController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: CustomSnackBar._animationDuration,
      vsync: this,
    );
    
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.position == SnackBarPosition.top 
          ? const Offset(0, -1) 
          : const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _iconAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    ));

    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _iconController.forward();
    });

    // Auto dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted) _dismiss();
    });
  }

  void _dismiss() async {
    await _slideController.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.position == SnackBarPosition.top 
          ? MediaQuery.of(context).padding.top + CustomSnackBar._defaultTopMargin
          : null,
      bottom: widget.position == SnackBarPosition.bottom 
          ? MediaQuery.of(context).padding.bottom + CustomSnackBar._defaultTopMargin
          : null,
      left: CustomSnackBar._defaultMargin.left,
      right: CustomSnackBar._defaultMargin.right,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _getBackgroundColor().withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Animated Icon
                  ScaleTransition(
                    scale: _iconAnimation,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getBackgroundColor().withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIcon(),
                        color: _getTextColor(),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Message
                  Expanded(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: _getTextColor(),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ),
                  
                  // Close button
                  GestureDetector(
                    onTap: _dismiss,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _getBackgroundColor().withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: _getTextColor(),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case SnackBarType.success:
        return AppColors.success;
      case SnackBarType.error:
        return AppColors.error;
      case SnackBarType.warning:
        return AppColors.warning;
      case SnackBarType.info:
        return AppColors.primary;
    }
  }

  Color _getTextColor() {
    return Colors.white;
  }

  IconData _getIcon() {
    switch (widget.type) {
      case SnackBarType.success:
        return Icons.check_circle_rounded;
      case SnackBarType.error:
        return Icons.error_rounded;
      case SnackBarType.warning:
        return Icons.warning_rounded;
      case SnackBarType.info:
        return Icons.info_rounded;
    }
  }
}

/// Extension for easy access to custom snackbars
extension CustomSnackBarExtension on BuildContext {
  /// Show success snackbar with green color and checkmark icon
  void showSuccessSnackBar(String message, {Duration? duration}) {
    CustomSnackBar.showSuccess(this, message: message, duration: duration);
  }

  /// Show error snackbar with red color and error icon
  void showErrorSnackBar(String message, {Duration? duration}) {
    CustomSnackBar.showError(this, message: message, duration: duration);
  }

  /// Show warning snackbar with orange color and warning icon
  void showWarningSnackBar(String message, {Duration? duration}) {
    CustomSnackBar.showWarning(this, message: message, duration: duration);
  }

  /// Show info snackbar with blue color and info icon
  void showInfoSnackBar(String message, {Duration? duration}) {
    CustomSnackBar.showInfo(this, message: message, duration: duration);
  }

  /// Show snackbar at the bottom of the screen
  void showBottomSnackBar({
    required String message,
    required SnackBarType type,
    Duration? duration,
  }) {
    CustomSnackBar.showBottom(
      this,
      message: message,
      type: type,
      duration: duration,
    );
  }

  /// Show snackbar at the top of the screen
  void showTopSnackBar({
    required String message,
    required SnackBarType type,
    Duration? duration,
  }) {
    CustomSnackBar.showTop(
      this,
      message: message,
      type: type,
      duration: duration,
    );
  }

  /// Show snackbar with custom type
  void showSnackBar({
    required String message,
    required SnackBarType type,
    Duration? duration,
    SnackBarPosition position = SnackBarPosition.top,
  }) {
    if (position == SnackBarPosition.top) {
      showTopSnackBar(message: message, type: type, duration: duration);
    } else {
      showBottomSnackBar(message: message, type: type, duration: duration);
    }
  }
}
