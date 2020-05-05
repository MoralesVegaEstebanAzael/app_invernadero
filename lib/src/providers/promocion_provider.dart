import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/models/promocion_model.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PromocionProvider{
  final _storage = SecureStorage();  

  Future<List<PromocionModel>> loadPromociones()async{
    final url = "${AppConfig.base_url}/api/auth/promociones"; 
    final token = await _storage.read('token');

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);

    if(response.body.contains('message')){
      return [];
    } 
    var decodeData = jsonDecode(response.body)['promociones'] as List;

    List<PromocionModel> promociones = 
    decodeData.map((promocionJson) => PromocionModel.fromJson(promocionJson)).toList();
    
    if(decodeData==null) return [];
    
    return promociones;
  }
}


