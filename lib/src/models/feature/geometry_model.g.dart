// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geometry_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeometryAdapter extends TypeAdapter<Geometry> {
  @override
  final typeId = 11;

  @override
  Geometry read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Geometry(
      type: fields[0] as String,
      coordinates: (fields[1] as List)?.cast<double>(),
    );
  }

  @override
  void write(BinaryWriter writer, Geometry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.coordinates);
  }
}
