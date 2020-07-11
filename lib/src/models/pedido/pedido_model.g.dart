// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pedido_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PedidoModelAdapter extends TypeAdapter<PedidoModel> {
  @override
  final typeId = 17;

  @override
  PedidoModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PedidoModel(
      pedido: fields[0] as Pedido,
      detalles: (fields[1] as Map)?.cast<String, Detalle>(),
    );
  }

  @override
  void write(BinaryWriter writer, PedidoModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.pedido)
      ..writeByte(1)
      ..write(obj.detalles);
  }
}
