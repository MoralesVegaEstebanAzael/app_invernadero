import 'dart:convert';
import 'dart:io';
import 'package:app_invernadero/src/models/client_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/models/userModel.dart';
import 'package:app_invernadero/src/models/user_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

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
  DBProvider _dbProvider = DBProvider();

  Future<Map<String,dynamic>> buscarUsuario({@required String celular})async{
      await _storage.write('celular', celular);
      final url = "${AppConfig.base_url}/api/client/search";
     
      
      final response = await http.post(url,body: {"celular":celular});
    
      
      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      print(decodedResp);
      
      if(decodedResp.containsKey('celular')){ 
        return {
          'ok':true, 
          'nombre' : decodedResp['nombre'],
          'password':decodedResp['password'],
          'direccion':decodedResp['direccion']          
        };
      }else{
        return {'ok':false, 'mensaje' : decodedResp['error']};
      }
  }
  

  Future<Map<String,dynamic>> login({@required String celular,@required  String password})async{
      Map<String, String> headers = {"Accept": "application/json"};
      final url = "${AppConfig.base_url}/api/client/login";
      
      final response = await http.post(
        url,headers:headers ,
        body: {
          "grant_type" : "refresh_token" ,
          "customer_id" : "client-id" ,
          "client_secret" : "client-secret" ,
          "refresh_token" : "refresh-token" ,
          "provider" : AppConfig.provider_api ,
          "celular":celular,
          "password":password}
        );
      
      Map<String,dynamic> decodedResp = jsonDecode(response.body);

      if(decodedResp.containsKey('access_token')){ //access_token,token_type,expires_at
        // TODO: salvar e token preferences
        await _storage.write('token',decodedResp['access_token']);
        //var decodeData = jsonDecode(response.body)['client'] ;
        //print("DEcode resp");
        ClientModel client = ClientModel.fromJson(jsonDecode(response.body)['client']);
        _dbProvider.insertClient(client);
        
        _storage.idClient = client.id;
        _storage.sesion = true;

       //  return {'ok':false};
      return {'ok':true, 'celular' : decodedResp};
      }else{
        return {'ok':false, 'mensaje' : decodedResp['message']};
      }
  }


  Future<Map<String,dynamic>> changePassword({@required String celular,@required  String password})async{
    
    final url = "${AppConfig.base_url}/api/client/update_password";
    final token = await _storage.read('token');


    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.post(
      url,
      headers:headers,
      body: {"celular":celular,"password":password});
    
    Map<String,dynamic> decodedResp = jsonDecode(response.body);
    
    
    print(decodedResp); 
    if(decodedResp.containsKey('result')){ 
      return {'ok':true, 'message' : decodedResp['message']};
    }else{
      return {'ok':false, 'message' : decodedResp['message']};
    }
  }


  Future<Map<String,dynamic>> changeInf({@required String telefono,@required  String name,String email})async{
    
    final url = "${AppConfig.base_url}/api/auth/change_inf";
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
        "email":email==null?'no_email':email,
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


  Future<Map<String,dynamic>> logout()async{
    try{
      final url = "${AppConfig.base_url}/api/client/logout";
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
        return {'ok':true, 'celular' : decodedResp};
      }else{
        return {'ok':false, 'mensaje' : decodedResp['message']};
      }
    }on PlatformException catch(e){
      print("Error ${e.code}:${e.message}");  
      return {'ok':false, 'mensaje' : 'error'};
    }
      
  }
 
  Future<UserModel> cargarUsuario()async{
      final telefono = _storage.user.phone;
      final url = "${AppConfig.base_url}/api/auth/buscarUser";
      final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
     

      final response = await http.post(url, headers: headers, body: {"telefono":telefono}); 
      
      var decodeData = jsonDecode(response.body);
      print(decodeData);
      if(decodeData == null) return null; 
      
      return  UserModel.fromJson(decodeData); 
      
  }

  Future<bool> updateDatosUser(UserModel user) async{
    final url = "${AppConfig.base_url}/api/auth/update_user/${user.id}"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 
    
    final response = await http.put(
      url, 
      headers: headers,
      body: {
        "name":user.name, 
        "email":user.email==null?'no_email':user.email, 
        "url_avatar":user.urlAvatar,
      });

    final decodeData = json.decode(response.body);
    print(decodeData);
    return true;
  }

   Future<String> subirImagen(File imagen, UserModel user) async{
    final url = "${AppConfig.base_url}/api/auth/file/avatar/${user.id}"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 

    String  foto  =  imagen.path.split('/').last;
    
    final resp = await http.post(
      url,
      headers:headers,
      body: {
        "bookcover":imagen,  
      });

    if (resp.statusCode != 200 && resp.statusCode != 201) {
        print('Algo salio mal');
        print(resp.body);
        return null;
    }  

    final respData = json.decode(resp.body);
    print(respData);

    return respData['message'];  
  }

   Future<String> subirImagenCloudinary(File imagen) async{
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dtev8lpem/image/upload?upload_preset=f9k9os9d');
    final mimeType = mime(imagen.path).split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest( //peticion para subir el archivo
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath( //se carga el archivo
      'file', 
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    );

    imageUploadRequest.files.add(file);
    
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
        print('Algo salio mal');
        print(resp.body);
        return null;
    }

    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url'];
  } 


  
  

  
}