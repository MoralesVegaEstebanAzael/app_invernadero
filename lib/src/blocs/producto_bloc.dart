import 'dart:async';

import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/producto_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductoBloc{
  
  static final ProductoBloc _singleton = ProductoBloc._internal();
  factory ProductoBloc() {
    return _singleton;
  }
    
  ProductoBloc._internal();
  //providers
  final _db = new DBProvider();
  final _productoProvider = new ProductoProvider();
  //controllers
  // final _productoController = new BehaviorSubject<List<ProductoModel>>();
  // Stream<List<ProductoModel>> get productoStream =>_productoController.stream;
  
  List<ProductoModel> productsList=new List();
  final _productsController = new BehaviorSubject<List<ProductoModel>>();
  // final _productsController = StreamController<List<ProductoModel>>.broadcast();
  // Function(List<ProductoModel>) get productSink => _productsController.sink.add;k
  Stream<List<ProductoModel>> get productsStream => _productsController.stream;
  

  // void cargarProductos()async{
  //   if(_productoController.isClosed){
      
  //     print("Controller Cerrado");
  //   }else{
  //     print("Controller abierto");
    
  //   }

  //   final productos =await _productoProvider.cargarProductos();
  //   _productoController.sink.add(productos);

    
  // }

  void products()async{
    print("solicitando productos");
    final products = await _productoProvider.cargarProductos();
    if(products!=[] && products.isNotEmpty){
      productsList.addAll(products);
      _productsController.sink.add(productsList);
    }
  }

  dispose(){
   // _productoController?.close();
  }

  box(){ //productos box
    return _db.productosBox();
  }

  // resetPage(){
  //   _productoProvider.indexPage();
  // }
}