import 'package:app_invernadero/src/blocs/login_bloc.dart';
import 'package:app_invernadero/src/blocs/producto_bloc.dart';
import 'package:app_invernadero/src/blocs/promociones_bloc.dart';
import 'package:app_invernadero/src/blocs/shopping_cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Provider extends InheritedWidget{
  final loginBloc = LoginBloc();
  final _promocionesBloc = PromocionBloc();
  final _productosBloc = ProductoBloc();
  final _shoppingCart = ShoppingCartBloc();
  

  static Provider _instancia;

  factory Provider({Key key,Widget child}){
    if(_instancia== null){
      _instancia =  new Provider._internal(key: key,child: child);
    }
    return _instancia;
  }
  
  Provider._internal({Key key,Widget child})
    :super(key:key,child:child);    
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) =>true;

  static LoginBloc of(BuildContext context ){
    
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
  
  static PromocionBloc promocionesBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._promocionesBloc;
  }

  static ProductoBloc productoBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._productosBloc;
  }

  static ShoppingCartBloc shoppingCartBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._shoppingCart;
  }

  dispose(){
    _promocionesBloc.dispose();
  }

}
