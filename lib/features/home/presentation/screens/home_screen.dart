import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/animated_page_route.dart';
import '../../../../core/widgets/logo_from_image.dart';
import '../../../../core/utils/image_storage.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/screens/sign_in_screen.dart';
import '../../../cards/presentation/screens/all_cards_screen.dart';
import '../../../cards/presentation/screens/add_card_form_screen.dart';
import 'second_tab_screen.dart';
import 'widgets/drawer_item.dart';
import 'widgets/logout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedTabIndex = 0; // 0 for cards, 1 for second tab

  void _navigateToSecondTab() {
    // Just change the selected tab, no navigation
    setState(() {
      _selectedTabIndex = 1;
    });
  }

  Future<void> _openCameraAndNavigate() async {
    try {
      print('Opening gallery...');
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery, // Gallery
        imageQuality: 85,
      );

      print('Image selected: ${image?.path}');

      if (image != null) {
        // Save image to permanent storage
        final String permanentPath = await ImageStorage.saveImage(image.path);
        print('Image saved to: $permanentPath');



        // Navigate to add card form screen with the selected image
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardFormScreen(),
            ),
          );
        }
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error opening gallery: $e');
      if (mounted) {
        context.showErrorSnackBar('فشل في اختيار الصورة: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        // No navigation needed - user stays on home screen after logout
        // The UI will automatically update to show login options in the drawer
      },
      child: Builder(
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
                        title: !isLoggedIn
                            ? 'sign_in'
                            : authState.user.firstName,
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
                ? AllCardsScreen()
                : const SecondTabScreen(),
            bottomNavigationBar: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Left tab icon (Scanner tab)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = 0;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: _selectedTabIndex == 0
                            ? LinearGradient(
                                colors: [
                                  const Color(0xFF2196F3), // Blue
                                  const Color(0xFF4CAF50), // Green
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.grey.shade300,
                                  Colors.grey.shade400,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _selectedTabIndex == 0
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF2196F3,
                                  ).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                  // Right tab icon (Camera tab)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = 1;
                      });
                      // Navigate to profile page
                      _navigateToSecondTab();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: _selectedTabIndex == 1
                            ? LinearGradient(
                                colors: [
                                  const Color(0xFF4CAF50), // Green
                                  const Color(0xFF2196F3), // Blue
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.grey.shade300,
                                  Colors.grey.shade400,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _selectedTabIndex == 1
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF4CAF50,
                                  ).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: Container(
              margin: const EdgeInsets.only(right: 16, bottom: 16),
              child: FloatingActionButton(
                onPressed: _openCameraAndNavigate,
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4CAF50), // Green
                        const Color(0xFF2196F3), // Blue
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
