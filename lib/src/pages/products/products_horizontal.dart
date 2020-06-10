import 'package:app_invernadero/src/blocs/favoritos_bloc.dart';
import 'package:app_invernadero/src/blocs/producto_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/favorite_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/custom_scroll_physics.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:like_button/like_button.dart';

class ProductsHorizontal extends StatefulWidget {
  //List<ProductoModel> productos;
  ProductsHorizontal();
  @override
  _ProductsHorizontalState createState() => _ProductsHorizontalState();
}

class _ProductsHorizontalState extends State<ProductsHorizontal> {
  //ProductoBloc _productoBloc;
  FavoritosBloc _favoritosBloc;
  Responsive _responsive;
  Box box;
  DBProvider _dbProvider;
  //Function nextPage;
  Stream<List<ProductoModel>> _stream;
  final _pageController = new PageController(
          initialPage:0,
          viewportFraction:0.5,
        );
  @override
  void initState() {
    _dbProvider = DBProvider();
   
    super.initState();
  }
  @override
  void didChangeDependencies() {
    _responsive = Responsive.of(context);
     if (_favoritosBloc == null) { 
      // _productoBloc = Provider.productoBloc(context);
      // _productoBloc.cargarProductos();
      // _stream =  _productoBloc.productoStream;
     
     _favoritosBloc = Provider.favoritosBloc(context);
      box = _dbProvider.productosBox();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    
    // _pageController.addListener((){
    //   if(_pageController.position.pixels >=_pageController.position.maxScrollExtent-200){
    //     _productoBloc.cargarProductos();
    //   }
    // });
    print("desde vertical slider");
    return AspectRatio(
      aspectRatio: 16/8,
      child: _productos()
      );
  }

  Widget _productos(){
    
    return  WatchBoxBuilder(
    box: box, 
    builder: (BuildContext context,Box box){
      print("tamaño boxx ${box.length}");
      if(box.length>0){
        return Container( 
            margin: EdgeInsets.only(left:20),
            child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: CustomScrollPhysics(itemDimension: 300),
            itemCount: box.length,
            itemBuilder: (BuildContext context,index){
              
              ProductoModel p = box.getAt(index);
              return _createCard(p);
            },
            //itemBuilder: (BuildContext context,i)=> _createCard(snapshot.data[i]),
            ),
        );
      }else{
        return _emptyContain();
      }
    });
  }

  Widget _createItems(){
    return StreamBuilder(
      stream:_stream,
       builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
         if(snapshot.data!=null && snapshot.data.isNotEmpty){
          return Container( 
            margin: EdgeInsets.only(left:20),
            child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: CustomScrollPhysics(itemDimension: 300),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context,i)=> _createCard(snapshot.data[i]),
            ),
          );

         }else{
          return _emptyContain();
         }
       },
     );
  }

  _emptyContain(){
    return Container(
      width: _responsive.widht,
      height: _responsive.ip(20),
      
      margin: EdgeInsets.only(left: 15,right: 15,top: 10),
      
      child:Row(
        children:<Widget>[
          Expanded(child: Container(
                    decoration: BoxDecoration(
            color: MyColors.PlaceholderBackground,
            borderRadius:BorderRadius.circular(15),
          ),
                  ),),
                  SizedBox(width:_responsive.ip(2)),
                  Expanded(child: Container(
                    decoration: BoxDecoration(
            color: MyColors.PlaceholderBackground,
            borderRadius:BorderRadius.circular(15),
          ),
          ),)
        ]
      )
      // child: Image(image: AssetImage('assets/placeholder_products.gif'))
    );
  }
  Widget _createCard(ProductoModel producto){
    final tarjeta =  Container(  
      width: _responsive.ip(20),
      decoration: BoxDecoration(
        color: miTema.accentColor,
        borderRadius: BorderRadius.circular(10),
      ),
        margin: EdgeInsets.only(right:10.0),
        child: Stack(
         alignment: Alignment.center,
        children : <Widget>[
          Positioned(
            top: _responsive.ip(2),
            left: _responsive.ip(1),
              child: Hero(
              tag:producto.id,
              child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
              placeholder: AssetImage('assets/placeholder.png'), 
              image: NetworkImage(producto.urlImagen),
              fit : BoxFit.cover,
              height: _responsive.ip(13),
              ),
              ),
            ),
          ),
          
          Positioned(
            top: _responsive.ip(0.5),
            right: 0,
            child: _buttonFav(producto)),
          Positioned(
            bottom: _responsive.ip(0.5),
            child: Container(
              height: _responsive.ip(7),
              width: _responsive.ip(19),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
              child: _description(producto),
            )
          ),

          
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


  _description(ProductoModel producto){
    return Column(
      children: <Widget>[
        Text(
          producto.nombre,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color:Colors.white,
            fontFamily:'Quicksand',
            fontWeight:FontWeight.w900,
            fontSize:_responsive.ip(1.8)
          ),
        ),

        Text(
          "\$${producto.precioMay} Mayoreo",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color:Colors.white,
            fontFamily:'Quicksand',
            fontWeight:FontWeight.w900,
            fontSize:_responsive.ip(1.5)
          ),
        ),
        Text(
          "\$${producto.precioMen} Menudeo",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color:Colors.white,
            fontFamily:'Quicksand',
            fontWeight:FontWeight.w900,
            fontSize:_responsive.ip(1.5)
          ),
        ),
        
      ],
    );
  }

   _buttonFav(ProductoModel favorite){
    return  LikeButton(
        isLiked: _favoritosBloc.fav(favorite.id),
        size: 30,
        circleColor:
        CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
        bubblesColor: BubblesColor(
          dotPrimaryColor: Colors.red,
          dotSecondaryColor: Colors.redAccent,
        ),
        likeBuilder: (bool isLiked) {
          return Icon(
            isLiked? Icons.favorite:Icons.favorite_border,
            color: Colors.white,
            size: 25,
          );
        },
          onTap: (bool isLiked) {
        return _like (isLiked,favorite);
        },
        // onTap: onLikeButtonTapped,
      );
  }
  Future<bool> _like (isLiked,ProductoModel producto) async {
    if(isLiked){
      _favoritosBloc.deleteFavorite(producto.id);
    }else{

      _favoritosBloc.addFavorite(producto);
    }
    return !isLiked;
  }
}
