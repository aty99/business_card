import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/animated_page_route.dart';
import '../../../../core/utils/custom_snackbar.dart';
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

  void _deleteCard(dynamic card) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('delete_card'.tr()),
          content: Text('confirm_delete_card'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<CardsBloc>().add(DeleteCard(card.id));
              },
              child: Text('delete'.tr()),
            ),
          ],
        );
      },
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
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            children: [
                              // Main Card - exactly like the image
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF8E1), // Light yellow background like in image
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      // Left Side (Arabic content)
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Arabic name - orange color like in image
                                            Text(
                                              card.fullName,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFFF8A65), // Light orange like in image
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // Arabic job title - lighter yellow like in image
                                            Text(
                                              card.jobTitle,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFFFFCC80), // Lighter yellow like in image
                                              ),
                                            ),
                                            const Spacer(),
                                            // Vertical icons - small yellow squares like in image
                                            Column(
                                              children: List.generate(5, (index) => Container(
                                                margin: const EdgeInsets.only(bottom: 4),
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFFCC80), // Light yellow like in image
                                                  borderRadius: BorderRadius.circular(2),
                                                ),
                                              )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Right Side (English content - no dark background, white text on yellow)
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            // Company name with icon
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                const Icon(
                                                  Icons.business,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  card.companyName,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            
                                            // Location
                                            if (card.address?.isNotEmpty == true)
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  const Icon(
                                                    Icons.location_on,
                                                    size: 16,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    card.address!,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            const SizedBox(height: 4),
                                            
                                            // Email
                                            if (card.email.isNotEmpty)
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  const Icon(
                                                    Icons.email,
                                                    size: 16,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    card.email,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            const SizedBox(height: 4),
                                            
                                            // Phone
                                            if (card.phone.isNotEmpty)
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  const Icon(
                                                    Icons.phone,
                                                    size: 16,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    card.phone,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            const Spacer(),
                                            
                                            // Website icon
                                            if (card.website?.isNotEmpty == true)
                                              const Icon(
                                                Icons.language,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              // Action buttons below the card - exactly like in the image
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Edit button with text - green filled circle
                                  GestureDetector(
                                    onTap: () => _navigateToCardDetail(card),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.15),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            size: 22,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Edit',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                  // Delete button with text - red filled circle
                                  GestureDetector(
                                    onTap: () => _deleteCard(card),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.15),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            size: 22,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Delete',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
