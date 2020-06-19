import 'package:app_invernadero/src/models/item_shopping_cart_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:rxdart/rxdart.dart';

class ShoppingCartBloc{
  static final ShoppingCartBloc _singleton = ShoppingCartBloc._internal();
  factory ShoppingCartBloc() {
    return _singleton;
  }
  

  ShoppingCartBloc._internal();

  final _itemsSCcontroller = new BehaviorSubject<List<ItemShoppingCartModel>>();
  
  final _cargandoController = new BehaviorSubject<bool>();
  final db = new DBProvider();
  final _totalController = new BehaviorSubject<double>();
  final _subtotalController = new BehaviorSubject<double>();
  final _countItems = new BehaviorSubject<int>();

  

  //Stream<List<ShoppingCartModel>> get shoppingCartStream =>_shoppingCartController.stream;
  Stream<List<ItemShoppingCartModel>> get shoppingCartStream => _itemsSCcontroller.stream;

  Stream<bool> get cargando =>_cargandoController.stream;
  Stream<double> get subtotal => _subtotalController.stream;
  Stream<double> get total =>_totalController.stream;
  
  
  Stream<int> get count => _countItems.stream;

  //*** *** */
  
  final _articController = new BehaviorSubject<List<ItemShoppingCartModel>>();
  Stream<List<ItemShoppingCartModel>> get artcStream => _articController.stream;

  

  void loadItems()async{
    final items = await db.getItemsSC();
    //_shoppingCartController.sink.add(items);
    _itemsSCcontroller.sink.add(items);
    totalItems();
    
    countItems();
  }

  void insertItem(ItemShoppingCartModel item){
    db.insertItemSC(item);
    countItems();
  }
  // void updateItem(ShoppingCartModel item)async{
  //   _cargandoController.sink.add(true);
  //   await db.updateItemShoppingCart(item);
  //   _cargandoController.sink.add(false);
  //   totalItems();
  // } 

  
  void subtotalItem(ItemShoppingCartModel item)async{
    //Replantear en base a si es menudeo o mayoreo
    double subtotal = item.cantidad * item.producto.precioMen;
    item.subtotal = subtotal;
    await db.updateItemSC(item);

   // _subtotalController.sink.add(db.)

  }
  
  void totalItems(){ //precio total de items
    _totalController.sink.add(db.totalSC());
  }
  
  
  void countItems(){//total de items guardados
     _countItems.sink.add(db.countItemsSC());
    }
  
  void incItem(ItemShoppingCartModel item)async{
    print("incrementando");
    item.cantidad++;
    await db.updateItemSC(item);
    subtotalItem(item); //new method
    totalItems();
  }

  void decItem(ItemShoppingCartModel item)async{
    if(item.cantidad>1)
      item.cantidad--;
    _cargandoController.sink.add(true);
     await db.updateItemSC(item);
    subtotalItem(item); //new method
    totalItems();
  }

  void deleteItem(ItemShoppingCartModel item)async{
     await db.deleteItemSC(item);
    loadItems();
   
  }

  void deleteAllItems()async{
    await db.deleteItemsSC();
    loadItems();
  }


  dispose(){
    //_shoppingCartController.close();
  //  _cargandoController.close();
    //_totalController.close();
    //db.dispose();
  }

  box(){
   // return db.getShoppingCartBox();
    return db.getItemsSCBox();
  }
  bool isEmpty(){
   // return db.shoppingCartBoxisEmpty();
    return db.itemsSCBoxisEmpty();
  }

  
  //load with stream 
  void cargarArtic()async{
    final items = await  db.shoppingCartList();
    _articController.sink.add(items);
    totalItems();
  } 

  void incItems(ItemShoppingCartModel item)async{
    item.cantidad++;
    double subtotal = item.cantidad * item.producto.precioMen;
    item.subtotal = subtotal;

    await db.updateItemSC(item);
    cargarArtic();
  }

  void decItems(ItemShoppingCartModel item)async{
     if(item.cantidad>1)
      item.cantidad--;
    double subtotal = item.cantidad * item.producto.precioMen;
    item.subtotal = subtotal;

    await db.updateItemSC(item);
    cargarArtic();
  }

  void delItem(ItemShoppingCartModel item)async{
    await db.deleteItemSC(item);
    cargarArtic();
  }

  void deleteAllSC()async{
    print("Eliminando tod...");
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

  

  
 
}