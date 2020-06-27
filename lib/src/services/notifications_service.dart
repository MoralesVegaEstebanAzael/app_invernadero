import 'package:app_invernadero/src/blocs/notification_bloc.dart';
import 'package:app_invernadero/src/models/notification_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/models/promocion_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/producto_provider.dart';
import 'package:app_invernadero/src/providers/promocion_provider.dart';
import 'package:app_invernadero/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService with ChangeNotifier{
  static final NotificationService _singleton = NotificationService._internal();

  factory NotificationService() => _singleton;

  NotificationService._internal(){
    this.getNotifications();
  }// private constructor


  UserProvider _userProvider = UserProvider();
  NotificacionesBloc notificacionesBloc = NotificacionesBloc();
  List<NotificacionModel> notificationsList= List();
  
  

  // NotificationService(){
  //   this.getNotifications();
  // }
  
  void getNotifications()async{
    print(">>>>>>>>>>>>>cargando NOTIFICACIONES>>>>>>>>>>>>>");
    notificationsList=  await _userProvider.unReadNotifications();
    notificacionesBloc.addUnReadNotifications(notificationsList);
    notifyListeners();
  }
  
  void loadNotifi()async{
    print("<<<load notifications>>>");
    await notificacionesBloc.cargarNotificaciones();
  }

}