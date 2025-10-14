import '../../../../core/services/hive_db.dart';
import '../model/business_card_model.dart';

abstract class CardsLocalDataSource {
  Future<List<BusinessCardModel>> getCapturedCards(String userId);
  Future<List<BusinessCardModel>> getScannedCards(String userId);
  Future<BusinessCardModel> addCard(BusinessCardModel card);
  Future<BusinessCardModel> updateCard(BusinessCardModel card);
  Future<void> deleteCard(String cardId);
  Future<BusinessCardModel?> getCardById(String cardId);
}

class CardsLocalDataSourceImpl implements CardsLocalDataSource {
  final HiveDBService _hiveDBService;

  CardsLocalDataSourceImpl(this._hiveDBService);

  @override
  Future<List<BusinessCardModel>> getCapturedCards(String userId) async =>
      _hiveDBService.getCapturedCards(userId);

  @override
  Future<BusinessCardModel> updateCard(BusinessCardModel card) async =>
      _hiveDBService.updateCard(card);

  @override
  Future<void> deleteCard(String cardId) async =>
      _hiveDBService.deleteCard(cardId);

  @override
  Future<BusinessCardModel?> getCardById(String cardId) async =>
      _hiveDBService.getCardById(cardId);

  @override
  Future<List<BusinessCardModel>> getScannedCards(String userId) async =>
      _hiveDBService.getScannedCards(userId);

  @override
  Future<BusinessCardModel> addCard(BusinessCardModel card) =>
      _hiveDBService.saveCard(card);
}
