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
  final _productoController = new BehaviorSubject<List<ProductoModel>>();
  Stream<List<ProductoModel>> get productoStream =>_productoController.stream;
  
  

  void cargarProductos()async{
    if(_productoController.isClosed){
      
      print("Controller Cerrado");
    }else{
      print("Controller abierto");
    
    }

    final productos =await _productoProvider.cargarProductos();
    _productoController.sink.add(productos);

    
  }

  dispose(){
   // _productoController?.close();
  }

  box(){ //productos box
    return _db.productosBox();
  }
}