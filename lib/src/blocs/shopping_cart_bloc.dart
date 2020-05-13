import 'package:app_invernadero/src/models/shopping_cart_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:rxdart/rxdart.dart';

class ShoppingCartBloc{

  final _shoppingCartController = new BehaviorSubject<List<ShoppingCartModel>>();
  final _cargandoController = new BehaviorSubject<bool>();
  
  final _db = new DBProvider();
  final _totalController = new BehaviorSubject<double>();

  Stream<List<ShoppingCartModel>> get shoppingCartStream =>_shoppingCartController.stream;
  Stream<bool> get cargando =>_cargandoController.stream;
  Stream<double> get total => _totalController.stream;



  void loadItems()async{
    final items = await  _db.getShoppingCart();
    _shoppingCartController.sink.add(items);



  }

  void updateItem(ShoppingCartModel item)async{
    _cargandoController.sink.add(true);
    await _db.updateItemShoppingCart(item);
    _cargandoController.sink.add(false);
  }

  void incItem(ShoppingCartModel item)async{
    item.cantidad++;
    _cargandoController.sink.add(true);
    await _db.updateItemShoppingCart(item);
    _cargandoController.sink.add(false);
  }

  

  void decItem(ShoppingCartModel item)async{
    if(item.cantidad>1)
      item.cantidad--;
    _cargandoController.sink.add(true);
    await _db.updateItemShoppingCart(item);
    _cargandoController.sink.add(false);
  }

  void deleteItem(ShoppingCartModel item)async{
    
     await _db.deleteItemShoppingCart(item);
    loadItems();
   
  }

  void deleteAllItems()async{
    await _db.deleteAllItems();
    loadItems();
  }


  dispose(){
   // _shoppingCartController.close();
    //_cargandoController.close();
    _db.dispose();
  }

  box(){
    return _db.getShoppingCartBox();
  }
  bool isEmpty(){
    return _db.shoppingCartBoxisEmpty();
  }
  
  double totalItems(){
    return _db.totalShoppingCart();
  }
}