// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);
import 'dart:convert';

import 'package:hive/hive.dart';
part 'producto_model.g.dart';


@HiveType(
  typeId: 6,adapterName: "ProductoAdapter")

class ProductoModel {
  @HiveField(0)
  int id;
  @HiveField(1)
  int idCultivo;
  @HiveField(2)
  String nombre;
  @HiveField(3)
  int equiKilos;
  @HiveField(4)
  double precioMay;
  @HiveField(5)
  double precioMen;
  @HiveField(6)
  int cantExis;
  @HiveField(7)
  String urlImagen;
  
  ProductoModel({
      this.id,
      this.idCultivo,
      this.nombre,
      this.equiKilos,
      this.precioMay,
      this.precioMen,
      this.cantExis,
      this.urlImagen,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
      id: json["id"],
      idCultivo: json["idCultivo"],
      nombre: json["nombre"],
      equiKilos: json["equiKilos"],
      precioMay: json["precioMay"].toDouble(),
      precioMen: json["precioMen"].toDouble(),
      cantExis: json["cantExis"],
      urlImagen: json["url_imagen"],
  );

  Map<String, dynamic> toJson() => {
      "id": id,
      "idCultivo": idCultivo,
      "nombre": nombre,
      "equiKilos": equiKilos,
      "precioMay": precioMay,
      "precioMen": precioMen,
      "cantExis": cantExis,
      "url_imagen": urlImagen,
  };

  ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));

  String productoModelToJson(ProductoModel data) => json.encode(data.toJson());
}



