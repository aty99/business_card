import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

  @HiveField(3)
  final String firstName;

  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final String lastName;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.firstName,
    required this.createdAt,
    required this.lastName,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? password,
    String? firstName,
    DateTime? createdAt,
    String? lastName,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      createdAt: createdAt ?? this.createdAt,
      lastName: lastName ?? this.lastName,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, firstName: $firstName, createdAt: $createdAt, lastName: $lastName)';
  }
}
