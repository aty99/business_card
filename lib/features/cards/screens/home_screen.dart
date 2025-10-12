import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../models/business_card_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/animated_page_route.dart';
import '../../../utils/custom_snackbar.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/animated_card.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/constants/app_strings.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../bloc/card_bloc.dart';
import '../bloc/card_event.dart';
import '../bloc/card_state.dart';
import 'add_card_screen.dart';
import 'card_detail_screen.dart';

/// Home screen displaying all saved business cards
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;
  bool _isLoggingOut = false;
  bool _isAddingCard = false;

  @override
  void initState() {
    super.initState();
    _loadCards();
    
    // FAB animation
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabScaleAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );
    _fabAnimationController.forward();
  }

  void _loadCards() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<CardBloc>().add(LoadCards(authState.user.id));
    }
  }

  void _searchCards(String query) {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<CardBloc>().add(SearchCards(authState.user.id, query));
    }
  }

  void _navigateToAddCard(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      Navigator.push(
        context,
        SlideFadePageRoute(
          page: BlocProvider.value(
            value: context.read<CardBloc>(),
            child: AddCardScreen(userId: authState.user.id),
          ),
        ),
      );
    }
  }

  void _navigateToCardDetail(BuildContext context, BusinessCardModel card) {
    Navigator.push(
      context,
      SlideFadePageRoute(
        page: CardDetailScreen(card: card),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.error,
                      size: 30,
                    ),
                  ),
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'sign_out'.tr(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'sign_out_confirm'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // Buttons
              Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: AppColors.lightGrey,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Text(
                          'cancel'.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoggingOut ? null : () async {
                          setState(() {
                            _isLoggingOut = true;
                          });
                          
                          Navigator.pop(dialogContext);
                          context.read<AuthBloc>().add(const SignOutRequested());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoggingOut
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Signing out...',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                'sign_out'.tr(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppStrings.myCards.tr(),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'logout') {
                      _showLogoutDialog(context);
                    } else if (value == 'language') {
                      // Toggle language
                      if (context.locale == const Locale('en')) {
                        context.setLocale(const Locale('ar'));
                      } else {
                        context.setLocale(const Locale('en'));
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'profile',
                      enabled: false,
                      child: Row(
                        children: [
                          const Icon(Icons.person, color: AppColors.textPrimary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authState.user.fullName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  authState.user.email,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'language',
                      child: Row(
                        children: [
                          const Icon(Icons.language, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Text('language'.tr()),
                          const Spacer(),
                          Text(
                            context.locale == const Locale('ar') ? 'English' : 'العربية',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          const Icon(Icons.logout, color: AppColors.error),
                          const SizedBox(width: 12),
                          Text('sign_out'.tr()),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _searchCards,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'search'.tr(),
                  hintStyle: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.7),
                    fontSize: 16,
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.search_rounded,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            color: AppColors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _loadCards();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),

          // Cards list
          Expanded(
            child: BlocConsumer<CardBloc, CardState>(
              listener: (context, state) {
                if (state is CardError) {
                  context.showErrorSnackBar(state.message);
                } else if (state is CardAdded) {
                  context.showSuccessSnackBar('Card saved successfully!');
                } else if (state is CardUpdated) {
                  context.showSuccessSnackBar('Card updated successfully!');
                } else if (state is CardDeleted) {
                  context.showSuccessSnackBar('Card deleted successfully!');
                }
              },
              builder: (context, state) {
                if (state is CardLoading) {
                  return context.loadingIndicator(
                    message: AppStrings.loadingMessage.tr(),
                  );
                }

                if (state is CardEmpty) {
                  return context.noCardsEmptyState(
                    onAddCard: () => _navigateToAddCard(context),
                  );
                }

                if (state is CardLoaded) {
                  return _buildCardsList(state.cards);
                }

                return _buildEmptyState();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: _isAddingCard ? null : () async {
              setState(() {
                _isAddingCard = true;
              });
              
              // Scale down animation
              _fabAnimationController.reverse();
              await Future.delayed(const Duration(milliseconds: 100));
              _fabAnimationController.forward();
              
              if (!mounted) return;
              final authState = context.read<AuthBloc>().state;
              if (authState is Authenticated) {
                final cardBloc = context.read<CardBloc>();
                final result = await Navigator.push(
                  context,
                  ScalePageRoute(
                    page: BlocProvider.value(
                      value: cardBloc,
                      child: AddCardScreen(userId: authState.user.id),
                    ),
                  ),
                );
                if (result == true && mounted) {
                  _loadCards();
                }
              }
              
              if (mounted) {
                setState(() {
                  _isAddingCard = false;
                });
              }
            },
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            icon: _isAddingCard
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(
                    Icons.add_rounded,
                    size: 24,
                  ),
            label: Text(
              _isAddingCard ? 'Adding...' : 'add_card'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            heroTag: 'add_card_fab',
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon with gradient background
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.1),
                          AppColors.primary.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.credit_card_off_rounded,
                        size: 60,
                        color: AppColors.primary.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            
            // Title with better styling
            Text(
              'no_cards'.tr(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            
            // Description with better styling
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'no_cards_description'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Decorative dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsList(List<BusinessCardModel> cards) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadCards();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return AnimatedCard(
                index: index,
                onTap: () => _navigateToCardDetail(context, card),
                child: _buildCardItem(card, index),
              );
            },
      ),
    );
  }

  Widget _buildCardItem(BusinessCardModel card, int index) {
    return Material(
      color: Colors.transparent,
      child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  SlideFadePageRoute(
                    page: BlocProvider.value(
                      value: context.read<CardBloc>(),
                      child: CardDetailScreen(card: card),
                    ),
                  ),
                );
                if (result == true) {
                  _loadCards();
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Enhanced Avatar with gradient
                    Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            card.fullName.isNotEmpty
                                ? card.fullName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                    ),
                    const SizedBox(width: 20),

                    // Enhanced Card details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.fullName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            card.jobTitle,
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.business_rounded,
                                size: 16,
                                color: AppColors.primary.withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  card.companyName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Enhanced Arrow icon
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 400 + (index * 100)),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(10 * (1 - value), 0),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: AppColors.primary,
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
}

