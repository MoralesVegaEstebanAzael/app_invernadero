import 'package:hive/hive.dart';
part 'shopping_cart_model.g.dart';

@HiveType(
  typeId: 1,adapterName: "ShoppingCartAdapter")

class ShoppingCartModel{
  @HiveField(0)
  int productoId;
  @HiveField(1)
  String nombre;
  @HiveField(2)
  int contCaja;
  @HiveField(3)
  double precioMayoreo;
  @HiveField(4)
  double precioMenudeo;
  @HiveField(5)
  int cantidad;
  @HiveField(6)
  String imagenUrl;
  dynamic _key;
  ShoppingCartModel({
      this.productoId,
      this.nombre,
      this.contCaja,
      this.precioMayoreo,
      this.precioMenudeo,
      this.cantidad,
      this.imagenUrl
  });

  set key(value){
    _key = value;
  }

  get key{
    return _key;
  }
}