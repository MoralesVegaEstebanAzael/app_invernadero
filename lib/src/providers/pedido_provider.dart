//unidades -->> caja kilo


import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/models/item_shopping_cart_model.dart';
import 'package:app_invernadero/src/models/pedido/pedido_model.dart';
import 'package:app_invernadero/src/models/promocion_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/services/notifications_service.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PedidoProvider{
  final _storage = SecureStorage();  
  final _dbProvider = DBProvider();
    NotificationService _notificationService = NotificationService();

  Future<bool> pedido(List<ItemShoppingCartModel> listItems)async{
    final url = "${AppConfig.base_url}/api/client/pedido_create"; 
    final token = await _storage.read('token');
    List<int> list = await _dbProvider.getItemsSCid(); //ids
    List<double> cantidades = await _dbProvider.getItemsSCcantidades(); // cantidades
    List<String> unidades = await _dbProvider.getItemsSCmedidas(); //unidades caja kilo



    if(list==null || list.isEmpty){
      return false;
    }
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Content-Type" : "application/json",
      "Accept": "application/json",}; 
    
    final response = await http.post(
      url, 
      headers: headers,
      body: json.encode( 
        {
        "productos" :list ,
        "cantidades":cantidades,
        "unidades":unidades
        }
        )
    );
    print("*****************HACIENDO PEDIDO******************");
    print(response.body);

    if(response.body.contains("pedido") && response.body.contains("idPedido")){
      // final Map<dynamic,dynamic> decodeData = json.decode(response.body)['pedido'];
      // final List<ProductoModel> productos = List();
      print("Pedido realizado con exito");

      PedidoModel pedido = PedidoModel.fromJson(json.decode(response.body));
      
      _dbProvider.insertPedido(pedido);
      
      
      
          await  _notificationService.getNotifications();
          await  _notificationService.loadNotifi();
      return true;
    }
    return false;}
}


