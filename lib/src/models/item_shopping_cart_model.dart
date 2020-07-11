import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:hive/hive.dart';
part 'item_shopping_cart_model.g.dart';

@HiveType(
  typeId: 2,adapterName: "ItemShoppingCartAdapter")

class ItemShoppingCartModel{
  @HiveField(0)
  ProductoModel producto;
  @HiveField(1)
  int cantidad;
  @HiveField(2)
  double subtotal;
  @HiveField(3)
  bool unidad; //true-> cajas false->kilos
  @HiveField(4)
  double kilos;

  ItemShoppingCartModel({
    this.producto,
    this.cantidad,
    this.subtotal,
    this.unidad,
    this.kilos
  }
  );
}


