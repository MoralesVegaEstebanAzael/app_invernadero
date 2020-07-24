

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


  initNotifications(){
    NotificationService _notificationService = NotificationService();
    PedidosBloc pedidosBloc = PedidosBloc();
    SecureStorage secureStorage = SecureStorage();

    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: ( info ) async {
        //**APLICACION ABIERTA */
        if(isNotified)
          return;
        isNotified = true;
        print("====ON MESSAGE===");
        print(info);

        print("iddd de notificacion");
        print(info['data']['google.message_id']);

        String notificationId = secureStorage.notificationId;

        
        await  _notificationService.getNotifications();
        
       //print(info['data']);
        await  _notificationService.loadNotifi();
        // print(info);
          String idPedido = info['data']['id_pedido'];
          
          print("**********>>>> IMPRIMIENDO PEDIDO DE PUSH <<<<<********");
          print(info['data']['pedido']);

          Pedido pedido = Pedido.fromJson(json.decode(info['data']['pedido']));
        
          if(pedido.id!=null){
            pedidosBloc.putPedido(pedido);
          }
          // if(idPedido!=null){
          //   print("sincronizando pedido.. ON MESSAGE");
          //   pedidosBloc.updatePedido(int.parse(idPedido));
          // }
        // String argument='no-data';
        // if(Platform.isAndroid){ 
        //   argument = info['data']['comida']??'no-data';
        // }

        // _messageStreamController.sink.add(argument);

        isNotified=false;
      },
      onLaunch: ( info ) async {
        /**SEGUNDO PLANO */
        print("====ON LAUNCH===");

        //await  _notificationService.getNotifications();
        print(info);



        //await  _notificationService.loadNotifi();
        //NotificationService _notificationService = NotificationService();

        //await _notificationService.getNotifications();

        // print(info);
        // final notif = info['data']['argument'];
        // print(notif);
      },
      //
      onResume: ( info ) async {

        //APP DESTRUIDA Y EN SEGUNDO PLANO AL DARLE CLICK
        print("====ON RESUME===");
        print(info);

        String notificationId = secureStorage.notificationId;

        if(notificationId!=info['data']['google.message_id']){
          final tipo = info['data']['tipo'];
          if(tipo=='pedido'){
            await  _notificationService.getNotifications();
            await  _notificationService.loadNotifi();

            String idPedido = info['data']['id_pedido'];
            if(idPedido!=null){
              print("sincronizando pedido.. ON RESUME");
              pedidosBloc.updatePedido(int.parse(idPedido));
            } 
          }
        }else{
          print("ya no mas bugs con FCM");
        }
      }
    );

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

//ePtmOnHaU6c:APA91bEwBMsVJTfM-SVfZIBJIlrCByCbsqCi4vhD_NnprDnmrQg0hPeEvgCTZfLp4IfQJ7fJdV6dz7fyTcmhMOXE3tmeXgW8Xl4qQXdQQpJyeQ9q-5nc0ghvIFdU1yrkx-6GUho7jF-y


//ePtmOnHaU6c:APA91bEwBMsVJTfM-SVfZIBJIlrCByCbsqCi4vhD_NnprDnmrQg0hPeEvgCTZfLp4IfQJ7fJdV6dz7fyTcmhMOXE3tmeXgW8Xl4qQXdQQpJyeQ9q-5nc0ghvIFdU1yrkx-6GUho7jF-y


//eCIXI_RLbgw:APA91bG8J-P2jPBvQ6oOG-pnDnLJwCsbOghfQ0_66U7LF-4gKlLIGeD0quDkKZQ-H8Yp8TwezEZ0i1Cv649iKdkMhSxKX0aYQlbwXKHjMqajDqnNIAjlD6yqvyCnzmpkcfb7LRCqc4u4




//eCIXI_RLbgw:APA91bG8J-P2jPBvQ6oOG-pnDnLJwCsbOghfQ0_66U7LF-4gKlLIGeD0quDkKZQ-H8Yp8TwezEZ0i1Cv649iKdkMhSxKX0aYQlbwXKHjMqajDqnNIAjlD6yqvyCnzmpkcfb7LRCqc4u4