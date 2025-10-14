import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/cards_repository.dart';
import 'cards_event.dart';
import 'cards_state.dart';

/// Bloc for managing card events and state
class CardsBloc extends Bloc<CardsEvent, CardsState> {
  final CardsRepository cardsRepository;

  CardsBloc({required this.cardsRepository}) : super(CardsInitial()) {
    on<LoadCards>(_onLoadCards);
    on<AddCard>(_onAddCard);
    on<UpdateCard>(_onUpdateCard);
    on<DeleteCard>(_onDeleteCard);
    on<GetCardById>(_onGetCardById);
  }

  /// Handle loading all cards for a user
  Future<void> _onLoadCards(LoadCards event, Emitter<CardsState> emit) async {
    emit(CardsLoading());
    try {
      if (event.userId.isEmpty) {
        emit(const CardsLoaded([]));
        return;
      }
      final cards = event.type == 0
          ? await cardsRepository.getScannedCards(event.userId)
          : await cardsRepository.getCapturedCards(event.userId);

      emit(CardsLoaded(cards));
    } catch (e) {
      emit(CardsError(e.toString()));
    }
  }

  /// Handle adding a new card
  Future<void> _onAddCard(AddCard event, Emitter<CardsState> emit) async {
    try {
      final card = await cardsRepository.addCard(event.card);
      emit(CardAdded(card));

      // Reload cards after adding
      add(LoadCards(event.card.userId!, event.card.tabId!));
    } catch (e) {
      emit(CardsError(e.toString()));
    }
  }

  /// Handle updating an existing card
  Future<void> _onUpdateCard(UpdateCard event, Emitter<CardsState> emit) async {
    try {
      final card = await cardsRepository.updateCard(event.card);
      emit(CardUpdated(card));

      // Reload cards after updating
      add(LoadCards(event.card.userId!, event.card.tabId!));
    } catch (e) {
      emit(CardsError(e.toString()));
    }
  }

  /// Handle deleting a card
  Future<void> _onDeleteCard(DeleteCard event, Emitter<CardsState> emit) async {
    try {
      // Get the current user ID from the current state
      final currentState = state;
      String? userId;

      if (currentState is CardsLoaded) {
        // Get userId from the first card (all cards belong to same user)
        userId = currentState.cards.isNotEmpty
            ? currentState.cards.first.userId
            : null;
      }

      await cardsRepository.deleteCard(event.cardId);
      emit(const CardDeleted());

      // Reload cards after deleting if we have a userId
      if (userId != null) {
        add(LoadCards(userId, event.type));
      }
    } catch (e) {
      emit(CardsError(e.toString()));
    }
  }

  /// Handle getting card details by ID
  Future<void> _onGetCardById(
    GetCardById event,
    Emitter<CardsState> emit,
  ) async {
    emit(CardsLoading());
    try {
      final card = await cardsRepository.getCardById(event.cardId);
      emit(CardDetail(card));
    } catch (e) {
      emit(CardsError(e.toString()));
    }
  }
}
