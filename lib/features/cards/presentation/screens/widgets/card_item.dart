import 'package:bcode/core/utils/animated_page_route.dart';
import 'package:bcode/features/cards/data/model/business_card_model.dart';
import 'package:bcode/features/cards/presentation/bloc/cards_bloc.dart';
import 'package:bcode/features/cards/presentation/bloc/cards_event.dart';
import 'package:bcode/features/cards/presentation/screens/add_card_form_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardItem extends StatelessWidget {
  final BusinessCardModel card;
  const CardItem(this.card, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 230,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: card.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  card.fullName,
                  style: TextStyle(
                    color: card.textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(card.jobTitle, style: TextStyle(color: card.textColor)),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildItem(card.companyName, Icons.comment_bank_outlined),
                    const SizedBox(height: 4),
                    _buildItem(card.address ?? '', Icons.location_pin),
                    const SizedBox(height: 4),
                    _buildItem(card.email, Icons.email_outlined),
                    const SizedBox(height: 4),
                    _buildItem(card.phone, Icons.phone_outlined),
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

  Widget _buildItem(String data, IconData icon) => Row(
    children: [
      Icon(icon, color: card.textColor),
      SizedBox(width: 8),
      Text(data, style: TextStyle(color: card.textColor)),
      Spacer(),
      Icon(Icons.copy, color: card.textColor, size: 18),
    ],
  );

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
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.teal, width: 2),
            ),
            child: const Icon(Icons.edit, color: Colors.teal, size: 22),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () => _deleteCard(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: const Icon(Icons.delete, color: Colors.red, size: 22),
          ),
        ),
      ],
    ),
  );

  Future<void> _navigateToCardDetail(BuildContext context) async {
    await Navigator.push(
      context,
      SlidePageRoute(page: CardFormScreen(existingCard: card)),
    );
  }

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
              context.read<CardsBloc>().add(DeleteCard(card.id));
            },
            child: Text('delete'.tr()),
          ),
        ],
      ),
    );
  }
}
