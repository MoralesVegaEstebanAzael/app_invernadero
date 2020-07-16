// To parse this JSON data, do
//
//     final ofertaModel = ofertaModelFromJson(jsonString);

import 'dart:convert';

OfertaModel ofertaModelFromJson(String str) => OfertaModel.fromJson(json.decode(str));

String ofertaModelToJson(OfertaModel data) => json.encode(data.toJson());

class OfertaModel {
    OfertaModel({
        this.ofertas,
    });

    Map<String, Oferta> ofertas;

    factory OfertaModel.fromJson(Map<String, dynamic> json) => OfertaModel(
        ofertas: Map.from(json["ofertas"]).map((k, v) => MapEntry<String, Oferta>(k, Oferta.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "ofertas": Map.from(ofertas).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}

class Oferta {
    Oferta({
        this.id,
        this.ofertaTipo,
        this.ofertaValor,
        this.productoId,
        this.productoNombre,
        this.descripcion,
        this.urlImagen,
        this.inicio,
        this.fin,
        this.estado,
    });

    int id;
    String ofertaTipo;
    double ofertaValor;
    int productoId;
    String productoNombre;
    String descripcion;
    String urlImagen;
    DateTime inicio;
    DateTime fin;
    String estado;

    factory Oferta.fromJson(Map<String, dynamic> json) => Oferta(
        id: json["id"],
        ofertaTipo: json["oferta_tipo"],
        ofertaValor: json["oferta_valor"].toDouble(),
        productoId: json["producto_id"],
        productoNombre: json["producto_nombre"],
        descripcion: json["descripcion"],
        urlImagen: json["url_imagen"],
        inicio: DateTime.parse(json["inicio"]),
        fin: DateTime.parse(json["fin"]),
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "oferta_tipo": ofertaTipo,
        "oferta_valor": ofertaValor,
        "producto_id": productoId,
        "producto_nombre": productoNombre,
        "descripcion": descripcion,
        "url_imagen": urlImagen,
        "inicio": inicio.toIso8601String(),
        "fin": fin.toIso8601String(),
        "estado": estado,
    };
}
