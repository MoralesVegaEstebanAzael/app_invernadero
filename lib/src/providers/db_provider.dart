import 'package:app_invernadero/src/models/shopping_cart_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider{
  Box shoppingCartBox;
  
  Box dataBaseBox;
  static DBProvider _instance =
      DBProvider.internal();

  DBProvider.internal();

  factory DBProvider() => _instance;


  Future initDB()async{
    var path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
    Hive.registerAdapter(ShoppingCartAdapter());
    shoppingCartBox= await Hive.openBox("shoppingCart");

    dataBaseBox = await Hive.openBox("db");

    return true;
  }

  bool containsClon(ShoppingCartModel item){
    Map map =  shoppingCartBox.toMap(); 

    map.containsValue(item.productoId)?print("SIIIIIII"):print("NOOOOOOOOOOO");

    var key = map.keys.firstWhere(
    (k) => map[k] == item.key, orElse: () => null);
    print("Valor: $key");
    if(key!=null)return true;
    return false;
  }
  insert(ShoppingCartModel item){
    //shoppingCartBox.get(item.key)!=null?print("Existe"):print("no existe");
    if(containsClon(item)){
      print("EXistee");
      item.cantidad++;
      updateItemShoppingCart(item);
    }else{
      print("noooo EXistee");
      shoppingCartBox.add(item);
    }

    double subt = item.cantidad * item.precioMenudeo;
    double t = totalShoppingCart() + subt; 
    dataBaseBox.put('total', t);

  }
  
  double totalShoppingCart(){
    return dataBaseBox.get('total')==null? 0:dataBaseBox.get('total');
  }

  Future updateItemShoppingCart(ShoppingCartModel item)async{
    
    await shoppingCartBox.put(item.key, item);

    
  }


  Future deleteItemShoppingCart(ShoppingCartModel item)async{
    double subt = item.cantidad * item.precioMenudeo;
    double t = totalShoppingCart() - subt; 
    dataBaseBox.put('total', t);
    await shoppingCartBox.delete(item.key);
  }
  
  Future deleteAllItems()async{
    await shoppingCartBox.clear();
    await dataBaseBox.delete("total");
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

 



}