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


  //favoritos

  void loadFavorites()async{
    final productos =await _productoProvider.findProducts(_db.getFavorites());
    _productoController.sink.add(productos);
  }


  void addFavorite(int id){
    _cargandoController.sink.add(true);
    _db.addFavorite(id);
    _cargandoController.sink.add(false);
  }

  void deleteFavorite(int id){
    _cargandoController.sink.add(true);
    _db.deleteFavorite(id);
    _cargandoController.sink.add(false);
    loadFavorites();
  }

  
  void favorite(int id){
    bool isFavorite = _db.isFavorite(id); 
    _isFavoriteController.sink.add(isFavorite);
  }


  bool fav(int id){
    return _db.isFavorite(id);
  }

  box(){
    return _db.getFavoriteBox();
  }
}