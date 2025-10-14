import 'dart:ui';

import 'package:hive/hive.dart';

part 'business_card_model.g.dart';

/// Business card model
/// Stores business card information including company details and contact info
@HiveType(typeId: 1)
class BusinessCardModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId; // Owner of the card

  @HiveField(2)
  final String fullName;

  @HiveField(3)
  final String companyName;

  @HiveField(4)
  final String jobTitle;

  @HiveField(5)
  final String email;

  @HiveField(6)
  final String phone;

  @HiveField(7)
  final String? website;

  @HiveField(8)
  final String? address;

  @HiveField(9)
  final Color textColor;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final Color cardColor;

  BusinessCardModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.companyName,
    required this.jobTitle,
    required this.email,
    required this.phone,
    required this.cardColor,
    required this.textColor,
    this.website,
    this.address,

    required this.createdAt,
  });

  BusinessCardModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? companyName,
    String? jobTitle,
    String? email,
    String? phone,
    String? website,
    String? address,
    Color? textColor,
    DateTime? createdAt,
    Color? cardColor,
  }) {
    return BusinessCardModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      companyName: companyName ?? this.companyName,
      jobTitle: jobTitle ?? this.jobTitle,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      address: address ?? this.address,
      textColor: textColor ?? this.textColor,
      createdAt: createdAt ?? this.createdAt,
      cardColor: cardColor ?? this.cardColor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'companyName': companyName,
      'jobTitle': jobTitle,
      'email': email,
      'phone': phone,
      'website': website,
      'address': address,
      'textColor': textColor,
      'createdAt': createdAt.toIso8601String(),
      'cardColor': cardColor,
    };
  }

  factory BusinessCardModel.fromJson(Map<String, dynamic> json) {
    return BusinessCardModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      companyName: json['companyName'] as String,
      jobTitle: json['jobTitle'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String?,
      address: json['address'] as String?,
      textColor: json['textColor'],
      createdAt: DateTime.parse(json['createdAt'] as String),
      cardColor: json['cardColor'],
    );
  }

  @override
  String toString() {
    return 'BusinessCardModel(id: $id, fullName: $fullName, companyName: $companyName, jobTitle: $jobTitle)';
  }
}
