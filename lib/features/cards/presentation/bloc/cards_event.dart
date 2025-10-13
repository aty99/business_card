import '../../data/model/business_card_model.dart';

abstract class CardsEvent {}

class LoadCards extends CardsEvent {
  final String userId;
  LoadCards(this.userId);
}

class SearchCards extends CardsEvent {
  final String userId;
  final String query;
  SearchCards(this.userId, this.query);
}

class AddCard extends CardsEvent {
  final BusinessCardModel card;
  AddCard(this.card);
}

class UpdateCard extends CardsEvent {
  final BusinessCardModel card;
  UpdateCard(this.card);
}

class DeleteCard extends CardsEvent {
  final String cardId;
  DeleteCard(this.cardId);
}

class GetCardById extends CardsEvent {
  final String cardId;
  GetCardById(this.cardId);
}
