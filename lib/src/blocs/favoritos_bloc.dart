import 'package:app_invernadero/src/models/favorite_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/producto_provider.dart';
import 'package:rxdart/rxdart.dart';

class FavoritosBloc{
  //providers
  final _db = new DBProvider();
  
  
  //Favoritos

  final _isFavoriteController = new BehaviorSubject<bool>();
  final _favoritesController = new BehaviorSubject<List<FavoriteModel>>();
  final _countFavorites = new BehaviorSubject<int>();
  
  Stream<List<FavoriteModel>> get favoritesStream =>_favoritesController.stream;
  Stream<int> get count => _countFavorites.stream;
  Stream<bool> get isFavorite => _isFavoriteController.stream;


  dispose(){
    _isFavoriteController.close();
    _favoritesController.close();
    _countFavorites.close();
  }

  void loadFavorites()async{
    final list = await _db.favoritesList();
    _favoritesController.sink.add(list);
  }

  void addFavorite(ProductoModel producto){
    FavoriteModel favorite =  FavoriteModel(producto:producto);
    _db.addFavorite(favorite);
    // loadFavorites();
  }

  void deleteFavorite(int id){
    _db.deleteFavorite(id);
    loadFavorites();
  }

  void deleteAllFav(){
    _db.deleteAllFavorite();
    loadFavorites();
  }
  
  void favorite(int id){
    bool isFavorite = _db.isFavorite(id); 
    _isFavoriteController.sink.add(isFavorite);
  }


  bool fav(int id){
    return _db.isFavorite(id);
  }
  bool isEmpty(){
   // return db.shoppingCartBoxisEmpty();
    return _db.favoritesisEmpty();
  }
  // box(){
  //   return _db.getFavoriteBox();
  // }

   void filter(String query)async{
    final items = await  _db.favoritesList();
    if(query.isEmpty){
      _favoritesController.sink.add(items);
    }else{
      final newItems= await _db.filterFavorites(items, query);
      _favoritesController.sink.add(newItems);

    }
  }

}