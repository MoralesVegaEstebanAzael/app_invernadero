import 'package:app_invernadero/src/models/promocion_model.dart';
import 'package:app_invernadero/src/providers/promocion_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
class PromocionBloc{
  final _promocionesController = new BehaviorSubject<List<PromocionModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _promocionesProvider = new PromocionProvider();

  Stream<List<PromocionModel>> get promocionStream =>_promocionesController.stream;
  Stream<bool> get cargando =>_cargandoController.stream;

  void cargarPromociones(BuildContext context)async{
    final promociones =await _promocionesProvider.loadPromociones(context);
    if(promociones!=[])
      _promocionesController.sink.add(promociones);
  }
  
 

  dispose(){
    _promocionesController.close();
    _cargandoController.close();
  }
}