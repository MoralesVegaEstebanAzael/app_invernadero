//unidades -->> caja kilo


import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/models/item_shopping_cart_model.dart';
import 'package:app_invernadero/src/models/pedido/pedido.dart';
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
    // NotificationService _notificationService = NotificationService();

  Future<bool> pedido(List<ItemShoppingCartModel> listItems,int tipoEnvio, String tipoEntrega)async{
    print("callll pedido create");
    
    final url = "${AppConfig.base_url}/api/client/pedido_create"; 
    final token = await _storage.read('token');
    List<int> list = await _dbProvider.getItemsSCid(); //ids
    List<double> cantidades = await _dbProvider.getItemsSCcantidades(); // cantidades
    List<String> unidades = await _dbProvider.getItemsSCmedidas(); //unidades caja kilo
    print("Envioooo....... $tipoEnvio     $tipoEntrega");
    print(list);
    print(cantidades);
    print(unidades);


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
        "unidades":unidades, 
        "tipo_envio" : tipoEnvio,
        "tipo_entrega":tipoEnvio==0?tipoEntrega:''  //0 = direccion de envio -> 1-recoger
        }
        )
    );
    print('--------------${tipoEntrega}');
    print("*****************HACIENDO PEDIDO******************");
    print(response.body + "\nESTATUS: " + response.statusCode.toString());

    if(response.body.contains("pedidos") && response.body.contains("id")){
    

      PedidoModel pedido = PedidoModel.fromJson(json.decode(response.body));
      
      //insert only order(new order) into hive
       _dbProvider.insertPedido(pedido.pedidos.values.toList()[0]);
      // await  _notificationService.getNotifications();
      // await  _notificationService.loadNotifi();
      return true;
    }
    return false;  
  }


  Future<bool> getPedidos()async{
    final url = "${AppConfig.base_url}/api/client/pedidos"; 
    final token = await _storage.read('token');

     Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Content-Type" : "application/json",
      "Accept": "application/json",}; 

    final response = await http.get(
      url, 
      headers: headers,); 
    
    print("*****************GUARDANDO PEDIDOS DESPUES DEL LOGIN******************");
    print("imprimiendo respuesta: "+response.body);
    
    if(response.body.contains('message')){
      return false;
    }
    if(response.body.contains('pedidos')){
      print("ENCONTRANDO PEDIDOS");

      PedidoModel pedidos = PedidoModel.fromJson(json.decode(response.body));
      //insert all orders into hive
      //_dbProvider.insertPedidos(pedidos.pedidos);
      
      List<Pedido> pList = pedidos.pedidos.values.toList().cast();
      _dbProvider.insertAllOrders(pList);
      return true;
    }else{
      return false;
    }
  }

  bool flag=false;
  Future<Pedido> findPedido(int idPedido)async{

    // if(flag)return null;
    //   flag=true;
    try {
          print("find pedidooo****************");
    final url = "${AppConfig.base_url}/api/client/find_order?id_pedido=$idPedido"; 
    final token = await _storage.read('token');

     Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Content-Type" : "application/json",
      "Accept": "application/json",}; 

    final response = await http.get(
      url, 
      headers: headers,
      ); 
    
    print("*****************BUSCANDO PEDIDO******************");
    print("imprimiendo respuesta: "+response.body);
    
    if(response.body.contains('message')){
      return null;
    }
    if(response.body.contains('pedidos')){
      PedidoModel pedidos = PedidoModel.fromJson(json.decode(response.body));
      Pedido p = pedidos.pedidos.values.toList()[0];
      print(p.status);
      return p;
    }else{
      return null;
    }
      } on Exception catch(e) {
      
          print("EXCEPTION: ${e.toString()}");
      return null;
      } catch(e) {
      print("EXCEPTION: ${e.toString()}");
      return null;
      }

  
  }

}


