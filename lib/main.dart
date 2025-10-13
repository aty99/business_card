import 'package:bcode/core/di/injector.dart';
import 'package:bcode/features/splash/screens/init_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'features/auth/data/model/user_model.dart';
import 'models/business_card_model.dart';
import 'repositories/card_repository.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/cards/bloc/card_bloc.dart';
import 'core/utils/app_colors.dart';
import 'core/utils/image_storage.dart';

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
              home: const InitPage(),
            );
          },
        ),
      ),
    );
  }
}
