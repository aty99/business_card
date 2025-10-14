import 'package:bcode/features/auth/data/datasource/local_datasource.dart';
import '../model/user_model.dart';

abstract class AuthRepository {
  Future<bool> isLoggedIn();
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

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _authLocalDataSource;
  AuthRepositoryImpl(this._authLocalDataSource);

  @override
  Future<bool> isLoggedIn() async =>
      await _authLocalDataSource.getCurrentUser() != null;

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) => _authLocalDataSource.signUp(
    email: email,
    password: password,
    firstName: firstName,
    lastName: lastName,
  );
  @override
  Future<UserModel> signIn({required String email, required String password}) =>
      _authLocalDataSource.signIn(email: email, password: password);
  @override
  Future<void> signOut() => _authLocalDataSource.signOut();
  @override
  Future<UserModel?> getCurrentUser() => _authLocalDataSource.getCurrentUser();
  @override
  Future<void> clearUserData() => _authLocalDataSource.clearUserData();
}
