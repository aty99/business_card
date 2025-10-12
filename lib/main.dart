import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/user_model.dart';
import 'models/business_card_model.dart';
import 'repositories/auth_repository.dart';
import 'repositories/card_repository.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/bloc/auth_state.dart';
import 'features/auth/screens/sign_in_screen.dart';
import 'features/cards/bloc/card_bloc.dart';
import 'features/cards/screens/home_screen.dart';
import 'utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(BusinessCardModelAdapter());

  // Initialize repositories
  final authRepository = AuthRepository();
  final cardRepository = CardRepository();
  await authRepository.init();
  await cardRepository.init();

  runApp(MyApp(
    authRepository: authRepository,
    cardRepository: cardRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final CardRepository cardRepository;

  const MyApp({
    Key? key,
    required this.authRepository,
    required this.cardRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: cardRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(authRepository: authRepository)
              ..add(const CheckAuthStatus()),
          ),
          BlocProvider(
            create: (context) => CardBloc(cardRepository: cardRepository),
          ),
        ],
        child: MaterialApp(
          title: 'Business Card Manager',
          debugShowCheckedModeBanner: false,
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
        ),
      ),
    );
  }
}

/// Wrapper to handle authentication state and navigation
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
