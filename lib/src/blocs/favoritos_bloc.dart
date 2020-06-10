import 'package:app_invernadero/src/models/favorite_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/producto_provider.dart';
import 'package:rxdart/rxdart.dart';

class FavoritosBloc{
  //providers
  final _productoProvider = new ProductoProvider();
  final _db = new DBProvider();
 
  
  //Favoritos

  final _isFavoriteController = new BehaviorSubject<bool>();
  
  final _favoritesController = new BehaviorSubject<List<ProductoModel>>();
  
  final _countFavorites = new BehaviorSubject<int>();
  
  Stream<List<ProductoModel>> get favoritosStream =>_favoritesController.stream;
  Stream<int> get count => _countFavorites.stream;
   Stream<bool> get isFavorite => _isFavoriteController.stream;

  dispose(){
    _isFavoriteController.close();
    _favoritesController.close();
    _countFavorites.close();
  }

  //favoritos
  void loadFavorites()async{
    final productos =await _productoProvider.findProducts(_db.getFavorites());
    _favoritesController.sink.add(productos);
  } 

  void addFavorite(ProductoModel producto){
    FavoriteModel favorite =  FavoriteModel(producto:producto);
    _db.addFavorite(favorite);
  }

  void deleteFavorite(int id){
    _db.deleteFavorite(id);
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