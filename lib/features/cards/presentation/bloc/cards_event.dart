import '../../data/model/business_card_model.dart';

/// Base class for card events
abstract class CardsEvent {}

/// Event to load all cards for a user
class LoadCards extends CardsEvent {
  final String userId;
  final int type;
  LoadCards(this.userId, this.type);
}

/// Event to add a new card
class AddCard extends CardsEvent {
  final BusinessCardModel card;
  AddCard(this.card);
}

/// Event to update an existing card
class UpdateCard extends CardsEvent {
  final BusinessCardModel card;
  UpdateCard(this.card);
}

/// Event to delete a card
class DeleteCard extends CardsEvent {
  final String cardId;
  final int type;
  DeleteCard(this.cardId, this.type);
}

/// Event to get card details by ID
class GetCardById extends CardsEvent {
  final String cardId;
  GetCardById(this.cardId);
}
