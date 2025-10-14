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
      id: fields[0] as String?,
      userId: fields[1] as String?,
      firstName: fields[2] as String?,
      companyName: fields[3] as String?,
      jobTitle: fields[4] as String?,
      email: fields[5] as String?,
      phone: fields[6] as String?,
      cardColor: fields[11] as Color?,
      textColor: fields[9] as Color?,
      website: fields[7] as String?,
      address: fields[8] as String?,
      createdAt: fields[10] as DateTime?,
      tabId: fields[12] as int?,
      secName: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessCardModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.firstName)
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
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.cardColor)
      ..writeByte(12)
      ..write(obj.tabId)
      ..writeByte(13)
      ..write(obj.secName);
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
