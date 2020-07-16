import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/models/oferta_model.dart';
import 'package:app_invernadero/src/models/promocion_model.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OfertaProvider{
  final _storage = SecureStorage();  

  Future<List<Oferta>> loadPromociones()async{
  
      final url = "${AppConfig.base_url}/api/client/ofertas"; 
      final token = await _storage.read('token');
      Map<String, String> headers = {
        HttpHeaders.authorizationHeader: "Bearer $token",
        "Accept": "application/json",};


      final response = await http.get(  
        url, 
        headers: headers);

      print("++++++OFERTAS+++++" + response.statusCode.toString());
      print(response.body);

      if(response.statusCode == 500){
        print("Error data");
        return [];
      } 

      if(response.body.contains('ofertas') && response.body.contains('id')){
        OfertaModel ofertas = OfertaModel.fromJson(json.decode(response.body));
        List<Oferta> lista =  ofertas.ofertas.values.toList().cast();
        return lista;
      }
      return [];
  }


  
}


