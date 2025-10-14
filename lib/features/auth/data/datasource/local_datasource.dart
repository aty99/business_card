import 'package:bcode/core/services/hive_db.dart';
import 'package:bcode/features/auth/data/model/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,

  });
  Future<UserModel> signIn({required String email, required String password});
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<void> clearUserData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final HiveDBService _hiveDBService;

  AuthLocalDataSourceImpl(this._hiveDBService);

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) => _hiveDBService.signUp(
    email: email,
    password: password,
    firstName: firstName,
    lastName: lastName,
  );
  @override
  Future<UserModel> signIn({required String email, required String password}) =>
      _hiveDBService.signIn(email: email, password: password);

  @override
  Future<void> signOut() => _hiveDBService.signOut();

  @override
  Future<UserModel?> getCurrentUser() => _hiveDBService.getCurrentUser();

  @override
  Future<void> clearUserData() => _hiveDBService.clearUserData();
}
