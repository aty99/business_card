import 'dart:ui';
import 'package:hive/hive.dart';
part 'business_card_model.g.dart';

/// Model for business card data
@HiveType(typeId: 1)
class BusinessCardModel extends HiveObject {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? userId;
  @HiveField(2)
  final String? firstName;
  @HiveField(3)
  final String? companyName;
  @HiveField(4)
  final String? jobTitle;
  @HiveField(5)
  final String? email;
  @HiveField(6)
  final String? phone;
  @HiveField(7)
  final String? website;
  @HiveField(8)
  final String? address;
  @HiveField(9)
  final Color? textColor;
  @HiveField(10)
  final DateTime? createdAt;
  @HiveField(11)
  final Color? cardColor;
  @HiveField(12)
  final int? tabId;
  @HiveField(13)
  final String? secName;

  /// Constructor for business card model
  BusinessCardModel({
    this.id,
    this.userId,
    this.firstName,
    this.companyName,
    this.jobTitle,
    this.email,
    this.phone,
    this.cardColor,
    this.textColor,
    this.website,
    this.address,
    this.createdAt,
    this.tabId,
    this.secName,
  });

  /// Create a copy of the business card with updated fields
  BusinessCardModel copyWith({
    String? id,
    String? userId,
    String? firstName,
    String? companyName,
    String? jobTitle,
    String? email,
    String? phone,
    String? website,
    String? address,
    Color? textColor,
    DateTime? createdAt,
    Color? cardColor,
    int? tabId,
    String? secName,
  }) {
    return BusinessCardModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      companyName: companyName ?? this.companyName,
      jobTitle: jobTitle ?? this.jobTitle,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      address: address ?? this.address,
      textColor: textColor ?? this.textColor,
      createdAt: createdAt ?? this.createdAt,
      cardColor: cardColor ?? this.cardColor,
      tabId: tabId ?? this.tabId,
      secName: secName ?? this.secName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'firstName': firstName,
      'companyName': companyName,
      'jobTitle': jobTitle,
      'email': email,
      'phone': phone,
      'website': website,
      'address': address,
      'textColor': textColor,
      'createdAt': createdAt?.toIso8601String(),
      'cardColor': cardColor,
      'tabId': tabId,
      'secName': secName,
    };
  }

  factory BusinessCardModel.fromJson(Map<String, dynamic> json) {
    return BusinessCardModel(
      id: json['id'],
      userId: json['userId'],
      firstName: json['firstName'],
      companyName: json['companyName'],
      jobTitle: json['jobTitle'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      address: json['address'],
      textColor: json['textColor'],
      createdAt: DateTime.parse(json['createdAt'] as String),
      cardColor: json['cardColor'],
      tabId: json['tabId'],
      secName: json['secName'],
    );
  }

  @override
  String toString() {
    return 'BusinessCardModel(id: $id, firstName: $firstName, companyName: $companyName, jobTitle: $jobTitle, email: $email, phone: $phone, website: $website, address: $address, textColor: $textColor, createdAt: $createdAt, cardColor: $cardColor, tabId: $tabId, secName: $secName)';
  }
}
