

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero/src/blocs/pedido_bloc.dart';
import 'package:app_invernadero/src/models/pedido/pedido.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/pedido_provider.dart';
import 'package:app_invernadero/src/services/notifications_service.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsProvider{
  
  static final PushNotificationsProvider _singleton = PushNotificationsProvider._internal();
  factory PushNotificationsProvider() => _singleton;
  PushNotificationsProvider._internal();// private constructor
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _messageStreamController = StreamController<String>.broadcast();
  Stream<String> get message => _messageStreamController.stream;
  static bool isNotified=false;



  


  getToken(){
    //send token server
    
    _firebaseMessaging.getToken().then((token){
      print("===========token===========");
      print(token);
    });
  }

  Future<String> getFCMToken()async{
    final token = await _firebaseMessaging.getToken();
    return token;
  }
  
  subscribeToTopic(String topic){
    print("*********SUBCRIBIENDOSE A TOPIC $topic *********");
    _firebaseMessaging.subscribeToTopic(topic);
  }

  unsubscribeFromTopic(String topic){
    _firebaseMessaging.unsubscribeFromTopic(topic);
  }
 
  
  initNotifications(){
   
   
    PedidosBloc pedidosBloc = PedidosBloc();
    NotificationService _notificationService = NotificationService();
    

    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: ( info ) async {
       
        //**APLICACION ABIERTA */

        
        if(isNotified)
          return;
        isNotified = true;
        print("====ON MESSAGE===");
        print(info);

        await refreshNotification(_notificationService);

        if(info['data']['tipo']=='pedido'){ //push notification order type
          notifyOrder(info,pedidosBloc);
        }
        
        isNotified=false;
      },
      onLaunch: ( info ) async {
        /**SEGUNDO PLANO */
        print("====ON LAUNCH===");
        print(info);
      },
      //
      onResume: ( info ) async {
        
        if(isNotified) //bug fcm
          return;
        isNotified = true;

        //APP DESTRUIDA Y EN SEGUNDO PLANO AL DARLE CLICK
        print("====ON RESUME===");
        print(info);

        await refreshNotification(_notificationService);

        if(info['data']['tipo']=='pedido'){ //push notification order type
          notifyOrder(info,pedidosBloc);
        }
       
        isNotified=false;

      }
    );

  }

  notifyOrder(Map<String,dynamic> info,PedidosBloc pedidosBloc){
    Pedido pedido = Pedido.fromJson(json.decode(info['data']['pedido']));
    if(pedido.id!=null){
      pedidosBloc.putPedido(pedido);
    }
  }

  refreshNotification(NotificationService notificationService)async{
    await  notificationService.getNotifications();
    await  notificationService.loadNotifi();
  }

  refreshToken(){
    print(">>>== REFRESH TOKEN ==>>");
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      // Save newToken
     /// this.getToken();
    });

    print(">>>>=====>>>>");
  }

  deleteToken(){
     print(">>>== DELETE TOKEN ==>>");
    _firebaseMessaging.deleteInstanceID();
    ///this.getToken();

    /// 
    print(">>>>=====>>>>");
  }
  dispose(){
    _messageStreamController.close();
  }

  _notifications(){
    
  }
}