import 'package:bcode/features/cards/presentation/screens/widgets/card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/cards_bloc.dart';
import '../bloc/cards_event.dart';
import '../bloc/cards_state.dart';

class AllCardsScreen extends StatefulWidget {
  final int tabId;
  const AllCardsScreen(this.tabId, {super.key});

  @override
  State<AllCardsScreen> createState() => _AllCardsScreenState();
}

class _AllCardsScreenState extends State<AllCardsScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final _searchController = TextEditingController();
  late ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Load cards immediately with a small delay to ensure proper initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _loadCards();
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Load cards for current user
  void _loadCards() {
    final authState = context.read<AuthBloc>().state;
    String userId = authState is Authenticated
        ? authState.user.id
        : 'guest_user';
    
    // Force reload by adding the event
    final cardsBloc = context.read<CardsBloc>();
    cardsBloc.add(LoadCards(userId, widget.tabId));
  }

  @override
  /// Build all cards screen UI
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return Container(
      color: AppColors.background,
      child: BlocConsumer<CardsBloc, CardsState>(
        listener: (context, state) {
          if (state is CardsError) {
            context.showErrorSnackBar(state.message);
          } else if (state is CardAdded) {
            context.showSuccessSnackBar('card_saved_successfully'.tr());
            _loadCards();
          } else if (state is CardUpdated) {
            context.showSuccessSnackBar('card_updated_successfully'.tr());
            _loadCards();
          } else if (state is CardDeleted) {
            context.showSuccessSnackBar('card_deleted_successfully'.tr());
            _loadCards();
          }
        },
        buildWhen: (previous, current) {
          // Always rebuild to ensure proper display
          return true;
        },
        builder: (context, state) {
          if (state is CardsLoading) {
            return context.loadingIndicator();
          }

          if (state is CardsLoaded) {
            if (state.cards.isEmpty) {
              return context.noCardsEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async => _loadCards(),
              color: AppColors.primary,
              child: ListView.builder(
                key: PageStorageKey('cards_list_${widget.tabId}'),
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.cards.length,
                itemBuilder: (context, index) {
                  final card = state.cards[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: CardItem(card),
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
