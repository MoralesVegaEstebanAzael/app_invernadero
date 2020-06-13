import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:flutter/material.dart';


class LocalService with ChangeNotifier{
  DBProvider _dbProvider = DBProvider();
  
  List<ProductoModel> productos=[];

  LocalService(){
    this.getProductos();
  }
  
  getProductos(){
    print("Cargando productos de local service");

    Map mapa = _dbProvider.productBox.toMap();

    mapa.forEach((k,v){
      ProductoModel item = v;
      productos.add(item);
    });
  }

}