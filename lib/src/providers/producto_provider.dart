import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:http/http.dart' as http;

class ProductoProvider{
  final _storage = SecureStorage();  
  
  Future<List<ProductoModel>> cargarProductos()async{
    final url = "${AppConfig.base_url}/api/client/productos"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);
    print("PRODUCTOS RESPUESTA----------------");
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

  Future<List<ProductoModel>> searchProduct(String query)async{
    final url = "${AppConfig.base_url}/api/auth/search_products"; 
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
}


