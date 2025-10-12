import 'package:bcode/core/services/hive_db.dart';
import 'package:bcode/features/auth/data/datasource/local_datasource.dart';
import 'package:bcode/features/auth/data/repository/auth_repository.dart';
import 'package:bcode/features/auth/presentation/bloc/auth_bloc.dart';

class Injector {
  final _flyweightMap = <String, dynamic>{};
  static final _singleton = Injector._internal();

  Injector._internal();
  factory Injector() => _singleton;

  //===================[AUTH_BLOC]===================
  AuthBloc get authBloc => AuthBloc(authRepository: authRepository);

  AuthRepository get authRepository => _flyweightMap['authRepository'] ??=
      AuthRepositoryImpl(authLocalDataSource);
  AuthLocalDataSource get authLocalDataSource =>
      _flyweightMap['authLocalDataSource'] ??= AuthLocalDataSourceImpl(
        hiveDBService,
      );

  HiveDBService get hiveDBService =>
      _flyweightMap['hiveDBService'] ??= HiveDBServiceImp();
}
