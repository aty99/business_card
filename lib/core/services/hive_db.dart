import 'package:bcode/features/auth/data/model/user_model.dart';
import 'package:bcode/features/cards/data/model/business_card_model.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

abstract class HiveDBService {
  Future<void> init();
  Future<Box<T>> getBox<T>(String boxName);
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });
  Future<UserModel> signIn({required String email, required String password});
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<BusinessCardModel> saveCard(BusinessCardModel card);
  Future<List<BusinessCardModel>> getCardsByUserId(String userId);
  Future<BusinessCardModel?> getCardById(String cardId);
  Future<BusinessCardModel> updateCard(BusinessCardModel card);
  Future<void> deleteCard(String cardId);
  Future<List<BusinessCardModel>> getCapturedCards(String userId);
  Future<List<BusinessCardModel>> getScannedCards(String userId);
}

class HiveDBServiceImp implements HiveDBService {
  static const _authBoxDB = 'auth',
      _currentUserKey = 'current_user_id',
      _cardBoxDB = 'business_cards';

  Future<Box<UserModel>> get _authBox async =>
      Hive.openBox<UserModel>(_authBoxDB);
  Future<Box<String>> get _userBox async =>
      Hive.openBox<String>(_currentUserKey);
  Future<Box<BusinessCardModel>> get _cardBox async =>
      Hive.openBox<BusinessCardModel>(_cardBoxDB);

  @override
  Future<void> init() async {
    // Open all required boxes
    await _authBox;
    await _userBox;
    await _cardBox;
  }

  @override
  Future<Box<T>> getBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return await Hive.openBox<T>(boxName);
  }

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
    if (user.password != password) {
      throw Exception('invalid_email_or_password'.tr());
    }

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

  @override
  Future<BusinessCardModel> saveCard(BusinessCardModel card) async {
    final cardsBox = await _cardBox;
    await cardsBox.put(card.id, card);
    return card;
  }

  @override
  Future<List<BusinessCardModel>> getCardsByUserId(String userId) async {
    final cardsBox = await _cardBox;

    return cardsBox.values.where((card) => card.userId == userId).toList();
  }

  @override
  Future<BusinessCardModel?> getCardById(String cardId) async {
    final cardsBox = await _cardBox;

    return cardsBox.get(cardId);
  }

  @override
  Future<BusinessCardModel> updateCard(BusinessCardModel card) async {
    final cardsBox = await _cardBox;
    await cardsBox.put(card.id, card);
    return card;
  }

  @override
  Future<void> deleteCard(String cardId) async {
    final cardsBox = await _cardBox;

    await cardsBox.delete(cardId);
  }

  @override
  Future<List<BusinessCardModel>> getScannedCards(String userId) async {
    final box = await _cardBox;
    return box.values
        .where((card) => card.userId == userId && card.tabId == 0)
        .toList();
  }

  @override
  Future<List<BusinessCardModel>> getCapturedCards(String userId) async {
    final box = await _cardBox;
    return box.values
        .where((card) => card.userId == userId && card.tabId == 1)
        .toList();
  }
}
