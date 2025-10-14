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
  const AllCardsScreen({super.key});

  @override
  State<AllCardsScreen> createState() => _AllCardsScreenState();
}

class _AllCardsScreenState extends State<AllCardsScreen>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _loadCards();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadCards() {
    final authState = context.read<AuthBloc>().state;
    String userId = authState is Authenticated
        ? authState.user.id
        : 'guest_user';
    context.read<CardsBloc>().add(LoadCards(userId));
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
            if (state.cards.isEmpty) {
              return context.noCardsEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async => _loadCards(),
              color: AppColors.primary,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                itemCount: state.cards.length,
                itemBuilder: (context, index) {
                  final card = state.cards[index];
                  return CardItem(card);
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
