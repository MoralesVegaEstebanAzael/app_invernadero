import 'dart:convert';

import 'package:app_invernadero/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class UserProvider{
  

  Future<bool> buscarUsuario(BuildContext context,{@required String telefono})async{
    try{
      final url = "${AppConfig.base_url}/api/auth/buscar_usuario";
      final response = await http.post(url,body: {"telefono":telefono});
      final parsed = jsonDecode(response.body);
      
      if(response.statusCode==200){
        final message = parsed['message'] as String;
        final telefono = parsed['telefono'] as String;

        print("Response 200: ${response.body}");
        return true;
      }else if(response.statusCode==422){
        throw PlatformException(code: "422",message: parsed['errors']);
      }
      
      throw PlatformException(code: response.statusCode.toString(),message: parsed['message']);
    }on PlatformException catch(e){
      print("Error ${e.code}:${e.message}");  
      return false;
    }
  }


  Future<bool> login(BuildContext context,{@required String telefono,@required  String password})async{
    try{
      final url = "${AppConfig.base_url}/api/auth/login";
      final response = await http.post(url,body: {"telefono":telefono,"password":password});
      
      final parsed = jsonDecode(response.body);
      
      if(response.statusCode==200){
        final token = parsed['token'] as String;
        final token_type = parsed['token_type'] as String;
        final expires = parsed['expires_at'] as String;

        print("Response 200: ${response.body}");
        return true;
      }else if(response.statusCode==422){
        throw PlatformException(code: "422",message: parsed['errors']);
      }

      throw PlatformException(code: response.statusCode.toString(),message: parsed['message']);


    }on PlatformException catch(e){
      print("Error ${e.code}:${e.message}");  
      return false;
    }

  }
}