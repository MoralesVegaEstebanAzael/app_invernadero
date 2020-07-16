// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detalle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DetallePedidoAdapter extends TypeAdapter<Detalle> {
  @override
  final typeId = 16;

  @override
  Detalle read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Detalle(
      idPedido: fields[0] as int,
      nombreProducto: fields[1] as String,
      cantidadPedido: fields[2] as double,
      cantidadSurtida: fields[3] as double,
      idProducto: fields[4] as int,
      unidadM: fields[5] as String,
      precioUnitario: fields[6] as double,
      subtotal: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Detalle obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.idPedido)
      ..writeByte(1)
      ..write(obj.nombreProducto)
      ..writeByte(2)
      ..write(obj.cantidadPedido)
      ..writeByte(3)
      ..write(obj.cantidadSurtida)
      ..writeByte(4)
      ..write(obj.idProducto)
      ..writeByte(5)
      ..write(obj.unidadM)
      ..writeByte(6)
      ..write(obj.precioUnitario)
      ..writeByte(7)
      ..write(obj.subtotal);
  }
}
