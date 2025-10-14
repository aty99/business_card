import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ColorAdapter extends TypeAdapter<Color> {
  @override
  final int typeId = 2; // choose a unique ID

  @override
  Color read(BinaryReader reader) {
    // Read the integer value stored for the color
    final int value = reader.readInt();
    return Color(value);
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    // Write the integer representation of the color
    writer.writeInt(obj.value);
  }
}
