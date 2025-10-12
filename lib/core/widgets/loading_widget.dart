import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../../utils/app_colors.dart';

/// A reusable loading widget with different styles
class LoadingWidget extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;
  final LoadingType type;
  final bool showMessage;

  const LoadingWidget({
    Key? key,
    this.message,
    this.size = 40.0,
    this.color,
    this.type = LoadingType.circular,
    this.showMessage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLoadingIndicator(),
          if (showMessage && message != null) ...[
            const SizedBox(height: AppConstants.mediumSpacing),
            Text(
              message!,
              style: TextStyle(
                color: color ?? AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    final loadingColor = color ?? AppColors.primary;

    switch (type) {
      case LoadingType.circular:
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
          ),
        );

      case LoadingType.linear:
        return SizedBox(
          width: size * 2,
          child: LinearProgressIndicator(
            backgroundColor: loadingColor.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
          ),
        );

      case LoadingType.dots:
        return _buildDotsLoader(loadingColor);

      case LoadingType.pulse:
        return _buildPulseLoader(loadingColor);
    }
  }

  Widget _buildDotsLoader(Color color) {
    return _DotsLoader(
      color: color,
      size: size / 4,
    );
  }

  Widget _buildPulseLoader(Color color) {
    return _PulseLoader(
      color: color,
      size: size,
    );
  }
}

/// Different types of loading indicators
enum LoadingType {
  circular,
  linear,
  dots,
  pulse,
}

/// Dots loading animation
class _DotsLoader extends StatefulWidget {
  final Color color;
  final double size;

  const _DotsLoader({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  State<_DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<_DotsLoader>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(3, (index) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
      controller.repeat(reverse: true);
      return controller;
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.4, end: 1.0).animate(controller);
    }).toList();

    // Start animations with delay
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color.withOpacity(_animations[index].value),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}

/// Pulse loading animation
class _PulseLoader extends StatefulWidget {
  final Color color;
  final double size;

  const _PulseLoader({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  State<_PulseLoader> createState() => _PulseLoaderState();
}

class _PulseLoaderState extends State<_PulseLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Transform.scale(
              scale: _animation.value,
              child: Container(
                width: widget.size * 0.6,
                height: widget.size * 0.6,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Extension for easy loading widget creation
extension LoadingWidgetExtensions on BuildContext {
  /// Show a simple circular loading indicator
  Widget loadingIndicator({
    String? message,
    double size = 40.0,
    Color? color,
  }) {
    return LoadingWidget(
      message: message,
      size: size,
      color: color,
      type: LoadingType.circular,
    );
  }

  /// Show a dots loading indicator
  Widget dotsLoading({
    String? message,
    double size = 40.0,
    Color? color,
  }) {
    return LoadingWidget(
      message: message,
      size: size,
      color: color,
      type: LoadingType.dots,
    );
  }

  /// Show a pulse loading indicator
  Widget pulseLoading({
    String? message,
    double size = 40.0,
    Color? color,
  }) {
    return LoadingWidget(
      message: message,
      size: size,
      color: color,
      type: LoadingType.pulse,
    );
  }
}
