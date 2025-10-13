import '../../../../core/services/hive_db.dart';
import '../model/business_card_model.dart';

abstract class CardsLocalDataSource {
  Future<List<BusinessCardModel>> getAllCards(String userId);
  Future<List<BusinessCardModel>> searchCards(String userId, String query);
  Future<BusinessCardModel> addCard(BusinessCardModel card);
  Future<BusinessCardModel> updateCard(BusinessCardModel card);
  Future<void> deleteCard(String cardId);
  Future<BusinessCardModel?> getCardById(String cardId);
}

class CardsLocalDataSourceImpl implements CardsLocalDataSource {
  final HiveDBService _hiveDBService;

  CardsLocalDataSourceImpl(this._hiveDBService);

  @override
  Future<List<BusinessCardModel>> getAllCards(String userId) async {
    try {
      final box = await _hiveDBService.getBox<BusinessCardModel>('business_cards');
      return box.values.where((card) => card.userId == userId).toList();
    } catch (e) {
      throw Exception('Failed to get cards: $e');
    }
  }

  @override
  Future<List<BusinessCardModel>> searchCards(String userId, String query) async {
    try {
      final allCards = await getAllCards(userId);
      if (query.isEmpty) return allCards;

      final lowerQuery = query.toLowerCase();
      return allCards.where((card) {
        return card.fullName.toLowerCase().contains(lowerQuery) ||
            card.companyName.toLowerCase().contains(lowerQuery) ||
            card.jobTitle.toLowerCase().contains(lowerQuery) ||
            card.email.toLowerCase().contains(lowerQuery) ||
            card.phone.contains(query);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search cards: $e');
    }
  }

  @override
  Future<BusinessCardModel> addCard(BusinessCardModel card) async {
    try {
      final box = await _hiveDBService.getBox<BusinessCardModel>('business_cards');
      await box.put(card.id, card);
      return card;
    } catch (e) {
      throw Exception('Failed to add card: $e');
    }
  }

  @override
  Future<BusinessCardModel> updateCard(BusinessCardModel card) async {
    try {
      final box = await _hiveDBService.getBox<BusinessCardModel>('business_cards');
      await box.put(card.id, card);
      return card;
    } catch (e) {
      throw Exception('Failed to update card: $e');
    }
  }

  @override
  Future<void> deleteCard(String cardId) async {
    try {
      final box = await _hiveDBService.getBox<BusinessCardModel>('business_cards');
      await box.delete(cardId);
    } catch (e) {
      throw Exception('Failed to delete card: $e');
    }
  }

  @override
  Future<BusinessCardModel?> getCardById(String cardId) async {
    try {
      final box = await _hiveDBService.getBox<BusinessCardModel>('business_cards');
      return box.get(cardId);
    } catch (e) {
      throw Exception('Failed to get card: $e');
    }
  }
}

