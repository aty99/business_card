import 'package:bcode/core/utils/animated_page_route.dart';
import 'package:bcode/features/cards/data/model/business_card_model.dart';
import 'package:bcode/features/cards/presentation/bloc/cards_bloc.dart';
import 'package:bcode/features/cards/presentation/bloc/cards_event.dart';
import 'package:bcode/features/cards/presentation/screens/add_card_form_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bcode/core/utils/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget to display a business card item
class CardItem extends StatelessWidget {
  final BusinessCardModel card;
  const CardItem(this.card, {super.key});

  @override
  /// Build card item UI
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 240,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: card.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  card.firstName ?? ' ${card.secName ?? ''}',
                  maxLines: 1,
                  style: TextStyle(
                    color: card.textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  card.jobTitle ?? '',
                  maxLines: 1,
                  style: TextStyle(color: card.textColor),
                ),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildItem(
                      card.companyName ?? '',
                      Icons.comment_bank_outlined,
                    ),
                    const SizedBox(height: 4),
                    _buildItem(card.address ?? '', Icons.location_pin),
                    const SizedBox(height: 4),
                    _buildItem(card.email ?? '', Icons.email_outlined),
                    const SizedBox(height: 4),
                    _buildItem(card.phone ?? '', Icons.phone_outlined),
                    const SizedBox(height: 4),
                    _buildItem(card.website ?? '', Icons.language_outlined),
                  ],
                ),
              ],
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  /// Build row for card field
  Widget _buildItem(String data, IconData icon) => Row(
    children: [
      Icon(icon, color: card.textColor),
      SizedBox(width: 8),
      Text(data, maxLines: 1, style: TextStyle(color: card.textColor)),
      Spacer(),
      InkWell(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: data));
        },
        child: Icon(Icons.copy, color: card.textColor, size: 18),
      ),
    ],
  );

  /// Build edit/delete action buttons
  Widget _buildActionButtons(BuildContext context) => Align(
    alignment: Alignment.bottomCenter,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _navigateToCardDetail(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.tealPrimary, width: 2),
            ),
            child: Icon(Icons.edit, color: AppColors.tealPrimary, size: 22),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () => _deleteCard(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.error, width: 2),
            ),
            child: Icon(Icons.delete, color: AppColors.error, size: 22),
          ),
        ),
      ],
    ),
  );

  /// Navigate to card detail/edit screen
  Future<void> _navigateToCardDetail(BuildContext context) async {
    await Navigator.push(
      context,
      SlidePageRoute(page: CardFormScreen(existingCard: card, isEdit: true)),
    );
  }

  /// Show delete card confirmation dialog
  void _deleteCard(BuildContext context) {
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
              context.read<CardsBloc>().add(DeleteCard(card.id!, card.tabId!));
            },
            child: Text('delete'.tr()),
          ),
        ],
      ),
    );
  }
}
