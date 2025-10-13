// Cards Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cards_event.dart';
import 'cards_state.dart';

class CardsBloc extends Bloc<CardsEvent, CardsState> {
  CardsBloc() : super(CardsInitial());
  // TODO: Implement bloc logic
}
