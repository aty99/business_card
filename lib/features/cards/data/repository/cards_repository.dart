import '../datasource/cards_local_datasource.dart';
import '../model/business_card_model.dart';

abstract class CardsRepository {
  Future<List<BusinessCardModel>> getAllCards(String userId);
  Future<List<BusinessCardModel>> searchCards(String userId, String query);
  Future<BusinessCardModel> addCard(BusinessCardModel card);
  Future<BusinessCardModel> updateCard(BusinessCardModel card);
  Future<void> deleteCard(String cardId);
  Future<BusinessCardModel?> getCardById(String cardId);
}

class CardsRepositoryImpl implements CardsRepository {
  final CardsLocalDataSource _cardsLocalDataSource;
  
  CardsRepositoryImpl(this._cardsLocalDataSource);

  @override
  Future<List<BusinessCardModel>> getAllCards(String userId) =>
      _cardsLocalDataSource.getAllCards(userId);

  @override
  Future<List<BusinessCardModel>> searchCards(String userId, String query) =>
      _cardsLocalDataSource.searchCards(userId, query);

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
}
