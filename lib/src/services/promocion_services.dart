import 'package:app_invernadero/src/blocs/notification_bloc.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/models/promocion_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/promocion_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


class PromocionService with ChangeNotifier{
  PromocionProvider _promocionProvider = new PromocionProvider();
  List<PromocionModel> promociones=[];
  final _promocionesController = new BehaviorSubject<List<PromocionModel>>();
  Stream<List<PromocionModel>> get promocionStream =>_promocionesController.stream;
  PromocionService(){
    this.getPromociones();
  }
  
  
  dispose(){
    _promocionesController.close();
  }

  getPromociones()async{
    print("*************cargando promocionessss***************");
    final list =  await _promocionProvider.loadPromociones();
    if(list!=[] && list.isNotEmpty){
      this.promociones.addAll(list);
      _promocionesController.sink.add(promociones);
    }

   
    notifyListeners();
  }



}