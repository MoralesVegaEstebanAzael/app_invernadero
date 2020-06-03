// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClientAdapter extends TypeAdapter<ClientModel> {
  @override
  final typeId = 4;

  @override
  ClientModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientModel(
      id: fields[0] as String,
      nombre: fields[1] as String,
      ap: fields[2] as String,
      am: fields[3] as String,
      direccion: fields[4] as String,
      telefono: fields[5] as String,
      celular: fields[6] as String,
      rfc: fields[7] as String,
      urlImagen: fields[8] as String,
      lat: fields[9] as double,
      lng: fields[10] as double,
      correo: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClientModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.ap)
      ..writeByte(3)
      ..write(obj.am)
      ..writeByte(4)
      ..write(obj.direccion)
      ..writeByte(5)
      ..write(obj.telefono)
      ..writeByte(6)
      ..write(obj.celular)
      ..writeByte(7)
      ..write(obj.rfc)
      ..writeByte(8)
      ..write(obj.urlImagen)
      ..writeByte(9)
      ..write(obj.lat)
      ..writeByte(10)
      ..write(obj.lng)
      ..writeByte(11)
      ..write(obj.correo);
  }
}
