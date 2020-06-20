import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/models/promocion_model.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PromocionProvider{
  final _storage = SecureStorage();  

  Future<List<PromocionModel>> loadPromociones()async{
    try {
      final url = "${AppConfig.base_url}/api/client/promociones"; 
      final token = await _storage.read('token');
      Map<String, String> headers = {
        HttpHeaders.authorizationHeader: "Bearer $token",
        "Accept": "application/json",};

    

      final response = await http.get(  
        url, 
        headers: headers);
        // headers: headers,).timeout(
        //     Duration(seconds: 10));

      print("++++++PROMOCIONES+++++" + response.statusCode.toString());
      print(response.body);

      if(response.statusCode == 500){
        print("Error data");
        return [];
      } 
      var decodeData = jsonDecode(response.body)['promociones'] as List;

      List<PromocionModel> promociones = 
      decodeData.map((promocionJson) => PromocionModel.fromJson(promocionJson)).toList();
      
      if(decodeData==null) return [];
        return promociones;
      } on TimeoutException catch (e) {
    //    Flushbar(
    //   message:   "Parece que no estas conectado a internet.",
    //   duration:  Duration(seconds:1),              
    // )..show(context);
      return [];
    } on Error catch (e) {
      print('Error: $e');
      return [];
    }
  }


  
}


