import 'package:bcode/features/auth/data/model/user_model.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

abstract class HiveDBService {
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });
  Future<UserModel> signIn({required String email, required String password});
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
}

class HiveDBServiceImp implements HiveDBService {
  static const _authBoxDB = 'auth', _currentUserKey = 'current_user_id';

  Future<Box<UserModel>> get _authBox async =>
      Hive.openBox<UserModel>(_authBoxDB);
  Future<Box<String>> get _userBox async =>
      Hive.openBox<String>(_currentUserKey);

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final authBox = await _authBox;
    final userBox = await _userBox;

    final user = authBox.values.firstWhereOrNull(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );
    if (user == null) throw Exception('user_does_not_exist'.tr());
    if (user.password != password)
      throw Exception('invalid_email_or_password'.tr());

    await userBox.put(_currentUserKey, user.id);
    return user;
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final authBox = await _authBox;
    final userBox = await _userBox;

    if (authBox.values.any(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    )) {
      throw Exception('email_already_registered'.tr());
    }

    final user = UserModel(
      id: const Uuid().v4(),
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      createdAt: DateTime.now(),
    );

    await authBox.put(user.id, user);
    await userBox.put(_currentUserKey, user.id);
    return user;
  }

  @override
  Future<void> signOut() async => (await _userBox).delete(_currentUserKey);

  @override
  Future<UserModel?> getCurrentUser() async {
    final authBox = await _authBox;
    final id = (await _userBox).get(_currentUserKey);
    return id == null ? null : authBox.get(id);
  }
}
