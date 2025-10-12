import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/business_card_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/animated_page_route.dart';
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
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

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

  @override
  void dispose() {
    _searchController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Business Cards'),
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
                      context.read<AuthBloc>().add(const SignOutRequested());
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          const Icon(Icons.person, color: AppColors.textPrimary),
                          const SizedBox(width: 12),
                          Column(
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
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: AppColors.error),
                          SizedBox(width: 12),
                          Text('Logout'),
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
            child: TextField(
              controller: _searchController,
              onChanged: _searchCards,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'Search by name or company...',
                hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.7)),
                prefixIcon: const Icon(Icons.search, color: AppColors.white),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.white),
                        onPressed: () {
                          _searchController.clear();
                          _loadCards();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Cards list
          Expanded(
            child: BlocConsumer<CardBloc, CardState>(
              listener: (context, state) {
                if (state is CardError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                } else if (state is CardAdded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Card saved successfully!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is CardLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is CardEmpty) {
                  return _buildEmptyState();
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
        child: FloatingActionButton.extended(
          onPressed: () async {
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
          },
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add),
          label: const Text('Add Card'),
          heroTag: 'add_card_fab',
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
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Icon(
                Icons.credit_card_off,
                size: 80,
                color: AppColors.grey.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No business cards yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the + button to add your first card',
              style: TextStyle(
                color: AppColors.textLight,
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
          // Staggered animation for list items
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 300 + (index * 100)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(30 * (1 - value), 0),
                  child: child,
                ),
              );
            },
            child: _buildCardItem(card, index),
          );
        },
      ),
    );
  }

  Widget _buildCardItem(BusinessCardModel card, int index) {
    return Hero(
      tag: 'card_${card.id}',
      child: Material(
        color: Colors.transparent,
        child: Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar with Hero animation
                  Hero(
                    tag: 'card_avatar_${card.id}',
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          card.fullName.isNotEmpty
                              ? card.fullName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Card details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.fullName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          card.jobTitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          card.companyName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Arrow icon with subtle animation
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: child,
                      );
                    },
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.grey,
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

