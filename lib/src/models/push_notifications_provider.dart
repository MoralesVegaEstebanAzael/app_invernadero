

import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsProvider{
  static final PushNotificationsProvider _singleton = PushNotificationsProvider._internal();

  factory PushNotificationsProvider() {
    return _singleton;
  }
  

  PushNotificationsProvider._internal();


  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _messageStreamController = StreamController<String>.broadcast();
  Stream<String> get message => _messageStreamController.stream;
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
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: ( info ) async {
        print("====ON MESSAGE===");
        print(info);

        String argument='no-data';
        if(Platform.isAndroid){ 
          argument = info['data']['comida']??'no-data';
        }

        _messageStreamController.sink.add(argument);
      },
      onLaunch: ( info ) async {
        print("====ON LAUNCH===");
        print(info);
        final notif = info['data']['argument'];
        print(notif);
      },

      onResume: ( info ) async {
        print("====ON RESUME===");
        print(info);
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
}

//ePtmOnHaU6c:APA91bEwBMsVJTfM-SVfZIBJIlrCByCbsqCi4vhD_NnprDnmrQg0hPeEvgCTZfLp4IfQJ7fJdV6dz7fyTcmhMOXE3tmeXgW8Xl4qQXdQQpJyeQ9q-5nc0ghvIFdU1yrkx-6GUho7jF-y


//ePtmOnHaU6c:APA91bEwBMsVJTfM-SVfZIBJIlrCByCbsqCi4vhD_NnprDnmrQg0hPeEvgCTZfLp4IfQJ7fJdV6dz7fyTcmhMOXE3tmeXgW8Xl4qQXdQQpJyeQ9q-5nc0ghvIFdU1yrkx-6GUho7jF-y


//eCIXI_RLbgw:APA91bG8J-P2jPBvQ6oOG-pnDnLJwCsbOghfQ0_66U7LF-4gKlLIGeD0quDkKZQ-H8Yp8TwezEZ0i1Cv649iKdkMhSxKX0aYQlbwXKHjMqajDqnNIAjlD6yqvyCnzmpkcfb7LRCqc4u4




//eCIXI_RLbgw:APA91bG8J-P2jPBvQ6oOG-pnDnLJwCsbOghfQ0_66U7LF-4gKlLIGeD0quDkKZQ-H8Yp8TwezEZ0i1Cv649iKdkMhSxKX0aYQlbwXKHjMqajDqnNIAjlD6yqvyCnzmpkcfb7LRCqc4u4