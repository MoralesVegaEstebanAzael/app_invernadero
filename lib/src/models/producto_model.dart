// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);
import 'dart:convert';

import 'package:hive/hive.dart';
part 'producto_model.g.dart';

@HiveType(
  typeId: 3,adapterName: "ProductoAdapter")

class ProductoModel {
  @HiveField(0)
  int id;
  @HiveField(1)
  int solar;
  @HiveField(2)
  int cultivo;
  @HiveField(3)
  String nombre;
  @HiveField(4)
  int contCaja;
  @HiveField(5)
  double precioMayoreo;
  @HiveField(6)
  double precioMenudeo;
  @HiveField(7)
  String urlImagen;

  ProductoModel({
      this.id,
      this.solar,
      this.cultivo,
      this.nombre,
      this.contCaja,
      this.precioMayoreo,
      this.precioMenudeo,
      this.urlImagen,
  }
  );

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
      id: json["id"],
      solar: json["solar"],
      cultivo: json["cultivo"],
      nombre: json["nombre"],
      contCaja: json["cont_caja"],
      precioMayoreo: json["precio_mayoreo"].toDouble(),
      precioMenudeo: json["precio_menudeo"].toDouble(),
      urlImagen: json["url_imagen"],
  );


  Map<String, dynamic> toJson() => {
      "id": id,
      "solar": solar,
      "cultivo": cultivo,
      "nombre": nombre,
      "cont_caja": contCaja,
      "precio_mayoreo": precioMayoreo,
      "precio_menudeo": precioMenudeo,
      "url_imagen": urlImagen,
  };


  ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));
  String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

}