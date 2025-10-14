// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_card_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessCardModelAdapter extends TypeAdapter<BusinessCardModel> {
  @override
  final int typeId = 1;

  @override
  BusinessCardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessCardModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      fullName: fields[2] as String,
      companyName: fields[3] as String,
      jobTitle: fields[4] as String,
      email: fields[5] as String,
      phone: fields[6] as String,
      website: fields[7] as String?,
      address: fields[8] as String?,
      textColor: fields[9] as Color,
      createdAt: fields[10] as DateTime,
      cardColor: fields[11] as Color,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessCardModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.companyName)
      ..writeByte(4)
      ..write(obj.jobTitle)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.phone)
      ..writeByte(7)
      ..write(obj.website)
      ..writeByte(8)
      ..write(obj.address)
      ..writeByte(9)
      ..write(obj.textColor)
      ..writeByte(10)
      ..writeByte(11)
      ..write(obj.cardColor)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessCardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
