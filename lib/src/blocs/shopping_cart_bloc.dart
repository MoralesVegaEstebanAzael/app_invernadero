import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/models/client_model.dart';
import 'package:app_invernadero/src/models/item_shopping_cart_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/pedido_provider.dart';
import 'package:app_invernadero/src/providers/producto_provider.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:app_invernadero/src/blocs/validators.dart';


class ShoppingCartBloc with Validators{
  static final ShoppingCartBloc _singleton = ShoppingCartBloc._internal();
  factory ShoppingCartBloc() {
    return _singleton;
  }
  
  ShoppingCartBloc._internal();
  final db = new DBProvider();
  final _storage = SecureStorage();  
  final productoProvider = ProductoProvider();

  final _totalController = new BehaviorSubject<double>();
  final _countItemsController = new BehaviorSubject<int>();
  final _articController = new BehaviorSubject<List<ItemShoppingCartModel>>();
  final _shoppingCartFetchController = new BehaviorSubject<List<ProductoModel>>();
  final _totalFinalController = new BehaviorSubject<double>();
  final _toneladasController = new BehaviorSubject<String>();

// List<ItemShoppingCartModel> items ,int tipoEnvio, String tipoEntrega
  final _itemsPaypalController = new BehaviorSubject<List<ItemShoppingCartModel>>();
  final _tipoEnvioPaypalController = new BehaviorSubject<int>();
  final _tipoEntregaControllerPaypal = new BehaviorSubject<String>();

  final _isLoadingController = new BehaviorSubject<bool>();

  Stream<List<ItemShoppingCartModel>> get  itemsPaypalStream => _itemsPaypalController.stream;
  Stream<int> get tipoEnvioPayPalStream => _tipoEnvioPaypalController.stream;
  Stream<String> get tipoEntrega => _tipoEntregaControllerPaypal.stream;

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  Function(List<ItemShoppingCartModel>) get onChangeItemsPayPal => _itemsPaypalController.sink.add;
  Function(int) get onChangeTipoEnvioPayPal => _tipoEnvioPaypalController.sink.add;
  Function(String) get onChangeTipoEntrega => _tipoEntregaControllerPaypal.sink.add;

  Function(bool) get onChangeIsLoading => _isLoadingController.sink.add;
  
  List<ItemShoppingCartModel> get listItemPaypalValue => _itemsPaypalController.value;
  int get tipoEnvioValue => _tipoEnvioPaypalController.value;
  String get tipoEntregaValue => _tipoEntregaControllerPaypal.value;



  Stream<double> get totalFinal =>_totalFinalController.stream;
  Stream<double> get total =>_totalController.stream;
  Stream<int> get count => _countItemsController.stream;  
  Stream<List<ItemShoppingCartModel>> get artcStream => _articController.stream;
  Stream<List<ProductoModel>> get _scFecthStream => _shoppingCartFetchController.stream;


  Stream<String> get toneladasStream => _toneladasController.stream.transform(validarToneladas);

  List<ProductoModel> scFetchList = new List();
  List<ItemShoppingCartModel> tempItems = List();
  

  //insertar valores al stream
  Function(String) get changeToneladas => _toneladasController.sink.add;

  String get email => _toneladasController.value;

  bool get isLoading => _isLoadingController.value;

  void insertItem(ProductoModel p,String unidades,dynamic cantidad){

    if(p.cantExis>=0){
       ItemShoppingCartModel item;
      if(unidades==AppConfig.uniMedidaCaja){ //comprando por cajas
        int c = int.parse(cantidad.toString());
        item = ItemShoppingCartModel(
                  producto: p,
                  cantidad: c,
                  subtotal: c*p.precioMay*AppConfig.cajaKilos,//<<----- kilos x caja
                  unidad: unidades,  
                );      
      }else{
        double c = double.parse(cantidad.toString());

        if(unidades==AppConfig.uniMedidaKilo){
            item = ItemShoppingCartModel(
                  producto: p,
                  subtotal: c*p.precioMen,//<<-----comprando por kilos
                  unidad: unidades,  
                  kilos: c
                );
        }else if(unidades == AppConfig.uniMedidaTonelada){
          item = ItemShoppingCartModel(
                  producto: p,
                  subtotal: c*AppConfig.tonelada*p.precioMay,//<<-----comprando por Toneladas
                  unidad: unidades,  
                  kilos: c
                );
        }
      
      }

      db.insertItemSC(item);
      countItems();
      cargarArtic();
      
      shoppingCartFetch();
    }
  }
  //load with stream 
  void cargarArtic()async{   
    
    tempItems = await  db.shoppingCartList();
    _articController.sink.add(tempItems);
    totalItems();
  } 

