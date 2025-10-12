import 'package:hive_flutter/hive_flutter.dart';
import '../models/business_card_model.dart';

/// Repository for handling business card operations
/// Manages CRUD operations for business cards
class CardRepository {
  static const String _cardsBoxName = 'business_cards';

  Box<BusinessCardModel>? _cardsBox;

  /// Initialize Hive box
  Future<void> init() async {
    _cardsBox = await Hive.openBox<BusinessCardModel>(_cardsBoxName);
  }

  /// Save a new business card
  Future<BusinessCardModel> saveCard(BusinessCardModel card) async {
    await _cardsBox!.put(card.id, card);
    return card;
  }

  /// Get all cards for a specific user
  List<BusinessCardModel> getCardsByUserId(String userId) {
    return _cardsBox?.values
            .where((card) => card.userId == userId)
            .toList() ??
        [];
  }

  /// Get a single card by ID
  BusinessCardModel? getCardById(String cardId) {
    return _cardsBox?.get(cardId);
  }

  /// Update an existing card
  Future<BusinessCardModel> updateCard(BusinessCardModel card) async {
    await _cardsBox!.put(card.id, card);
    return card;
  }

  /// Delete a card
  Future<void> deleteCard(String cardId) async {
    await _cardsBox!.delete(cardId);
  }

  /// Get all cards (for debugging)
  List<BusinessCardModel> getAllCards() {
    return _cardsBox?.values.toList() ?? [];
  }

  /// Search cards by name or company
  List<BusinessCardModel> searchCards(String userId, String query) {
    final userCards = getCardsByUserId(userId);
    if (query.isEmpty) return userCards;

    final lowerQuery = query.toLowerCase();
    return userCards.where((card) {
      return card.fullName.toLowerCase().contains(lowerQuery) ||
          card.companyName.toLowerCase().contains(lowerQuery) ||
          card.jobTitle.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}

