import 'package:app_invernadero/src/models/item_shopping_cart_model.dart';
import 'package:app_invernadero/src/models/shopping_cart_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:rxdart/rxdart.dart';

class ShoppingCartBloc{
  
  //final _shoppingCartController = new BehaviorSubject<List<ShoppingCartModel>>();
  final _itemsSCcontroller = new BehaviorSubject<List<ItemShoppingCartModel>>();
  
  final _cargandoController = new BehaviorSubject<bool>();
  final _db = new DBProvider();
  final _totalController = new BehaviorSubject<double>();
  final _subtotalController = new BehaviorSubject<double>();
  final _countItems = new BehaviorSubject<int>();



  //Stream<List<ShoppingCartModel>> get shoppingCartStream =>_shoppingCartController.stream;
  Stream<List<ItemShoppingCartModel>> get shoppingCartStream => _itemsSCcontroller.stream;

  Stream<bool> get cargando =>_cargandoController.stream;
  Stream<double> get subtotal => _subtotalController.stream;
  Stream<double> get total =>_totalController.stream;
  Stream<int> get count => _countItems.stream;

  
  void loadItems()async{
    final items = await _db.getItemsSC();
    //_shoppingCartController.sink.add(items);
    _itemsSCcontroller.sink.add(items);
    totalItems();
    // countItems();
  }

  void updateItem(ShoppingCartModel item)async{
    _cargandoController.sink.add(true);
    await _db.updateItemShoppingCart(item);
    _cargandoController.sink.add(false);
    totalItems();
  } 

 

  void subtotalItem(ItemShoppingCartModel item)async{
    //Replantear en base a si es menudeo o mayoreo
    double subtotal = item.cantidad * item.producto.precioMenudeo;
    item.subtotal = subtotal;
    await _db.updateItemSC(item);

   // _subtotalController.sink.add(_db.)

  }
  
  void totalItems(){
    _totalController.sink.add(_db.totalSC());
  }
  
  
  void countItems(){
    _countItems.sink.add(_db.countItemsShopCart());
  }
  
  void incItem(ItemShoppingCartModel item)async{
    print("incrementando");
    item.cantidad++;
    await _db.updateItemSC(item);
    subtotalItem(item); //new method
    totalItems();
  }

  void decItem(ItemShoppingCartModel item)async{
    if(item.cantidad>1)
      item.cantidad--;
    _cargandoController.sink.add(true);
     await _db.updateItemSC(item);
    subtotalItem(item); //new method
    totalItems();
  }

  void deleteItem(ItemShoppingCartModel item)async{
     await _db.deleteItemSC(item);
    loadItems();
   
  }

  void deleteAllItems()async{
    await _db.deleteItemsSC();
    loadItems();
  }


  dispose(){
    //_shoppingCartController.close();
  //  _cargandoController.close();
    //_totalController.close();
    //_db.dispose();
  }

  box(){
   // return _db.getShoppingCartBox();
    return _db.getItemsSCBox();
  }
  bool isEmpty(){
   // return _db.shoppingCartBoxisEmpty();
    return _db.itemsSCBoxisEmpty();
  }

 
}