import 'package:app_invernadero/src/blocs/notification_bloc.dart';
import 'package:app_invernadero/src/blocs/shopping_cart_bloc.dart';
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

  ShoppingCartBloc _shoppingCartBloc = ShoppingCartBloc();

  ProductoService(){
    this.getProductos();
    this.fetchProducts();
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

  void fetchProducts()async{
    final list = await _productoProvider.shoppingCartFetch();
    if(list!=[]&&list.isNotEmpty){
      _shoppingCartBloc.scFetchList = list;
    }
    notifyListeners();
  }

}