import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/card_repository.dart';
import 'card_event.dart';
import 'card_state.dart';

/// BLoC for managing business cards state
class CardBloc extends Bloc<CardEvent, CardState> {
  final CardRepository cardRepository;

  CardBloc({required this.cardRepository}) : super(const CardInitial()) {
    on<LoadCards>(_onLoadCards);
    on<AddCard>(_onAddCard);
    on<UpdateCard>(_onUpdateCard);
    on<DeleteCard>(_onDeleteCard);
    on<SearchCards>(_onSearchCards);
  }

  /// Load all cards for a user
  Future<void> _onLoadCards(
    LoadCards event,
    Emitter<CardState> emit,
  ) async {
    emit(const CardLoading());
    try {
      final cards = cardRepository.getCardsByUserId(event.userId);
      if (cards.isEmpty) {
        emit(const CardEmpty());
      } else {
        emit(CardLoaded(cards));
      }
    } catch (e) {
      emit(CardError(e.toString()));
    }
  }

  /// Add a new card
  Future<void> _onAddCard(
    AddCard event,
    Emitter<CardState> emit,
  ) async {
    try {
      final savedCard = await cardRepository.saveCard(event.card);
      emit(CardAdded(savedCard));
      // Reload cards after adding
      add(LoadCards(event.card.userId));
    } catch (e) {
      emit(CardError(e.toString()));
    }
  }

  /// Update an existing card
  Future<void> _onUpdateCard(
    UpdateCard event,
    Emitter<CardState> emit,
  ) async {
    try {
      final updatedCard = await cardRepository.updateCard(event.card);
      emit(CardUpdated(updatedCard));
      // Reload cards after updating
      add(LoadCards(event.card.userId));
    } catch (e) {
      emit(CardError(e.toString()));
    }
  }

  /// Delete a card
  Future<void> _onDeleteCard(
    DeleteCard event,
    Emitter<CardState> emit,
  ) async {
    try {
      await cardRepository.deleteCard(event.cardId);
      emit(const CardDeleted());
    } catch (e) {
      emit(CardError(e.toString()));
    }
  }

  /// Search cards
  Future<void> _onSearchCards(
    SearchCards event,
    Emitter<CardState> emit,
  ) async {
    emit(const CardLoading());
    try {
      final cards = cardRepository.searchCards(event.userId, event.query);
      if (cards.isEmpty) {
        emit(const CardEmpty());
      } else {
        emit(CardLoaded(cards, searchQuery: event.query));
      }
    } catch (e) {
      emit(CardError(e.toString()));
    }
  }
}

