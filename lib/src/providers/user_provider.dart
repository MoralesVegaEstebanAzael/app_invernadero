import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class UserProvider{

  static final UserProvider _userProvider = UserProvider._internal();

  factory UserProvider() {
    return _userProvider;
  }

  UserProvider._internal();


  final _storage = SecureStorage();  

  Future<Map<String,dynamic>> buscarUsuario({@required String telefono})async{
      await _storage.write('telefono', telefono);
      final url = "${AppConfig.base_url}/api/auth/buscar_usuario";
      final response = await http.post(url,body: {"telefono":telefono});
      //final parsed = jsonDecode(response.body);
      
      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      print(decodedResp);
      
      if(decodedResp.containsKey('telefono')){ 
        return {'ok':true, 'psw' : decodedResp['psw'],'name':decodedResp['name']};
      }else{
        return {'ok':false, 'mensaje' : decodedResp['error']};
      }
  }

  Future<Map<String,dynamic>> login({@required String telefono,@required  String password})async{
      Map<String, String> headers = {"Accept": "application/json"};
      final url = "${AppConfig.base_url}/api/auth/login";
      final response = await http.post(url,headers:headers ,body: {"telefono":telefono,"password":password});
      
      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      
      print("API LOGIN");
      print(decodedResp); 
      if(decodedResp.containsKey('access_token')){ //access_token,token_type,expires_at
        // TODO: salvar e token preferences
        
        await _storage.write('token',decodedResp['access_token']);
       
        _storage.sesion = true;
        return {'ok':true, 'telefono' : decodedResp};
      }else{
        return {'ok':false, 'mensaje' : decodedResp['message']};
      }
  }


  Future<Map<String,dynamic>> changePassword({@required String telefono,@required  String password})async{
    
    final url = "${AppConfig.base_url}/api/auth/change_password";
    final token = await _storage.read('token');


    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.post(
      url,
      headers:headers,
      body: {"telefono":telefono,"password":password});
    
    Map<String,dynamic> decodedResp = jsonDecode(response.body);
    
    print("API CHANGE PASSWORD");
    print(decodedResp); 
    if(decodedResp.containsKey('result')){ 

      return {'ok':true, 'message' : decodedResp['message']};
    }else{
      return {'ok':false, 'message' : decodedResp['message']};
    }
  }


  Future<Map<String,dynamic>> changeInf({@required String telefono,@required  String name,String email})async{
    
    final url = "${AppConfig.base_url}/api/auth/change_password";
    final token = await _storage.read('token');

    
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.post(
      url,
      headers:headers,
      body: {
        "telefono":telefono,
        "name":name,
        "email":email
        });
    
    Map<String,dynamic> decodedResp = jsonDecode(response.body);

    print("API CHANGE INFORMATION");
    print(decodedResp); 
    if(decodedResp.containsKey('result')){ 

      return {'ok':true, 'message' : decodedResp['message']};
    }else{
      return {'ok':false, 'message' : decodedResp['message']};
    }
  }

 /* Future<Map<String,dynamic>> signup({@required String telefono})async{

      final url = "${AppConfig.base_url}/api/auth/signup";

      Map<String, String> headers = {"Accept": "application/json"};

  
      final response = await http.post(
        url,
        headers:headers,
        body: {"telefono":telefono});
      
      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      print("API SINGUP");
      print(decodedResp); 
      if(decodedResp.containsKey('access_token')){    
        await _storage.write('token',decodedResp['access_token']);  
        return {'ok':true, 'telefono' : decodedResp};
      }else{
        return {'ok':false, 'mensaje' : decodedResp['message']};
      }
  }
*/

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