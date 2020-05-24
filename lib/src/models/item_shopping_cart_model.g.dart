// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_shopping_cart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemShoppingCartAdapter extends TypeAdapter<ItemShoppingCartModel> {
  @override
  final typeId = 2;

  @override
  ItemShoppingCartModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemShoppingCartModel(
      producto: fields[0] as ProductoModel,
      cantidad: fields[1] as int,
      subtotal: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ItemShoppingCartModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.producto)
      ..writeByte(1)
      ..write(obj.cantidad)
      ..writeByte(2)
      ..write(obj.subtotal);
  }
}
