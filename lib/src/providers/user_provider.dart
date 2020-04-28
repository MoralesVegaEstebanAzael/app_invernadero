import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class UserProvider{
  final _storage = SecureStorage();  

  Future<Map<String,dynamic>> buscarUsuario({@required String telefono})async{
   
      final url = "${AppConfig.base_url}/api/auth/buscar_usuario";
      final response = await http.post(url,body: {"telefono":telefono});
      //final parsed = jsonDecode(response.body);
      
      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      print(decodedResp);


      if(decodedResp.containsKey('telefono')){
        return {'ok':true, 'telefono' : decodedResp};
      }else{
        return {'ok':false, 'mensaje' : decodedResp['error']};
      }
  }


  Future<Map<String,dynamic>> login({@required String telefono,@required  String password})async{

      final url = "${AppConfig.base_url}/api/auth/login";
      final response = await http.post(url,body: {"telefono":telefono,"password":password});
      
      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      
      //print(decodedResp); 
      if(decodedResp.containsKey('access_token')){ //access_token,token_type,expires_at
        // TODO: salvar e token preferences
        
        await _storage.write('token',decodedResp['access_token']);
       
        _storage.sesion = true;
        return {'ok':true, 'telefono' : decodedResp};
      }else{
        return {'ok':false, 'mensaje' : decodedResp['message']};
      }
  }


  Future<Map<String,dynamic>> logout()async{
    try{
      final url = "${AppConfig.base_url}/api/auth/logout";
      final token = await _storage.read('token');
      final response = await http.get(
        url, 
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},);
      
      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      
      print("CODE response: $response.statusCode");
      print("***RESPUESTA****");
      print(decodedResp); 
      

      if(decodedResp.containsKey('message')){ 
        // TODO: remove  token 
        await _storage.delete('token');
        _storage.sesion = false;
        return {'ok':true, 'telefono' : decodedResp};
      }else{
        return {'ok':false, 'mensaje' : decodedResp['message']};
      }
    }on PlatformException catch(e){
      print("Error ${e.code}:${e.message}");  
      return {'ok':false, 'mensaje' : 'error'};
    }
      
  }
}