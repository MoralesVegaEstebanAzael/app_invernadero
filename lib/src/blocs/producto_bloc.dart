import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/producto_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductoBloc{
  //providers
  final _db = new DBProvider();
  final _productoProvider = new ProductoProvider();

  //productos
  final _productoController = new BehaviorSubject<List<ProductoModel>>();
  final _cargandoController = new BehaviorSubject<bool>();
  
  Stream<List<ProductoModel>> get productoStream =>_productoController.stream;
  Stream<bool> get cargando =>_cargandoController.stream;
  
  //Favoritos

  final _isFavoriteController = new BehaviorSubject<bool>();
  final _favoritesController = new BehaviorSubject<List<ProductoModel>>();
  final _countFavorites = new BehaviorSubject<int>();

  Stream<List<ProductoModel>> get favoritesStream =>_favoritesController.stream;
  Stream<int> get count => _countFavorites.stream;
   Stream<bool> get isFavorite => _isFavoriteController.stream;


  void cargarProductos()async{
    final productos =await _productoProvider.cargarProductos();
    _productoController.sink.add(productos);
  }

  dispose(){
    _productoController.close();
    _cargandoController.close();

    _isFavoriteController.close();
  }

  

  box(){
    return _db.getFavoriteBox();
  }
}