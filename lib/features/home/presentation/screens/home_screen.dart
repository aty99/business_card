import 'package:bcode/features/cards/presentation/screens/scanned_cards.dart';
import 'package:bcode/features/home/presentation/screens/widgets/bottom_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/animated_page_route.dart';
import '../../../../core/widgets/logo_from_image.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/screens/sign_in_screen.dart';
import '../../../cards/presentation/screens/captured_cards.dart';
import '../../../cards/presentation/bloc/cards_bloc.dart';
import '../../../cards/presentation/bloc/cards_event.dart';
import 'widgets/drawer_item.dart';
import 'widgets/logout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load initial data when home screen is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshCards();
    });
  }

  /// Refresh cards when switching tabs
  void _refreshCards() {
    final authState = context.read<AuthBloc>().state;
    String userId = authState is Authenticated
        ? authState.user.id
        : 'guest_user';
    context.read<CardsBloc>().add(LoadCards(userId, _selectedTabIndex));
  }

  @override
  Widget build(BuildContext context) {

    return Builder(
      builder: (context) {
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
                    DrawerItem(
                      title: 'privacy_policy',
                      icon: Icons.policy_rounded,
                    ),
                    Spacer(),
                    DrawerItem(
                      onTap: () {
                        if (context.locale == const Locale('en')) {
                          context.setLocale(const Locale('ar'));
                        } else {
                          context.setLocale(const Locale('en'));
                        }
                        Navigator.of(context).pop();
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
            title: Stack(
              children: [
                Center(child: LogoFromImage(fontSize: 16)),
                // Search button on the left
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: _selectedTabIndex == 0
              ? const ScannedCards()
              : const CapturedCards(),
          bottomNavigationBar: Container(
            height: 80,
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = 0;
                    });
                    // Force reload cards when switching tabs
                    _refreshCards();
                  },
                  child: BottomBtn(
                    _selectedTabIndex == 0,
                    Icons.qr_code_scanner,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = 1;
                    });
                    // Force reload cards when switching tabs
                    _refreshCards();
                  },
                  child: BottomBtn(_selectedTabIndex == 1, Icons.camera_alt),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
