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
  double _subtotal=0;
  ShoppingCartModel({
      this.productoId,
      this.nombre,
      this.contCaja,
      this.precioMayoreo,
      this.precioMenudeo,
      this.cantidad,
      this.imagenUrl
  });//{this._subtotal=0;}

  set key(value){
    _key = value;
  }

  get key{
    return _key;
  }

  set subtotal(value){
    _subtotal = value;
  }

  get subtotal{
    return _subtotal;
  }
}