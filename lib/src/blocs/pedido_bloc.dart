import 'package:app_invernadero/src/models/pedido/detalle.dart';
import 'package:app_invernadero/src/models/pedido/pedido.dart';
import 'package:app_invernadero/src/models/pedido/pedido_model.dart';
import 'package:app_invernadero/src/models/pedido/status.dart';
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

  final _statusController = new BehaviorSubject<List<Status>>();
  Stream<List<Status>> get statusStream => _statusController.stream;

  void cargarPedidos() async{
    final pedidos = await _dbProvider.pedidosList();
    pedidos.forEach((v){
      print(v.id);
    });
    _pedidosController.sink.add(pedidos);
  }

  //update pedido from remote db
  void updatePedido(int id)async{
    final pedido = await pedidoProvider.findPedido(id);
    if(pedido!=null){
      print("Actualizando.....");
     // await _dbProvider.updatePedido(pedido); //update local
      await cargarPedidos();
    }else{
      print("A ocurrido un problema al buscar el pedido");
    }
  }

  void putPedido(Pedido p)async{
    await  _dbProvider.updateOrder(p);
    cargarPedidos();
  }
  
  void status(int idPedido) async {
    final status = await _dbProvider.getStatus(idPedido);
    _statusController.sink.add(status);
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
    _statusController.close();
  }
}