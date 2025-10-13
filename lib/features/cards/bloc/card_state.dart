import 'package:equatable/equatable.dart';
import '../../../models/business_card_model.dart';

/// Base class for card states
abstract class CardState extends Equatable {
  const CardState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CardInitial extends CardState {
  const CardInitial();
}

/// Loading state
class CardLoading extends CardState {
  const CardLoading();
}


class AddingCard extends CardState {
  const AddingCard();
}

/// Loaded state with list of cards
class CardLoaded extends CardState {
  final List<BusinessCardModel> cards;
  final String? searchQuery;

  const CardLoaded(this.cards, {this.searchQuery});

  @override
  List<Object?> get props => [cards, searchQuery];
}

/// Empty state (no cards)
class CardEmpty extends CardState {
  const CardEmpty();
}

/// Error state
class CardError extends CardState {
  final String message;

  const CardError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Card added successfully
class CardAdded extends CardState {
  final BusinessCardModel card;

  const CardAdded(this.card);

  @override
  List<Object?> get props => [card];
}

/// Card updated successfully
class CardUpdated extends CardState {
  final BusinessCardModel card;

  const CardUpdated(this.card);

  @override
  List<Object?> get props => [card];
}

/// Card deleted successfully
class CardDeleted extends CardState {
  const CardDeleted();
}

