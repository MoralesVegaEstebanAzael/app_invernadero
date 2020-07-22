

import 'package:app_invernadero/src/models/pedido/detalle.dart';
import 'package:app_invernadero/src/models/pedido/pedido.dart';
import 'package:app_invernadero/src/models/pedido/pedido_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/pedido_provider.dart';
import 'package:rxdart/rxdart.dart';

class PedidosBloc {
   static final PedidosBloc _singleton = PedidosBloc._internal();

  factory PedidosBloc(){
    return _singleton;
  }

  PedidosBloc._internal();

  final _dbProvider = new DBProvider();

  final _pedidosController = new BehaviorSubject<List<Pedido>>();
  final _cargandoController = new BehaviorSubject<bool>(); 
  final _detalleController = new BehaviorSubject<List<Detalle>>();

  PedidoProvider pedidoProvider = PedidoProvider();

  Stream<List<Pedido>> get pedidoStream => _pedidosController.stream;
  Stream<bool> get cargando => _cargandoController.stream;
  Stream<List<Detalle>> get detalleStream => _detalleController.stream;

  void cargarPedidos() async{
    final pedidos = await _dbProvider.pedidosList();
    _pedidosController.sink.add(pedidos);
  }

  //update pedido from remote db
  void updatePedido(int id)async{
    final pedido = await pedidoProvider.findPedido(id);
    if(pedido!=null){
      await _dbProvider.updatePedido(pedido); //update local
      await cargarPedidos();
    }
  }


  void cargarDetalles(int idPedido)async{
     final detalles = _dbProvider.getDetalles(idPedido);
     _detalleController.sink.add(detalles);
  }

  bool isEmpty(){
    return _dbProvider.pedidosIsEmpty();
  }

  dispose(){
    _pedidosController.close();
    _cargandoController.close();
    _detalleController.close();
  }
}