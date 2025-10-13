import '../datasource/local_datasource.dart';
import '../model/card_model.dart';

abstract class CardsRepository {
  Future<List<CardModel>> getAllCards();
  Future<CardModel> addCard({
    required String title,
    required String description,
    required String ownerId,
  });
  Future<void> deleteCard(String cardId);
  Future<CardModel?> getCardById(String cardId);
}

class CardsRepositoryImpl implements CardsRepository {
  final CardsLocalDataSource _cardsLocalDataSource;
  CardsRepositoryImpl(this._cardsLocalDataSource);

  @override
  Future<List<CardModel>> getAllCards() => _cardsLocalDataSource.getAllCards();

  @override
  Future<CardModel> addCard({
    required String title,
    required String description,
    required String ownerId,
  }) => _cardsLocalDataSource.addCard(
    title: title,
    description: description,
    ownerId: ownerId,
  );

  @override
  Future<void> deleteCard(String cardId) => _cardsLocalDataSource.deleteCard(cardId);

  @override
  Future<CardModel?> getCardById(String cardId) => _cardsLocalDataSource.getCardById(cardId);
}
