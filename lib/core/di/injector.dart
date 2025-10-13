import 'package:bcode/core/services/hive_db.dart';
import 'package:bcode/features/auth/data/datasource/local_datasource.dart';
import 'package:bcode/features/auth/data/repository/auth_repository.dart';
import 'package:bcode/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bcode/features/cards/data/datasource/cards_local_datasource.dart';
import 'package:bcode/features/cards/data/repository/cards_repository.dart';
import 'package:bcode/features/cards/presentation/bloc/cards_bloc.dart';

class Injector {
  final _flyweightMap = <String, dynamic>{};
  static final _singleton = Injector._internal();

  Injector._internal();
  factory Injector() => _singleton;

  //===================[HIVE_DB_SERVICE]===================
  HiveDBService get hiveDBService =>
      _flyweightMap['hiveDBService'] ??= HiveDBServiceImp();

  //===================[AUTH_FEATURE]===================
  AuthBloc get authBloc => AuthBloc(authRepository: authRepository);

  AuthRepository get authRepository => _flyweightMap['authRepository'] ??=
      AuthRepositoryImpl(authLocalDataSource);
      
  AuthLocalDataSource get authLocalDataSource =>
      _flyweightMap['authLocalDataSource'] ??= AuthLocalDataSourceImpl(
        hiveDBService,
      );

  //===================[CARDS_FEATURE]===================
  CardsBloc get cardsBloc => CardsBloc(cardsRepository: cardsRepository);

  CardsRepository get cardsRepository => _flyweightMap['cardsRepository'] ??=
      CardsRepositoryImpl(cardsLocalDataSource);
      
  CardsLocalDataSource get cardsLocalDataSource =>
      _flyweightMap['cardsLocalDataSource'] ??= CardsLocalDataSourceImpl(
        hiveDBService,
      );
}
