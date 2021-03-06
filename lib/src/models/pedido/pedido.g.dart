// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pedido.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PedidoAdapter extends TypeAdapter<Pedido> {
  @override
  final typeId = 15;

  @override
  Pedido read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pedido(
      id: fields[0] as int,
      idCliente: fields[1] as int,
      fechaSolicitud: fields[2] as DateTime,
      estatus: fields[3] as String,
      total: fields[4] as double,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      idVenta: fields[7] as int,
      totalPagado: fields[8] as double,
      tipoEntrega: fields[9] as String,
      detalles: (fields[10] as List)?.cast<Detalle>(),
      status: (fields[11] as List)?.cast<Status>(),
    );
  }

  @override
  void write(BinaryWriter writer, Pedido obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.idCliente)
      ..writeByte(2)
      ..write(obj.fechaSolicitud)
      ..writeByte(3)
      ..write(obj.estatus)
      ..writeByte(4)
      ..write(obj.total)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.idVenta)
      ..writeByte(8)
      ..write(obj.totalPagado)
      ..writeByte(9)
      ..write(obj.tipoEntrega)
      ..writeByte(10)
      ..write(obj.detalles)
      ..writeByte(11)
      ..write(obj.status);
  }
}
