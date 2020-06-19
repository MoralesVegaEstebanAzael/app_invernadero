// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'properties_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PropertiesAdapter extends TypeAdapter<Properties> {
  @override
  final typeId = 14;

  @override
  Properties read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Properties(
      accuracy: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Properties obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.accuracy);
  }
}
