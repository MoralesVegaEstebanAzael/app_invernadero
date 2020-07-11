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
  int semana;
  @HiveField(8)
  String urlImagen;
  @HiveField(9)
  String snombre;
  @HiveField(10)
  String sregion;
  @HiveField(11)
  String sdistrito;
  @HiveField(12)
  String smunicipio;



  
  ProductoModel({
      this.id,
      this.idCultivo,
      this.nombre,
      this.equiKilos,
      this.precioMay,
      this.precioMen,
      this.cantExis,
      this.semana,
      this.urlImagen,
      this.snombre,
      this.sregion,
      this.sdistrito,
      this.smunicipio
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
      id: json["id"],
      idCultivo: json["idCultivo"],
      nombre: json["nombre"],
      equiKilos: json["equiKilos"],
      precioMay: json["precioMay"].toDouble(),
      precioMen: json["precioMen"].toDouble(),
      cantExis: json["cantExis"],
      semana: json["semana"],
      urlImagen: json["url_imagen"],
      snombre: json["snombre"],
      sregion: json["sregion"],
      sdistrito: json["sdistrito"],
      smunicipio: json["smunicipio"]
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
      "snombre" :snombre,
      "sregion":sregion,
      "sdistrito":sdistrito,
      "smunicipio":smunicipio
  };

  ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));

  String productoModelToJson(ProductoModel data) => json.encode(data.toJson());
}



