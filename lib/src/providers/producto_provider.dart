import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/models/item_shopping_cart_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:http/http.dart' as http;

class ProductoProvider{
  // static final ProductoProvider _singleton = ProductoProvider._internal();
  // factory ProductoProvider() {
  //   return _singleton;
  // }
    
  // ProductoProvider._internal();


  int _productosPage=0;
  bool _loading=false;
  final _storage = SecureStorage();  
  final _dbProvider = DBProvider();

  // indexPage(){ //reset index
  //   _productosPage=0;
  // }

  Future<List<ProductoModel>> cargarProductos()async{
    
    if(_loading)return [];
    _loading=true;
    
    _productosPage++;
    final url = "${AppConfig.base_url}/api/client/productos?page=$_productosPage"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);
    print("PRODUCTOS RESPUESTA----------------");

    print(response.body);
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEE $_productosPage");
      //return [];
      //_productosPage=0;
     //return cargarProductos();
      return[];
    } 
    
    final Map<dynamic,dynamic> decodeData = json.decode(response.body)['productos'];
    final List<ProductoModel> productos = List();


    Map prodMap = Map<int, ProductoModel>();


    decodeData.forEach((id,producto){
      ProductoModel productoTemp = ProductoModel.fromJson(producto);
      productos.add(productoTemp);
      prodMap.putIfAbsent(int.parse(id), ()=>productoTemp);
    });
    
    print("tamaño");
    print(   _dbProvider.productBox.length);
    //  _dbProvider.insertProducts(prodMap);
   // print(_dbProvider.productBox.length);
   _loading=false;
    if(decodeData==null) return [];
    return productos;
    
    //return [];
  }

  
  Future<List<ProductoModel>> searchProduct(String query)async{
    final url = "${AppConfig.base_url}/api/client/search_products"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.post(
      url, 
      headers: headers,
      body: {"data":query});
    
    print("Response: ${response.body}" );

    if(response.statusCode==200){
      var decodeData = jsonDecode(response.body)['productos'] as List;
      if(decodeData!=null){
        List<ProductoModel> productos = 
        decodeData.map((productoJson) => ProductoModel.fromJson(productoJson)).toList();
        if(decodeData==null) return [];
        return productos;
      }
  
      
    }else{
      return [];
    }
  }
  
  //busca un conjunto de productos
  Future<List<ProductoModel>> findProducts(List ids)async{
    final url = "${AppConfig.base_url}/api/auth/find_items"; 
    final token = await _storage.read('token');


    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",
      "Content-type": "application/json"};

    var body = json.encode({
      "productos": ids
      });

    final response = await http.post(
      url, 
      headers: headers,
       body: body
    );  
    
    print("*******FAVORITOS RESPUESTA----------------");
    print(response.body);
    if(response.body.contains('message')){
      return [];
    } 
    var decodeData = jsonDecode(response.body)['productos'] as List;

    List<ProductoModel> productos = 
    decodeData.map((productoJson) => ProductoModel.fromJson(productoJson)).toList();

    if(decodeData==null) return [];
    return productos;
  }

  static Future<bool> verify(String url)async{
    final response = await http.get(
      url, );
    print(response.statusCode);
    if(response.statusCode!=200){
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
  }

  int x =0;
  Future<List<ProductoModel>> shoppingCartFetch() async{ 
    final url = "${AppConfig.base_url}/api/client/shopping_cart_fetch"; 
    final token = await _storage.read('token');
    List<int> list = await _dbProvider.getItemsSCid();
    
    if(list==null || list.isEmpty){
      return [];
    }
    x++;
    print("veces... $x");
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Content-Type" : "application/json",
      "Accept": "application/json",}; 
    
    final response = await http.post(
      url, 
      headers: headers,
      body: json.encode( 
        {
        "products" :list ,
        }
        )
    );
    print("SHOPPING CART FETCH");
    print(response.body);

    if(response.body.contains("productos") && response.body.contains("id")){
      final Map<dynamic,dynamic> decodeData = json.decode(response.body)['productos'];
      final List<ProductoModel> productos = List();

      decodeData.forEach((id,p){
        ProductoModel productItem = ProductoModel.fromJson(p);
        productos.add(productItem);
      });
      if(productos.isNotEmpty)
      return productos;
      else 
      return [];
    }
    return [];
  }



  Future<bool> pedido(List<ItemShoppingCartModel> listItems)async{
    final url = "${AppConfig.base_url}/api/client/addpedidoDetails"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
      
      List pedidoProductos = toJson(listItems);

      if(pedidoProductos == [] || pedidoProductos.isEmpty){
        return false;
      }

     var body = json.encode({
      "productos": pedidoProductos
      });
 

    final response = await http.post(
      url, 
      headers: headers,
       body: body
    ); 

    print("PEDIDO RESPUESTA----------------");
    print(response.body);

    if(response.body.contains('soldOut')){
      return false;
    } 
     
    final decodeData = jsonDecode(response.body);
    print(decodeData); 
    return true; 
  }

   List toJson(List<ItemShoppingCartModel> items){ 
    Map<String,int> mapAux = {};  
    List aux = new List();  
      items.forEach((v){    
        ItemShoppingCartModel item = v; 
        mapAux = {
          'idProducto': item.producto.id,
          'cantidad': item.cantidad
        };
        aux.add(mapAux);        
      });
    if(aux.isNotEmpty){
      return aux; 
    }
    return [];
  }
}


