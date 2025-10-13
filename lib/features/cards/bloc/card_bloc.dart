import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/card_repository.dart';
import 'card_event.dart';
import 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final CardRepository cardRepository;

  CardBloc({required this.cardRepository}) : super(const CardInitial()) {
    on<LoadCards>(_onLoadCards);
    on<AddCard>(_onAddCard);
    on<UpdateCard>(_onUpdateCard);
    on<DeleteCard>(_onDeleteCard);
    on<SearchCards>(_onSearchCards);
  }

  Future<void> _onLoadCards(LoadCards event, Emitter<CardState> emit) async {
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

  Future<void> _onAddCard(AddCard event, Emitter<CardState> emit) async {
    try {
      emit(AddingCard());
      final savedCard = await cardRepository.saveCard(event.card);
      emit(CardAdded(savedCard));
      // Reload cards after adding
      add(LoadCards(event.card.userId));
    } catch (e) {
      emit(CardError(e.toString()));
    }
  }

  Future<void> _onUpdateCard(UpdateCard event, Emitter<CardState> emit) async {
    try {
      final updatedCard = await cardRepository.updateCard(event.card);
      emit(CardUpdated(updatedCard));
      // Reload cards after updating
      add(LoadCards(event.card.userId));
    } catch (e) {
      emit(CardError(e.toString()));
    }
  }

  Future<void> _onDeleteCard(DeleteCard event, Emitter<CardState> emit) async {
    try {
      // Get the current user ID from the current state
      final currentState = state;
      String? userId;

      if (currentState is CardLoaded) {
        // Get userId from the first card (all cards belong to same user)
        userId = currentState.cards.isNotEmpty
            ? currentState.cards.first.userId
            : null;
      }

      await cardRepository.deleteCard(event.cardId);
      emit(const CardDeleted());

      // Reload cards after deleting if we have a userId
      if (userId != null) {
        add(LoadCards(userId));
      }
    } catch (e) {
      emit(CardError(e.toString()));
    }
  }

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
