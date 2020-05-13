import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:http/http.dart' as http;

class ProductoProvider{
  final _storage = SecureStorage();  
  
  Future<List<ProductoModel>> cargarProductos()async{
    final url = "${AppConfig.base_url}/api/auth/productos"; 
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
}


