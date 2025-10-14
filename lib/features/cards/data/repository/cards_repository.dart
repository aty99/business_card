import '../datasource/cards_local_datasource.dart';
import '../model/business_card_model.dart';

abstract class CardsRepository {
  Future<List<BusinessCardModel>> getCapturedCards(String userId);
  Future<List<BusinessCardModel>> getScannedCards(String userId);

  Future<BusinessCardModel> addCard(BusinessCardModel card);
  Future<BusinessCardModel> updateCard(BusinessCardModel card);
  Future<void> deleteCard(String cardId);
  Future<BusinessCardModel?> getCardById(String cardId);
}

class CardsRepositoryImpl implements CardsRepository {
  final CardsLocalDataSource _cardsLocalDataSource;

  CardsRepositoryImpl(this._cardsLocalDataSource);

  @override
  Future<List<BusinessCardModel>> getCapturedCards(String userId) =>
      _cardsLocalDataSource.getCapturedCards(userId);

  @override
  Future<BusinessCardModel> addCard(BusinessCardModel card) =>
      _cardsLocalDataSource.addCard(card);

  @override
  Future<BusinessCardModel> updateCard(BusinessCardModel card) =>
      _cardsLocalDataSource.updateCard(card);

  @override
  Future<void> deleteCard(String cardId) =>
      _cardsLocalDataSource.deleteCard(cardId);

  @override
  Future<BusinessCardModel?> getCardById(String cardId) =>
      _cardsLocalDataSource.getCardById(cardId);

  @override
  Future<List<BusinessCardModel>> getScannedCards(String userId) =>
      _cardsLocalDataSource.getScannedCards(userId);
}
