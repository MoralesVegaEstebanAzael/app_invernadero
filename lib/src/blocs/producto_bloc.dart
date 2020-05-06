import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/providers/producto_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductoBloc{
  final _productoController = new BehaviorSubject<List<ProductoModel>>();
  final _cargandoController = new BehaviorSubject<bool>();
  
  final _productoProvider = new ProductoProvider();


  Stream<List<ProductoModel>> get productoStream =>_productoController.stream;
  Stream<bool> get cargando =>_cargandoController.stream;

  void cargarProductos()async{
    final productos =await _productoProvider.cargarProductos();
    _productoController.sink.add(productos);
  }

  dispose(){
    _productoController.close();
    _cargandoController.close();
  }
}