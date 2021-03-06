import 'package:app_invernadero/src/blocs/favoritos_bloc.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/custom_scroll_physics.dart';
import 'package:app_invernadero/src/widgets/empty_product_slider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:like_button/like_button.dart';

class ProductosScrollView extends StatelessWidget  {

  // final Box productsBox;
  final List<ProductoModel> productsList;
  final FavoritosBloc favoritosBloc;
  final Responsive responsive;
  final Function nextPage;
  ProductosScrollView({Key key, this.productsList, this.favoritosBloc, this.responsive, this.nextPage}) : super(key: key);

  final  _controller = new PageController(initialPage:1,viewportFraction:0.3);
  final _scontroller = new ScrollController(initialScrollOffset:1);

  @override
  Widget build(BuildContext context) {

    // _controller.addListener((){
    //   if(_controller.position.pixels>=_controller.position.maxScrollExtent-200){
    //     print("pull...");
    //   }
    // });

    _scontroller.addListener((){
      if(_scontroller.position.pixels>= _scontroller.position.maxScrollExtent){
        print("hacer peticion....->>>");
        nextPage();
      }
    });
    return AspectRatio(
      aspectRatio: 16/8,
      child:(productsList.length>0)
        ? _items(context) 
        : 
        EmptySliderProduct(responsive:responsive)
      );
  }

  _items(context){
    // return PageView.builder(
    //   itemCount: productsList.length,
    //   pageSnapping: false,
    //   controller: _controller,
    //   itemBuilder: (BuildContext context,index){
    //     ProductoModel p = productsList[index];
    //     return _createCard(context,p);
    //   },
    // );

    return Container( 
      margin: EdgeInsets.only(left:18),
      child:  
          ListView.builder(
            controller: _scontroller,
            scrollDirection: Axis.horizontal,
             physics: CustomScrollPhysics(itemDimension: 300),
            //physics: CustomScrollPhysics(itemDimension: 500),            
            itemCount: productsList.length,
            itemBuilder: (BuildContext context,index){
              ProductoModel p = productsList[index];
              return _createCard(context,p);
            },
          ),

      
    );
  }

  Widget _createCard(BuildContext context,ProductoModel producto){
    final tarjeta =  Container(  
      width: responsive.ip(20), //20
      decoration: BoxDecoration(
        color: miTema.accentColor,
        borderRadius: BorderRadius.circular(10),
      ),
        margin: EdgeInsets.only(right:10.0),
        child: Stack(
         alignment: Alignment.center,
        children : <Widget>[
          Positioned(
            top: responsive.ip(2),
            left: responsive.ip(1),
              child: Hero(
              tag:producto.id,
              child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: (producto.urlImagen!=null)? FadeInImage(
              placeholder: AssetImage('assets/placeholder.png'), 
              image: NetworkImage(producto.urlImagen),
              fit : BoxFit.cover,
              height: responsive.ip(13),
              ):
              Container(
                height:responsive.ip(13),
                child:Image.asset('assets/placeholder.png')
              )
              ),
            ),
          ),
          
          Positioned(
            top:responsive.ip(0.5),
            right: 0,
            child: _buttonFav(producto)),
          Positioned(
            bottom: responsive.ip(0.5),
            child: Container(
              height: responsive.ip(7),
              width: responsive.ip(19),
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
            fontSize:responsive.ip(1.8)
          ),
        ),

        Text(
          "\$${producto.precioMay} Mayoreo",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color:Colors.white,
            fontFamily:'Quicksand',
            fontWeight:FontWeight.w900,
            fontSize:responsive.ip(1.5)
          ),
        ),
        Text(
          "\$${producto.precioMen} Menudeo",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color:Colors.white,
            fontFamily:'Quicksand',
            fontWeight:FontWeight.w900,
            fontSize:responsive.ip(1.5)
          ),
        ),
        
      ],
    );
  }

  _buttonFav(ProductoModel favorite){
    return  LikeButton(
        isLiked: favoritosBloc.fav(favorite.id),
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
      favoritosBloc.deleteFavorite(producto.id);
    }else{

      favoritosBloc.addFavorite(producto);
    }
    return !isLiked;
  }
}