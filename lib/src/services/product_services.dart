import 'package:app_invernadero/src/blocs/notification_bloc.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/models/promocion_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/producto_provider.dart';
import 'package:app_invernadero/src/providers/promocion_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ProductoService with ChangeNotifier{
  ProductoProvider _productoProvider = ProductoProvider();
  List<ProductoModel> productList= List();
  final _productsController = new BehaviorSubject<List<ProductoModel>>();
  Stream<List<ProductoModel>> get productsStream =>_productsController.stream;

  ProductoService(){
    this.getProductos();
  }
  
  
  dispose(){
    _productsController.close();
  }

  void getProductos()async{
    print(">>>>>>>>>>>>>cargando PRODUCTOS>>>>>>>>>>>>>");
    final list =  await _productoProvider.cargarProductos();
    if(list!=[] && list.isNotEmpty){
      this.productList.addAll(list);
      _productsController.sink.add(productList);
    }
    notifyListeners();
  }



}