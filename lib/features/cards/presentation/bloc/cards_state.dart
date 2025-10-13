import '../../data/model/business_card_model.dart';

abstract class CardsState {
  const CardsState();
}

class CardsInitial extends CardsState {}

class CardsLoading extends CardsState {}

class CardsLoaded extends CardsState {
  final List<BusinessCardModel> cards;
  const CardsLoaded(this.cards);
}

class CardAdded extends CardsState {
  final BusinessCardModel card;
  const CardAdded(this.card);
}

class CardUpdated extends CardsState {
  final BusinessCardModel card;
  const CardUpdated(this.card);
}

class CardDeleted extends CardsState {
  const CardDeleted();
}

class CardDetail extends CardsState {
  final BusinessCardModel? card;
  const CardDetail(this.card);
}

class CardsError extends CardsState {
  final String message;
  const CardsError(this.message);
}
