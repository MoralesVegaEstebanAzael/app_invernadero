import 'package:app_invernadero/src/blocs/notification_bloc.dart';
import 'package:app_invernadero/src/models/oferta_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/models/promocion_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/oferta_provider.dart';
import 'package:app_invernadero/src/providers/promocion_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


class PromocionService with ChangeNotifier{
  
  
  // PromocionProvider _promocionProvider = new PromocionProvider();
  // List<PromocionModel> promociones=[];
  
  // final _promocionesController = new BehaviorSubject<List<PromocionModel>>();
  // Stream<List<PromocionModel>> get promocionStream =>_promocionesController.stream;
  
  /***news methos */
  OfertaProvider _ofertaProvider = new OfertaProvider();
  List<Oferta> ofertas=[];

  final _ofertasController = new BehaviorSubject<List<Oferta>>();
  Stream<List<Oferta>> get ofertaStream =>_ofertasController.stream;
  
  
  PromocionService(){
    this.getPromociones();
  }
  
  
  dispose(){
   // _promocionesController.close();
    _ofertasController.close();
  }

  getPromociones()async{
    print("*************cargando ofertas***************");
    final list =  await _ofertaProvider.loadPromociones();


    if(list!=[] && list.isNotEmpty){
      this.ofertas.addAll(list);
      _ofertasController.sink.add(ofertas);
    }

   
    notifyListeners();
  }





}