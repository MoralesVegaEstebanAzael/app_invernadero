import 'package:app_invernadero/src/blocs/bottom_nav_bloc.dart';
import 'package:app_invernadero/src/blocs/client_bloc.dart';
import 'package:app_invernadero/src/blocs/favoritos_bloc.dart';
import 'package:app_invernadero/src/blocs/feature_bloc.dart';
import 'package:app_invernadero/src/blocs/login_bloc.dart';
import 'package:app_invernadero/src/blocs/producto_bloc.dart';
import 'package:app_invernadero/src/blocs/promociones_bloc.dart';
import 'package:app_invernadero/src/blocs/shopping_cart_bloc.dart'; 
import 'package:flutter/material.dart'; 

class Provider extends InheritedWidget with ChangeNotifier{
  final loginBloc = LoginBloc();
  final _promocionesBloc = PromocionBloc();
  final _productosBloc = ProductoBloc();
  final _shoppingCart = ShoppingCartBloc();     
  final _favoritosBloc = FavoritosBloc();
  final _featureBloc = FeatureBloc();
  final _bottomNavBloc = BottomNavBloc();
  final _clientBloc = ClientBloc();
  
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

  static FavoritosBloc favoritosBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._favoritosBloc;
  }


  static BottomNavBloc bottomNavBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._bottomNavBloc;    
  }

  static FeatureBloc featureBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._featureBloc;    
  }

  static ClientBloc clientBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._clientBloc;    
  }

  dispose(){
    _promocionesBloc.dispose();
    _productosBloc.dispose();
  }

}
