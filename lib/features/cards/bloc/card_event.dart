import 'package:equatable/equatable.dart';
import '../../../models/business_card_model.dart';

/// Base class for card events
abstract class CardEvent extends Equatable {
  const CardEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all cards for the current user
class LoadCards extends CardEvent {
  final String userId;

  const LoadCards(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Event to add a new card
class AddCard extends CardEvent {
  final BusinessCardModel card;

  const AddCard(this.card);

  @override
  List<Object?> get props => [card];
}

/// Event to update an existing card
class UpdateCard extends CardEvent {
  final BusinessCardModel card;

  const UpdateCard(this.card);

  @override
  List<Object?> get props => [card];
}

/// Event to delete a card
class DeleteCard extends CardEvent {
  final String cardId;

  const DeleteCard(this.cardId);

  @override
  List<Object?> get props => [cardId];
}

/// Event to search cards
class SearchCards extends CardEvent {
  final String userId;
  final String query;

  const SearchCards(this.userId, this.query);

  @override
  List<Object?> get props => [userId, query];
}

