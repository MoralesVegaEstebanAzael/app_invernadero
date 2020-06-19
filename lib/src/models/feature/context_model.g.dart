// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'context_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContextAdapter extends TypeAdapter<Context> {
  @override
  final typeId = 12;

  @override
  Context read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Context(
      id: fields[0] as String,
      text: fields[1] as String,
      wikidata: fields[2] as String,
      shortCode: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Context obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.wikidata)
      ..writeByte(3)
      ..write(obj.shortCode);
  }
}