  void shoppingCartFetch()async{
    
    scFetchList = await productoProvider.shoppingCartFetch();
    
  }



  void incItems(ItemShoppingCartModel item)async{
    if(agotado(item.producto.id))
      return;
      
    switch(item.unidad){
      case AppConfig.uniMedidaCaja:
        item.cantidad++;
        double subtotal = item.cantidad * item.producto.precioMay*AppConfig.cajaKilos;
        item.subtotal = subtotal;
      break;

      case AppConfig.uniMedidaKilo:
        if(item.kilos<19){
          item.kilos++;
          double subtotal = item.kilos * item.producto.precioMen;
          item.subtotal = subtotal;
        }
      break;
      case AppConfig.uniMedidaTonelada:
        item.kilos++;
        double subtotal = item.kilos * item.producto.precioMay*AppConfig.tonelada;
        item.subtotal = subtotal;
      break;
    }


    await db.updateItemSC(item);
    cargarArtic();
  }

  void decItems(ItemShoppingCartModel item)async{
    if(agotado(item.producto.id))
      return;
    
   
    
    switch(item.unidad){
      case AppConfig.uniMedidaCaja:
        if(item.cantidad>1)
        item.cantidad--;
        double subtotal = item.cantidad * item.producto.precioMay*AppConfig.cajaKilos;
        item.subtotal = subtotal;
      break;

      case AppConfig.uniMedidaKilo:
        if(item.kilos>1){
          item.kilos--;
          double subtotal = item.kilos * item.producto.precioMen;
          item.subtotal = subtotal;
        }
      break;
      case AppConfig.uniMedidaTonelada:
        if(item.kilos>1)
          item.kilos--;
        double subtotal = item.kilos * item.producto.precioMay*AppConfig.tonelada;
        item.subtotal = subtotal;
      break;
    }


    await db.updateItemSC(item);
    cargarArtic();
    
    await db.updateItemSC(item);
    cargarArtic();
  }
  
  void delItem(ItemShoppingCartModel item)async{
    await db.deleteItemSC(item);
    cargarArtic();
  }

  void deleteAllSC()async{
    await db.deleteAllItemsSC();
    await cargarArtic();
  }

  void filter(String query)async{
    final items = await  db.shoppingCartList();
    
    if(query.isEmpty){
      _articController.sink.add(items);
    }else{
      final newItems= await db.filterSC(items, query);
      _articController.sink.add(newItems);
    }
  }
  
  
  void totalItems(){ //precio total de items
    _totalController.sink.add(db.totalSC());
  }
  
  void countItems(){//total de items guardados
    //if(!_countItems.isClosed)
    _countItemsController.sink.add(db.countItemsSC());
  }
  dispose(){
    // _articController.close();
    // _countItemsController.close();
    //_totalController.close();
   // _totalFinalController.onPause;
    // _shoppingCartFetchController.close();
    // _isDisposed = true;
  }

  box(){
    return db.getItemsSCBox();
  }
  bool isEmpty(){
    return db.itemsSCBoxisEmpty();
  }

  ProductoModel getItem(int id){
    return scFetchList.firstWhere((test)=>test.id==id);
  }

  
  bool agotado(int id){
    ProductoModel p =  scFetchList.firstWhere((test)=>test.id==id);
    if(p!=null){
      if(p.cantExis<=0)
        return true;
      return false;
    }
    return false;
  }
 
  List<ItemShoppingCartModel> getItemsFinalList(){
    double totalFinal=0;
    List<ItemShoppingCartModel> itemsFinal = List();
    tempItems.forEach((item){
      ItemShoppingCartModel i = item;
      if(!agotado(i.producto.id)){
        itemsFinal.add(i);
        totalFinal+=i.subtotal;
        print("LIST FINL ${i.producto.nombre}");
      }
    });
    _totalFinalController.sink.add(totalFinal);
    return itemsFinal;
  }
  bool information(){
    ClientModel client =  db.getClient(_storage.idClient); 
     
    if(client.nombre!=null && client.am!=null&& client.ap!=null&&client.rfc!=null){
      return true;
    }
    return false;
  }
  
  Future<Map<String,dynamic>> sendPedido(List<ItemShoppingCartModel> items ,int tipoEnvio, String tipoEntrega)async{
    if(information()){ //verificar que el usuario tenga sus datos
      print("haciendo pedido");
      PedidoProvider pp = PedidoProvider();
      bool f = await pp.pedido(items,tipoEnvio, tipoEntrega);
      if(f)
        return {'ok':1, 'message' : 'Pedido realizado'};
      return {'ok':0,'message' : 'Ha ocurrido un problema con la peticioón'};
      //return  {'ok':1,'message' : 'Pedido realizado'};
    }
    return {'ok':2,'message' : 'Información requerida'};
  }
}