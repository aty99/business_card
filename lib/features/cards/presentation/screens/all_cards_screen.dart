import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/animated_page_route.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/widgets/animated_card.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/cards_bloc.dart';
import '../bloc/cards_event.dart';
import '../bloc/cards_state.dart';
import 'card_detail_screen.dart';

/// Screen displaying all saved business cards
class AllCardsScreen extends StatefulWidget {
  const AllCardsScreen({super.key});

  @override
  State<AllCardsScreen> createState() => _AllCardsScreenState();
}

class _AllCardsScreenState extends State<AllCardsScreen>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  late ScrollController _scrollController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCards();

    _scrollController = ScrollController();

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadCards() {
    final authState = context.read<AuthBloc>().state;
    String userId;
    
    if (authState is Authenticated) {
      userId = authState.user.id;
    } else {
      // Use guest user ID for non-authenticated users
      userId = 'guest_user';
    }
    
    context.read<CardsBloc>().add(LoadCards(userId));
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query != _searchQuery) {
      setState(() => _searchQuery = query);
      final authState = context.read<AuthBloc>().state;
      String userId;
      
      if (authState is Authenticated) {
        userId = authState.user.id;
      } else {
        userId = 'guest_user';
      }
      
      context.read<CardsBloc>().add(SearchCards(userId, query));
    }
  }


  Future<void> _navigateToCardDetail(dynamic card) async {
    await Navigator.push(
      context,
      ScalePageRoute(
        page: CardDetailScreen(card: card),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          Expanded(
            child: BlocConsumer<CardsBloc, CardsState>(
        listener: (context, state) {
          if (state is CardsError) {
            context.showErrorSnackBar(state.message);
          } else if (state is CardAdded) {
            context.showSuccessSnackBar('card_added_successfully'.tr());
            _loadCards();
          } else if (state is CardUpdated) {
            context.showSuccessSnackBar('card_updated_successfully'.tr());
            _loadCards();
          } else if (state is CardDeleted) {
            context.showSuccessSnackBar('card_deleted_successfully'.tr());
            _loadCards();
          }
        },
        builder: (context, state) {
          if (state is CardsLoading || state is CardsInitial) {
            return context.loadingIndicator();
          }

          if (state is CardsLoaded) {
            if (state.cards.isEmpty && _searchQuery.isEmpty) {
              return context.noCardsEmptyState();
            }

            if (state.cards.isEmpty && _searchQuery.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 80,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'no_results_found'.tr(),
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadCards();
                if (_scrollController.hasClients) {
                  await _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                  );
                }
              },
              color: AppColors.primary,
              child: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'search_cards'.tr(),
                        prefixIcon: Icon(Icons.search, color: AppColors.primary),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.textSecondary.withOpacity(0.1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Cards List
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.cards.length,
                      itemBuilder: (context, index) {
                        final card = state.cards[index];
                        return AnimatedCard(
                          index: index,
                          onTap: () => _navigateToCardDetail(card),
                          child: Row(
                            children: [
                              // Avatar
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
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Card Info
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
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      card.jobTitle,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      card.companyName,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              // Arrow Icon
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          // Initial state
          return context.loadingIndicator();
        },
      ),
          ),
        ],
      ),
    );
  }
}
