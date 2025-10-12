import 'package:bcode/core/di/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'features/auth/data/model/user_model.dart';
import 'models/business_card_model.dart';
import 'repositories/card_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/screens/sign_in_screen.dart';
import 'features/cards/bloc/card_bloc.dart';
import 'features/cards/screens/home_screen.dart';
import 'features/intro/screens/intro_screen.dart';
import 'features/splash/screens/splash_screen.dart';
import 'utils/app_colors.dart';
import 'utils/intro_helper.dart';
import 'utils/image_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(BusinessCardModelAdapter());

  // Initialize repositories
  final cardRepository = CardRepository();
  await cardRepository.init();

  // Clean up any leftover temp files
  await ImageStorage.cleanupTempFiles();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp(cardRepository: cardRepository),
    ),
  );
}

class MyApp extends StatelessWidget {
  final CardRepository cardRepository;

  const MyApp({super.key, required this.cardRepository});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider.value(value: cardRepository)],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                Injector().authBloc..add(const CheckAuthStatus()),
          ),
          BlocProvider(
            create: (context) => CardBloc(cardRepository: cardRepository),
          ),
        ],
        child: Builder(
          builder: (context) {
            return MaterialApp(
              key: ValueKey(context.locale.languageCode),
              title: 'Business Card Manager',
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
                useMaterial3: true,
                primaryColor: AppColors.primary,
                scaffoldBackgroundColor: AppColors.background,
                appBarTheme: const AppBarTheme(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                ),
                cardTheme: CardThemeData(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              home: const AuthWrapper(),
            );
          },
        ),
      ),
    );
  }
}

/// Wrapper to handle authentication state and navigation
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _showIntro = true;
  bool _isLoading = true;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Show splash for at least 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _showSplash = false;
      });

      // Check intro status after splash
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

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: child,
              ),
            );
          },
          child: state is Authenticated
              ? const HomeScreen(key: ValueKey('home'))
              : const SignInScreen(key: ValueKey('signin')),
        );
      },
    );
  }
}
