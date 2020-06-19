// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeatureAdapter extends TypeAdapter<Feature> {
  @override
  final typeId = 13;

  @override
  Feature read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Feature(
      id: fields[0] as String,
      type: fields[1] as String,
      placeType: (fields[2] as List)?.cast<String>(),
      relevance: fields[3] as double,
      properties: fields[4] as Properties,
      text: fields[5] as String,
      placeName: fields[6] as String,
      center: (fields[7] as List)?.cast<double>(),
      geometry: fields[8] as Geometry,
      context: (fields[9] as List)?.cast<Context>(),
    );
  }

  @override
  void write(BinaryWriter writer, Feature obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.placeType)
      ..writeByte(3)
      ..write(obj.relevance)
      ..writeByte(4)
      ..write(obj.properties)
      ..writeByte(5)
      ..write(obj.text)
      ..writeByte(6)
      ..write(obj.placeName)
      ..writeByte(7)
      ..write(obj.center)
      ..writeByte(8)
      ..write(obj.geometry)
      ..writeByte(9)
      ..write(obj.context);
  }
}
