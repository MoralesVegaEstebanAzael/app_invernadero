import 'dart:convert';


import 'package:app_invernadero/app_config.dart';
import 'package:hive/hive.dart';
part 'client_model.g.dart';


@HiveType(
  typeId: AppConfig.hive_type_4 ,adapterName: AppConfig.hive_adapter_4)


class ClientModel {
   @HiveField(0)
    int id; 
    @HiveField(1)
    String nombre;
    @HiveField(2)
    String ap;
    @HiveField(3)
    String am;
    @HiveField(4)
    String direccion;
    @HiveField(5)
    String telefono;
    @HiveField(6)
    String celular;
    @HiveField(7)
    String rfc;
    @HiveField(8)
    String urlImagen;
    @HiveField(9)
    double lat;
    @HiveField(10)
    double lng;
    @HiveField(11)
    String correo;


    ClientModel({
        this.id,
        this.nombre,
        this.ap,
        this.am,
        this.direccion,
        this.telefono,
        this.celular,
        this.rfc,
        this.urlImagen,
        this.lat,
        this.lng,
        this.correo,
    });
   

    factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        id: json["id"],
        nombre: json["nombre"],
        ap: json["ap"],
        am: json["am"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        celular: json["celular"],
        rfc: json["rfc"],
        urlImagen: json["url_imagen"],
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
        correo: json["correo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "ap": ap,
        "am": am,
        "direccion": direccion,
        "telefono": telefono,
        "celular": celular,
        "rfc": rfc,
        "url_imagen": urlImagen,
        "lat": lat,
        "lng": lng,
        "correo": correo,
    };

  ClientModel clientModelFromJson(String str) => ClientModel.fromJson(json.decode(str));

  String clientModelToJson(ClientModel data) => json.encode(data.toJson());
}

