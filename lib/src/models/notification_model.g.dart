// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationsAdapter extends TypeAdapter<NotificacionModel> {
  @override
  final typeId = 8;

  @override
  NotificacionModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificacionModel(
      id: fields[0] as String,
      type: fields[1] as String,
      notifiableType: fields[2] as String,
      notifiableId: fields[3] as String,
      data: fields[4] as dynamic,
      readAt: fields[5] as String,
      createdAt: fields[6] as String,
      updatedAt: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NotificacionModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.notifiableType)
      ..writeByte(3)
      ..write(obj.notifiableId)
      ..writeByte(4)
      ..write(obj.data)
      ..writeByte(5)
      ..write(obj.readAt)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }
}
