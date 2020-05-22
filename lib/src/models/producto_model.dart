// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);
import 'dart:convert';

import 'package:app_invernadero/src/providers/producto_provider.dart';
ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));
String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
  int id;
  int solar;
  int cultivo;
  String nombre;
  int contCaja;
  double precioMayoreo;
  double precioMenudeo;
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
  ){
   

    // ProductoProvider.verify(urlImagen).then((onValue){
    //   if(!onValue){
    //     print(urlImagen);
    //     this.urlImagen=null;
    //     print("sin imagen");
    //   }else{
    //     this.urlImagen = urlImagen;
    //     print(this.urlImagen);
    //     print("con imagen");
    //   }
    // });

   
  }
  //isUrlValid(this.urlImagen)?this.urlImagen:this.urlImagen=null;}

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

  isUrlValid(String url){
     //print("URL::"+url);
    //bool b=  await   ProductoProvider.verify(url);
    //return b;
    
  //   ProductoProvider.ve
  //   ProductoProvider.verify().then((connectionResult) {
    
  // });
  }
}