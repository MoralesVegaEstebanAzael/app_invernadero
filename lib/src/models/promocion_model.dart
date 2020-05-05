import 'dart:convert';

PromocionModel promocionModelFromJson(String str) => PromocionModel.fromJson(json.decode(str));

String promocionModelToJson(PromocionModel data) => json.encode(data.toJson());

class PromocionModel {
    int id;
    String descripcion;
    String urlImagen;


    PromocionModel({
        this.id,
        this.descripcion='',
        this.urlImagen=''
    });
    
    factory PromocionModel.fromJson(Map<String, dynamic> json) => PromocionModel(
        id          : json["id"],
        descripcion      : json["descripcion"],
        urlImagen       : json["url_imagen"],
    );

    Map<String, dynamic> toJson() => {
        "id"               : id,
        "descripcion"      : descripcion,
        "url_imagen"       : urlImagen,
    };
}
