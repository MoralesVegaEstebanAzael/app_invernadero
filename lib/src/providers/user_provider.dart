import 'dart:convert';

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
      
      
      print(decodedResp); 

      
      if(decodedResp.containsKey('access_token')){ //access_token,token_type,expires_at
        // TODO: salvar e token preferences
        _storage.write('token',decodedResp['access_token']);
        
        return {'ok':true, 'telefono' : decodedResp};
      }else{
        return {'ok':false, 'mensaje' : decodedResp['message']};
      }

  }
}