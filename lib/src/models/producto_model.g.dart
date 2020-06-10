// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'producto_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductoAdapter extends TypeAdapter<ProductoModel> {
  @override
  final typeId = 6;

  @override
  ProductoModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductoModel(
      id: fields[0] as int,
      idCultivo: fields[1] as int,
      nombre: fields[2] as String,
      equiKilos: fields[3] as int,
      precioMay: fields[4] as double,
      precioMen: fields[5] as double,
      cantExis: fields[6] as int,
      urlImagen: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProductoModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.idCultivo)
      ..writeByte(2)
      ..write(obj.nombre)
      ..writeByte(3)
      ..write(obj.equiKilos)
      ..writeByte(4)
      ..write(obj.precioMay)
      ..writeByte(5)
      ..write(obj.precioMen)
      ..writeByte(6)
      ..write(obj.cantExis)
      ..writeByte(7)
      ..write(obj.urlImagen);
  }
}
