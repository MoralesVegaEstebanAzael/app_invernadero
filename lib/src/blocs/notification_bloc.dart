import 'package:app_invernadero/src/blocs/producto_bloc.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:app_invernadero/src/models/notification_model.dart';
import 'package:app_invernadero/src/providers/user_provider.dart';

class NotificacionesBloc{
  static final NotificacionesBloc _singleton = NotificacionesBloc._internal();

  factory NotificacionesBloc(){
    return _singleton;
  }

  NotificacionesBloc._internal();
  
  final _dbProvider = new DBProvider();
  final _userProvider = new UserProvider();

  final _notificacionesController = new BehaviorSubject<List<NotificacionModel>>();
  final _cargandoController = new BehaviorSubject<bool>(); 
  
  Stream<List<NotificacionModel>> get notificacionesStream => _notificacionesController.stream;
  Stream<bool> get cargando => _cargandoController.stream; 


  final _unreadNotificationController = new BehaviorSubject<List<NotificacionModel>>();

  Stream<List<NotificacionModel>> get unreadNotificationsStream => _unreadNotificationController.stream;

  List<NotificacionModel> unreadNotificationsList= List();

  List<String> unreadListStr = List();

  void cargarNotificaciones() async{
    final notifications = await _dbProvider.notificationsList(); 
    _notificacionesController.sink.add(notifications);
  } 

  
  ///add notifications from services
  void addUnReadNotifications(List<NotificacionModel> notificationsList){
    if(notificationsList.isNotEmpty && notificationsList!=null){
      _unreadNotificationController.sink.add(notificationsList);
      unreadNotificationsList = notificationsList;
      objToStr(notificationsList);
    }
  }

  void objToStr(List<NotificacionModel> notificationsList){
    notificationsList.forEach((f){
      String id = f.id;
      unreadListStr.add(id);
    });
  }
  void deleteNotification(NotificacionModel notification)async{
    print("Delete ${notification.readAt}");
    if(notification.readAt!=null){
      await _dbProvider.deleteNotification(notification.id);
      cargarNotificaciones();
    }
  }

  
  void markAsReadNotifications() async {
    //update notificaciones local
    if(unreadListStr.length>0 && unreadListStr!=null){
      await _userProvider.markAsReadNotifications(unreadListStr);
      _unreadNotificationController.add(null);
      unreadListStr.clear();
    }
  }

  void filter(String query)async{
    final notifications = await  _dbProvider.notificationsList();
    if(query.isEmpty){
      _notificacionesController.sink.add(notifications);
    }else{
      final notificationsCopy= await _dbProvider.filterNotifications(notifications, query);
       _notificacionesController.sink.add(notificationsCopy);

    }
  }
  dispose(){
    _notificacionesController.close();
    _cargandoController.close(); 
    _unreadNotificationController.close();
  }

  bool isEmpty(){
    return _dbProvider.notifIsEmpty();
  }
}