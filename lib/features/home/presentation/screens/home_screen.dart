import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/animated_page_route.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/screens/sign_in_screen.dart';
import '../../../cards/presentation/screens/all_cards_screen.dart';
import 'widgets/drawer_item.dart';
import 'widgets/logout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final isLoggedIn = authState is Authenticated;
    return Scaffold(
      backgroundColor: AppColors.background,
      endDrawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                DrawerItem(
                  title: !isLoggedIn ? 'sign_in' : authState.user.firstName,
                  icon: isLoggedIn ? null : Icons.login,
                  onTap: () {
                    if (isLoggedIn) return;
                    Navigator.push(
                      context,
                      SlidePageRoute(page: const SignInScreen()),
                    );
                  },
                ),
                SizedBox(height: 12),
                if (isLoggedIn) ...[
                  DrawerItem(
                    title: 'sign_out',
                    icon: Icons.logout,
                    onTap: () {
                      showLogoutDialog(context);
                    },
                  ),
                  SizedBox(height: 12),
                ],
                DrawerItem(title: 'privacy_policy', icon: Icons.policy_rounded),
                Spacer(),
                DrawerItem(
                  onTap: () {
                    if (context.locale == const Locale('en')) {
                      context.setLocale(const Locale('ar'));
                    } else {
                      context.setLocale(const Locale('en'));
                    }
                  },
                  title: context.locale == const Locale('ar')
                      ? 'English'
                      : 'العربية',
                  icon: Icons.language,
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Search button on the left
            IconButton(
              icon: Icon(Icons.search, color: AppColors.textPrimary, size: 24),
              onPressed: () {},
            ),
            const Spacer(),
            // Business Code logo in center
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Business',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(Icons.code, color: Colors.white, size: 16),
                    ),
                  ],
                ),
                Text(
                  'Code',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
      body: AllCardsScreen(),
    );
  }
}
