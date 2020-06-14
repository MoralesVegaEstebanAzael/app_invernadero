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

  void cargarNotificaciones() async{
    //final notificaciones = await _userProvider.cargarNotificaciones();
     await _dbProvider.notificationBox;
    //_notificacionesController.sink.add(notificaciones);
  }

  void markAsReadNotifications() async {
    _cargandoController.sink.add(true);
    await _userProvider.markAsReadNotifications();
    _cargandoController.sink.add(false);
  }

  box(){
    return _dbProvider.notificationBox;
  }

  dispose(){
    _notificacionesController.close();
    _cargandoController.close();
  }
}