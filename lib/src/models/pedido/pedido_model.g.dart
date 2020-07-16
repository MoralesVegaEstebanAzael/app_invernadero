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
      pedidos: (fields[0] as Map)?.cast<String, Pedido>(),
    );
  }

  @override
  void write(BinaryWriter writer, PedidoModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.pedidos);
  }
}
