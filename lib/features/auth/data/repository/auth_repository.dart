import 'package:bcode/features/auth/data/datasource/local_datasource.dart';
import '../model/user_model.dart';

abstract class AuthRepository {
  Future<bool> isLoggedIn();
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
  });
  Future<UserModel> signIn({required String email, required String password});
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
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
    required String fullName,
  }) => _authLocalDataSource.signUp(
    email: email,
    password: password,
    fullName: fullName,
  );
  @override
  Future<UserModel> signIn({required String email, required String password}) =>
      _authLocalDataSource.signIn(email: email, password: password);
  @override
  Future<void> signOut() => _authLocalDataSource.signOut();
  @override
  Future<UserModel?> getCurrentUser() => _authLocalDataSource.getCurrentUser();
}
