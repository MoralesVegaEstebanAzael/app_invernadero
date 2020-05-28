import 'package:app_invernadero/src/blocs/producto_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class ProductsHorizontal extends StatefulWidget {
  //List<ProductoModel> productos;
 
  ProductsHorizontal();

  @override
  _ProductsHorizontalState createState() => _ProductsHorizontalState();
}

class _ProductsHorizontalState extends State<ProductsHorizontal> {
  ProductoBloc _productoBloc;
  Responsive _responsive;
  Function nextPage;

  final _pageController = new PageController(
          initialPage:1,
          viewportFraction:0.3,
        );
  
  @override
  void didChangeDependencies() {
    _responsive = Responsive.of(context);
     if (_productoBloc == null) { 
      _productoBloc = Provider.productoBloc(context);
      _productoBloc.cargarProductos();
     // _favoritosBloc = Provider.favoritosBloc(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    
    _pageController.addListener((){
      if(_pageController.position.pixels >=_pageController.position.maxScrollExtent-200){
        _productoBloc.cargarProductos();
      }
    });
    return _createItems();
  }

  Widget _createItems(){
     return Container(
     width: double.infinity,
     child: StreamBuilder(
       stream: _productoBloc.productoStream,
       builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
         if(snapshot.hasData){
          return Container(
           height: _responsive.ip(20),
           child: PageView.builder(
             pageSnapping: false,
             controller:_pageController ,
             itemCount: snapshot.data.length,
             itemBuilder: (BuildContext context,i)=> _createCard(context, snapshot.data[i]),
           ),
         );
         }else{
           return Container(
             height: _responsive.ip(20),
             child: Center(child: CircularProgressIndicator())
           );
         }
       },
     ),
   );
  }

  Widget _createCard(BuildContext context,ProductoModel producto){
      final tarjeta =  Container(  
        decoration: BoxDecoration(
          color: miTema.accentColor,
          borderRadius: BorderRadius.circular(10),),
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children : <Widget>[
            Hero(
                  tag:producto.id,
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FadeInImage(
                  placeholder: AssetImage('assets/placeholder.png'), 
                  image: NetworkImage(producto.urlImagen),
                  fit : BoxFit.cover,
                  height: _responsive.ip(10),
                  ),
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              producto.nombre,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,),
          ]
        ),
      );

      return GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, 'product_detail',arguments: producto);
        },
        child:tarjeta,
      );
  }
}