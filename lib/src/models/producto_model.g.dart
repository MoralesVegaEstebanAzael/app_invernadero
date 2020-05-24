// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'producto_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductoAdapter extends TypeAdapter<ProductoModel> {
  @override
  final typeId = 3;

  @override
  ProductoModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductoModel(
      id: fields[0] as int,
      solar: fields[1] as int,
      cultivo: fields[2] as int,
      nombre: fields[3] as String,
      contCaja: fields[4] as int,
      precioMayoreo: fields[5] as double,
      precioMenudeo: fields[6] as double,
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
      ..write(obj.solar)
      ..writeByte(2)
      ..write(obj.cultivo)
      ..writeByte(3)
      ..write(obj.nombre)
      ..writeByte(4)
      ..write(obj.contCaja)
      ..writeByte(5)
      ..write(obj.precioMayoreo)
      ..writeByte(6)
      ..write(obj.precioMenudeo)
      ..writeByte(7)
      ..write(obj.urlImagen);
  }
}
