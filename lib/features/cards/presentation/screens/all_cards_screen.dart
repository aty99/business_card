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
    String userId =
        authState is Authenticated ? authState.user.id : 'guest_user';
    context.read<CardsBloc>().add(LoadCards(userId));
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query != _searchQuery) {
      setState(() => _searchQuery = query);
      final authState = context.read<AuthBloc>().state;
      String userId =
          authState is Authenticated ? authState.user.id : 'guest_user';
      context.read<CardsBloc>().add(SearchCards(userId, query));
    }
  }

  Future<void> _navigateToCardDetail(dynamic card) async {
    await Navigator.push(
      context,
      ScalePageRoute(page: CardDetailScreen(card: card)),
    );
  }

  void _deleteCard(dynamic card) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('delete_card'.tr()),
        content: Text('confirm_delete_card'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CardsBloc>().add(DeleteCard(card.id));
            },
            child: Text('delete'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
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
                    Icon(Icons.search_off,
                        size: 80,
                        color: AppColors.textSecondary.withOpacity(0.5)),
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
              onRefresh: () async => _loadCards(),
              color: AppColors.primary,
              child: ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: state.cards.length,
                itemBuilder: (context, index) {
                  final card = state.cards[index];
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFCA28),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 16,
                              left: 16,
                              right: 16,
                              child: Center(
                                child: Text(
                                  card.fullName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),

                            Positioned(
                              left: 12,
                              top: 40,
                              child: Column(
                                children: List.generate(
                                  4,
                                  (i) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6),
                                    child: Icon(
                                      Icons.copy,
                                      size: 20,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          
                            Positioned(
                              right: 16,
                              bottom: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        card.companyName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                       const SizedBox(width: 4),
                                      const Icon(Icons.comment_bank_rounded,
                                          size: 14, color: Colors.white),
                                    ],
                                  ),
                                
                                  const SizedBox(height: 4),
                                     Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      
                                      Text(
                                        card.jobTitle,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.work,
                                          size: 14, color: Colors.white),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      Text(
                                        card.email,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.email,
                                          size: 14, color: Colors.white),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                    
                                      Text(
                                        card.phone,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                         const SizedBox(width: 4),
                                        const Icon(Icons.phone,
                                          size: 14, color: Colors.white),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Action buttons (edit/delete)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => _navigateToCardDetail(card),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.teal, width: 2),
                              ),
                              child: const Icon(Icons.edit,
                                  color: Colors.teal, size: 22),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () => _deleteCard(card),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.red, width: 2),
                              ),
                              child: const Icon(Icons.delete,
                                  color: Colors.red, size: 22),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            );
          }

          return context.loadingIndicator();
        },
      ),
    );
  }
}
