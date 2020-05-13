// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_cart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShoppingCartAdapter extends TypeAdapter<ShoppingCartModel> {
  @override
  final typeId = 1;

  @override
  ShoppingCartModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShoppingCartModel(
      productoId: fields[0] as int,
      nombre: fields[1] as String,
      contCaja: fields[2] as int,
      precioMayoreo: fields[3] as double,
      precioMenudeo: fields[4] as double,
      cantidad: fields[5] as int,
      imagenUrl: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShoppingCartModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.productoId)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.contCaja)
      ..writeByte(3)
      ..write(obj.precioMayoreo)
      ..writeByte(4)
      ..write(obj.precioMenudeo)
      ..writeByte(5)
      ..write(obj.cantidad)
      ..writeByte(6)
      ..write(obj.imagenUrl);
  }
}
