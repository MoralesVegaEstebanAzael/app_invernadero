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

  final Box productsBox;
  final FavoritosBloc favoritosBloc;
  final Responsive responsive;
  
  const ProductosScrollView({Key key, this.productsBox, this.favoritosBloc, this.responsive}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("desde productss hori");
    return AspectRatio(
      aspectRatio: 16/8,
      child:(productsBox.length>0)
        ? _items(context) 
        : 
        EmptySliderProduct(responsive:responsive)
      );
  }

  _items(context){
   
    return Container( 
      margin: EdgeInsets.only(left:18),
       child: ValueListenableBuilder(
        valueListenable: productsBox.listenable(),
          builder: (BuildContext context,value,_){
          return 
          ListView.builder(
              scrollDirection: Axis.horizontal,
                  physics: CustomScrollPhysics(itemDimension: 300),
            itemCount: value.length,
            itemBuilder: (BuildContext context,index){
              ProductoModel p = value.getAt(index);
              return _createCard(context,p);
            },
          );
        }),
    );
  }

  Widget _createCard(BuildContext context,ProductoModel producto){
    final tarjeta =  Container(  
      width: responsive.ip(20),
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
              child: FadeInImage(
              placeholder: AssetImage('assets/placeholder.png'), 
              image: NetworkImage(producto.urlImagen),
              fit : BoxFit.cover,
              height: responsive.ip(13),
              ),
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