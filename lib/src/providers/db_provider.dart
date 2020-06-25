import 'package:app_invernadero/src/models/client_model.dart';
import 'package:app_invernadero/src/models/favorite_model.dart';
import 'package:app_invernadero/src/models/feature/context_model.dart';
import 'package:app_invernadero/src/models/feature/geometry_model.dart';
import 'package:app_invernadero/src/models/feature/properties_model.dart';
import 'package:app_invernadero/src/models/feature_model.dart';
import 'package:app_invernadero/src/models/item_shopping_cart_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/models/notification_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider{  
  Box itemsShoppingBox;
  Box dataBaseBox;
  Box clientBox;
  Box favoriteBox;
  Box productBox;
  Box notificationBox;
  Box featuresBox;

  List<FavoriteModel> _favoritesList;

  static DBProvider _instance =
      DBProvider.internal();

  DBProvider.internal();

  factory DBProvider() => _instance;

  
  Future initDB()async{
    var path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
    //adapter register
    Hive.registerAdapter(ItemShoppingCartAdapter());
    Hive.registerAdapter(ProductoAdapter());
    Hive.registerAdapter(ClientAdapter());
    Hive.registerAdapter(FavoriteAdapter());
    Hive.registerAdapter(NotificationsAdapter());
    
    Hive.registerAdapter(FeatureAdapter());
    Hive.registerAdapter(ContextAdapter());
    Hive.registerAdapter(GeometryAdapter());
    Hive.registerAdapter(PropertiesAdapter());

    //shoppingCartBox= await Hive.openBox("shoppingCart");
    dataBaseBox = await Hive.openBox("db");

    itemsShoppingBox = await Hive.openBox("itemsShopping");
    //productoBox = await Hive.openBox("productoBox");

    favoriteBox = await Hive.openBox("favorite");
    clientBox = await Hive.openBox("client");

    productBox = await Hive.openBox("producto");
    notificationBox = await Hive.openBox("notification");
    featuresBox = await Hive.openBox("features");

    return true;
  }
  
  // contains(ShoppingCartModel item){  
  //   Map map =  shoppingCartBox.toMap(); 
  //   ShoppingCartModel itemRet;
  //   map.forEach((k,v){
  //     ShoppingCartModel art = v;
  //     if(art.productoId==item.productoId){
  //       itemRet = v;
  //       itemRet.key = k;
  //     }
  //   }); 
  //   return itemRet;

  // }
  
  

  // insert(ShoppingCartModel item)async{
  //   //try{
  //   ShoppingCartModel _item = contains(item);
  //   if(_item!=null){ 
  //    // print("ITEM ${_item.nombre} key: ${_item.key}");
  //     _item.cantidad++;
  //     _item.subtotal += 1 * item.precioMenudeo;
  //     //replantear respecto a precio menudeo y mayoreo
      
  //     await updateItemShoppingCart(_item);
  //   }else{
  //     item.subtotal = item.precioMenudeo*item.cantidad;
  //     shoppingCartBox.add(item);
  //   }
  //   // } on Error catch (e) {
  //   //   print('Error: $e');
  //   // }
   
  // }
  

  // double totalShoppingCart(){
  //   double total = 0;
  //   Map map = shoppingCartBox.toMap();
  //   ShoppingCartModel item;
  //   map.forEach((k,v){
  //     item =v;
  //     total += item.cantidad*item.precioMenudeo;
  //   });

  //   return total;
  //   //return dataBaseBox.get('total')==null? 0:dataBaseBox.get('total');
  // }

  // int countItemsShopCart(){
  //   //int i=0;
  //   return shoppingCartBox.length;
  // }

  // Future updateItemShoppingCart(ShoppingCartModel item)async{
  //   await shoppingCartBox.put(item.key, item);
  // }

  
  // Future deleteItemShoppingCart(ShoppingCartModel item)async{
  //   await shoppingCartBox.delete(item.key);
  // }
  
  // Future deleteAllItems()async{
  //   await shoppingCartBox.clear();
  // }
  
  // Box getShoppingCartBox(){
  //   return shoppingCartBox;
  // }



  // Future<List<ShoppingCartModel>> getShoppingCart()async{
  //   Map map = await shoppingCartBox.toMap();
  //   List<ShoppingCartModel> itemsBox = [];
  //   map.forEach((k,v){
  //     ShoppingCartModel item = v;
  //     item.key = k;
  //     itemsBox.add(item);
     
  //   });  
  //   return  itemsBox;
  // }

  // bool shoppingCartBoxisEmpty(){
  //   return shoppingCartBox.isEmpty;
  // }
  
  void dispose(){
    //shoppingCartBox.close(); 
  }

  //** FAVORITOS** */

  Future<List<FavoriteModel>> filterFavorites(
    List<FavoriteModel> lista,String query)async{
    List<FavoriteModel> newList=
      lista.where(
        (f) => f.producto.nombre.toUpperCase().contains(query.toUpperCase())
      ).toList();

    return newList;
  }


  bool favoritesisEmpty(){
    return favoriteBox.isEmpty;
  }
  
  Future<List<FavoriteModel>> favoritesList()async{
    Map map =  favoriteBox.toMap();
    List<FavoriteModel> favorites =  map.values.toList().cast();
    return favorites;
  }
  void favList(){
    Map map = favoriteBox.toMap();
    _favoritesList = map.values.toList().cast();
  }
  void addFavorite(FavoriteModel favorito){
    favoriteBox.put(favorito.producto.id, favorito);
  }


  bool isFavorite(int id){
    //print("isFavorite: " +favoriteBox.get(id));
    if(favoriteBox.get(id)!=null)
      return true;
    return false;
  }

  void deleteFavorite(int id){
    favoriteBox.delete(id);
  }

  Box getFavoriteBox(){
    return favoriteBox;
  }

  deleteAllFavorite(){
    favoriteBox.clear();
  }
  

  List getFavorites(){
    Map mapa =  favoriteBox.toMap();
    List favData = List();
    mapa.forEach((k,v) => favData.add(k));
    print("Accediendo en fav array");
   
    return favData;
  }


        //** CARRITO DE COMPRAS**/
  insertItemSC(ItemShoppingCartModel item)async{
    final _item= await itemsShoppingBox.get(item.producto.id);
    if(_item!=null){
      _item.cantidad++;
      _item.subtotal += item.cantidad*item.producto.precioMen;
      await updateItemSC(_item);
    }else{
      await itemsShoppingBox.put(item.producto.id,item );
    }
  }

  Future updateItemSC(ItemShoppingCartModel item)async{
    await itemsShoppingBox.put(item.producto.id, item);
  }

  //update from sync API
  Future updateItemProdSC(ProductoModel producto)async{
    ItemShoppingCartModel  item = itemsShoppingBox.get(producto.id);
    if(item!=null){
      item.producto = producto;
      await itemsShoppingBox.put(producto.id, producto);
    }

    itemsShoppingBox.toMap();
  }

  int countItemsSC(){
    return  itemsShoppingBox.length;
  }



  Future deleteItemSC(ItemShoppingCartModel item)async{
    await itemsShoppingBox.delete(item.producto.id);
  }

  Future deleteItemsSC()async{
    //print(object)
    await itemsShoppingBox.clear();
  }
  
  List<ItemShoppingCartModel> getItemsSC(){
    Map mapa =  itemsShoppingBox.toMap();
    List<ItemShoppingCartModel> list;
    mapa.forEach((k,v){
     // print("entrnado");
      //ItemShoppingCartModel item = v;
      //list.add(item);
    });   
    return list;
  }

  Box getItemsSCBox(){
    return itemsShoppingBox;
  }

  bool itemsSCBoxisEmpty(){
    return itemsShoppingBox.isEmpty;
  }

  deleteAllItemsSC()async{
   await itemsShoppingBox.clear();
  }

  double totalSC(){
    double total = 0;
    Map map = itemsShoppingBox.toMap();
    ItemShoppingCartModel item;
    map.forEach((k,v){
      item =v;
      total += item.cantidad*item.producto.precioMen;
    });
    return total;
  }

  //lista de productos del carrito de compras
  Future<List<ItemShoppingCartModel>> shoppingCartList()async{
    Map map =  itemsShoppingBox.toMap();
    List<ItemShoppingCartModel> lista =  map.values.toList().cast();
    return lista;
  }

  Future<List<ItemShoppingCartModel>> filterSC(List<ItemShoppingCartModel> lista,String query)async{
    List<ItemShoppingCartModel> newList=
      lista.where(
        (f) => f.producto.nombre.toUpperCase().contains(query.toUpperCase())
      ).toList(); //apples
    return newList;
  }
  
  //** CLIENTE* */
  insertClient(ClientModel client)async{
    await clientBox.put(client.id,client);
  }
  
  ClientModel getClient(String id){
    return clientBox.get(id);
  }
  
  Future updateClient(ClientModel client)async{
    print("Datos actualizados");
    await clientBox.put(client.id,client);
  }
  
  insertProducts(Map<int, ProductoModel> entries)async{
    await productBox.putAll(entries);
  }

  Box productosBox(){
    return productBox;
  }
  Future deleteProductBox()async{
    await productBox.clear();
  }
  
  void search(String query){
    //productBox.values.toList().indexWhere(); 
  }
  
  //***NOTIFICACIONES */

 

  insertNotification(Map<String, NotificacionModel> entries) async{
    print("**********guardando en hive");
    await notificationBox.putAll(entries);
  } 

  Box notificationsBox(){
    return notificationBox;
  }

  Future deleteNotificationsBox() async{
    await notificationBox.clear();
  }

   void deleteNotification(String id){ 
    notificationBox.delete(id); 
  }
  
  void markAsRead(NotificacionModel notificacionModel){
    NotificacionModel notification = notificationBox.get(notificacionModel.id);
    notification.readAt = notification.readAt;
    notificationBox.put(notification.id, notification);
  }


   Future<List<NotificacionModel>> notificationsList()async{
    Map map =  notificationBox.toMap();
    List<NotificacionModel> notifications =  map.values.toList().cast();
    notifications..sort((b, a) => a.createdAt.compareTo(b.createdAt));
    return notifications;
  }

  ///**FEATURES BOX */
  insertFeature(Feature feature)async{
    await featuresBox.put(feature.id, feature);
  }
  Future<List<Feature>> getFeature()async{
    List<Feature> list = await featuresBox.toMap().values.toList().cast();
    return list;
  }

  deleteFeature(Feature feature)async{
    featuresBox.delete(feature.id);
  }

}