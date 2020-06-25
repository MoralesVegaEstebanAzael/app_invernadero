import 'package:app_invernadero/src/blocs/notification_bloc.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/models/promocion_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/promocion_provider.dart';
import 'package:flutter/material.dart';


class LocalService with ChangeNotifier{
  DBProvider _dbProvider = DBProvider();
  NotificacionesBloc _notificacionesBloc = new NotificacionesBloc();
  PromocionProvider _promocionProvider = new PromocionProvider();

  List<ProductoModel> productos=[];
  List<PromocionModel> promociones=[];

  LocalService(){
    this.getProductos();
    this.getPromociones();
  }
  
  getProductos(){
    print("Cargando productos de local service");

    Map mapa = _dbProvider.productBox.toMap();

    mapa.forEach((k,v){
      ProductoModel item = v;
      productos.add(item);
    });
  } 
  
  // getUnreadNoritications(){ 
  //   print("DESDE SERVICES");
  //   _notificacionesBloc.cargarUnreadNotifications();
  // }
  
  getPromociones()async{
    print("*************cargando promocionessss");
    final list =  await _promocionProvider.loadPromociones();
    
    this.promociones.addAll(list);
    notifyListeners();
  }



}