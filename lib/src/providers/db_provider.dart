import 'package:app_invernadero/src/models/client_model.dart';
import 'package:app_invernadero/src/models/item_shopping_cart_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/models/shopping_cart_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider{
  Box shoppingCartBox;
  
  Box itemsShoppingBox;
  Box productoBox;
  Box dataBaseBox;
  Box clientBox;
  Box favoriteBox;
  
  static DBProvider _instance =
      DBProvider.internal();

  DBProvider.internal();

  factory DBProvider() => _instance;


  Future initDB()async{
    var path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
    //adapter register
    Hive.registerAdapter(ShoppingCartAdapter());
    Hive.registerAdapter(ItemShoppingCartAdapter());
    Hive.registerAdapter(ProductoAdapter());
    Hive.registerAdapter(ClientAdapter());

    shoppingCartBox= await Hive.openBox("shoppingCart");
    dataBaseBox = await Hive.openBox("db");

    itemsShoppingBox = await Hive.openBox("itemsShopping");
    // productoBox = await Hive.openBox("productoBox");

    favoriteBox = await Hive.openBox("favorite");
    clientBox = await Hive.openBox("client");

    return true;
  }
  
  contains(ShoppingCartModel item){  
    Map map =  shoppingCartBox.toMap(); 
    ShoppingCartModel itemRet;
    map.forEach((k,v){
      ShoppingCartModel art = v;
      if(art.productoId==item.productoId){
        itemRet = v;
        itemRet.key = k;
      }
    }); 
    return itemRet;

  }

  

  insert(ShoppingCartModel item)async{
    //try{
    ShoppingCartModel _item = contains(item);
    if(_item!=null){ 
     // print("ITEM ${_item.nombre} key: ${_item.key}");
      _item.cantidad++;
      _item.subtotal += 1 * item.precioMenudeo;
      //replantear respecto a precio menudeo y mayoreo
      
      await updateItemShoppingCart(_item);
    }else{
      item.subtotal = item.precioMenudeo*item.cantidad;
      shoppingCartBox.add(item);
    }
    // } on Error catch (e) {
    //   print('Error: $e');
    // }
   
  }
  

  double totalShoppingCart(){
    double total = 0;
    Map map = shoppingCartBox.toMap();
    ShoppingCartModel item;
    map.forEach((k,v){
      item =v;
      total += item.cantidad*item.precioMenudeo;
    });

    return total;
    //return dataBaseBox.get('total')==null? 0:dataBaseBox.get('total');
  }

  int countItemsShopCart(){
    //int i=0;
    return shoppingCartBox.length;
  }

  Future updateItemShoppingCart(ShoppingCartModel item)async{
    await shoppingCartBox.put(item.key, item);
  }

  
  Future deleteItemShoppingCart(ShoppingCartModel item)async{
    await shoppingCartBox.delete(item.key);
  }
  
  Future deleteAllItems()async{
    await shoppingCartBox.clear();
  }
  
  Box getShoppingCartBox(){
    return shoppingCartBox;
  }



  Future<List<ShoppingCartModel>> getShoppingCart()async{
    Map map = await shoppingCartBox.toMap();
    List<ShoppingCartModel> itemsBox = [];
    map.forEach((k,v){
      ShoppingCartModel item = v;
      item.key = k;
      itemsBox.add(item);
     
    });  
    return  itemsBox;
  }

  bool shoppingCartBoxisEmpty(){
    return shoppingCartBox.isEmpty;
  }
  
  void dispose(){
    //shoppingCartBox.close(); 
  }

  //favoritos
  void addFavorite(int id){
    print("agregando");
    //favoriteBox.add(value)
    favoriteBox.put(id, id);
  }

  bool isFavorite(int id){
    //print("isFavorite: " +favoriteBox.get(id));
    if(favoriteBox.get(id)!=null)
      return true;
    return false;
  }

  void deleteFavorite(int id){
    print("delete");
     favoriteBox.delete(id);
  }

  Box getFavoriteBox(){
    return favoriteBox;
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

  Future deleteItemSC(ItemShoppingCartModel item)async{
    await itemsShoppingBox.delete(item.producto.id);
  }

  Future deleteItemsSC()async{
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

  
  //** CLIENTE* */
  insertClient(ClientModel client)async{
    await clientBox.put(client.id,client);
  }
  
  ClientModel getClient(String id){
    return clientBox.get(id);
  }

  Future updateClient(ClientModel client)async{
    await clientBox.put(client.id,client);
  }
}