import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/intro_helper.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../intro/presentation/screens/intro_screen.dart';
import 'splash_screen.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  bool _showIntro = true;
  bool _isLoading = true;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _showSplash = false;
      });

      await _checkIntroStatus();
    }
  }

  Future<void> _checkIntroStatus() async {
    try {
      final introCompleted = await IntroHelper.isIntroCompleted();
      setState(() {
        _showIntro = !introCompleted;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _showIntro = true;
        _isLoading = false;
      });
    }
  }

  void _onIntroComplete() {
    setState(() {
      _showIntro = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(onComplete: () {});
    }

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );
    }

    if (_showIntro) {
      return IntroScreen(onComplete: _onIntroComplete);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
      child: const HomeScreen(),
    );
  }
}
