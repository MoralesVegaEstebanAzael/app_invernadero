// To parse this JSON data, do
//
//     final promocionModel = promocionModelFromJson(jsonString);

import 'dart:convert';

PromocionModel promocionModelFromJson(String str) => PromocionModel.fromJson(json.decode(str));

String promocionModelToJson(PromocionModel data) => json.encode(data.toJson());

class PromocionModel {
    PromocionModel({
        this.id,
        this.idProducto,
        this.descripcion,
        this.urlImagen,
        this.inicio,
        this.fin,
        this.valor,
        this.estado,
    });

    int id;
    int idProducto;
    String descripcion;
    String urlImagen;
    DateTime inicio;
    DateTime fin;
    int valor;
    String estado;

    factory PromocionModel.fromJson(Map<String, dynamic> json) => PromocionModel(
        id: json["id"],
        idProducto: json["id_producto"],
        descripcion: json["descripcion"],
        urlImagen: json["url_imagen"],
        inicio: DateTime.parse(json["inicio"]),
        fin: DateTime.parse(json["fin"]),
        valor: json["valor"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_producto": idProducto,
        "descripcion": descripcion,
        "url_imagen": urlImagen,
        "inicio": "${inicio.year.toString().padLeft(4, '0')}-${inicio.month.toString().padLeft(2, '0')}-${inicio.day.toString().padLeft(2, '0')}",
        "fin": "${fin.year.toString().padLeft(4, '0')}-${fin.month.toString().padLeft(2, '0')}-${fin.day.toString().padLeft(2, '0')}",
        "valor": valor,
        "estado": estado,
    };
}
