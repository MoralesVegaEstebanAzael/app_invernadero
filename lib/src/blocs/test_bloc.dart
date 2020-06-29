import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/providers/producto_provider.dart';

class TestBloc{
  static final TestBloc _singleton = TestBloc._internal();
  factory TestBloc() {
    return _singleton;
  }
  
  TestBloc._internal();
  final productoProvider = ProductoProvider();
  List<ProductoModel> scFetchList = new List();
  
  void shoppingCartFect()async{
    scFetchList = await productoProvider.shoppingCartFetch();
  }

  ProductoModel getItem(int id){
    print("Buscando....");
    return scFetchList.firstWhere((test)=>test.id==id);
  }
}