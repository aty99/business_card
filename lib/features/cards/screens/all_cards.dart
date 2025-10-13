import 'package:bcode/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bcode/features/auth/presentation/bloc/auth_state.dart';
import 'package:bcode/features/cards/bloc/card_bloc.dart';
import 'package:bcode/features/cards/bloc/card_event.dart';
import 'package:bcode/features/cards/bloc/card_state.dart';
import 'package:bcode/features/cards/screens/add_card_screen.dart'
    show AddCardScreen;
import 'package:bcode/features/cards/screens/card_detail_screen.dart';
import 'package:bcode/features/cards/screens/widgets/no_card_widget.dart';
import 'package:bcode/features/cards/screens/widgets/scan_card_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../models/business_card_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/animated_page_route.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/widgets/animated_card.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/constants/app_strings.dart';

class AllCardsScreen extends StatefulWidget {
  const AllCardsScreen({super.key});

  @override
  State<AllCardsScreen> createState() => _AllCardsScreenState();
}

class _AllCardsScreenState extends State<AllCardsScreen> {
  final _searchController = TextEditingController();

  bool _isAddingCard = false;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  void _loadCards() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<CardBloc>().add(LoadCards(authState.user.id));
    }
  }

  void _navigateToCardDetail(BuildContext context, BusinessCardModel card) {
    Navigator.push(
      context,
      SlideFadePageRoute(page: CardDetailScreen(card: card)),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: BlocConsumer<CardBloc, CardState>(
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
            return NoCardsWidget();
          }

          if (state is CardLoaded) {
            return _buildCardsList(state.cards);
          }

          return NoCardsWidget();
        },
      ),
      floatingActionButton: ScanCardFloatingButton(),
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
