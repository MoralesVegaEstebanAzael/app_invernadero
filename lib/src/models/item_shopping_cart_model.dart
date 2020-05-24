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
  
  ItemShoppingCartModel({
    this.producto,
    this.cantidad,
    this.subtotal,
  }
  );
}


