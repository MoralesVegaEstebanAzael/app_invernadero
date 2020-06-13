import 'package:app_invernadero/src/blocs/favoritos_bloc.dart';
import 'package:app_invernadero/src/blocs/producto_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/favorite_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/services/local_services.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/custom_scroll_physics.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:like_button/like_button.dart';

import 'package:provider/provider.dart' as fprovider;

class ProductosScrollView extends StatelessWidget {
  final List<ProductoModel> lista;
  final FavoritosBloc favoritosBloc;
  final Responsive responsive;

  const ProductosScrollView({Key key, this.lista, this.favoritosBloc, this.responsive}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16/8,
      child: _items(context)
      );
  }

  _items(context){
    return Container( 
      margin: EdgeInsets.only(left:20),
      child:   ListView.builder(
        scrollDirection: Axis.horizontal,
            physics: CustomScrollPhysics(itemDimension: 300),
      itemCount: lista.length,
      itemBuilder: (BuildContext context,index){
        ProductoModel p = lista[index];
        return _createCard(context,p);
      },
    )
    );
  }



 

  _emptyContain(){
    return Container(
      width: responsive.widht,
      height: responsive.ip(20),
      margin: EdgeInsets.only(left: 15,right: 15,top: 10),
      child:Row(
        children:<Widget>[
          Expanded(child: Container(
                    decoration: BoxDecoration(
            color: MyColors.PlaceholderBackground,
            borderRadius:BorderRadius.circular(15),
          ),
                  ),),
                  SizedBox(width:responsive.ip(2)),
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

// class ProductsHorizontal extends StatefulWidget {
//   final List<ProductoModel> lista;
//   final FavoritosBloc _favoritosBloc;
//   final Responsive _responsive;

//   ProductsHorizontal(this.lista, this._favoritosBloc, this._responsive);
//   @override
//   _ProductsHorizontalState createState() => _ProductsHorizontalState(this.lista,this._favoritosBloc,this._responsive);
// }

// class _ProductsHorizontalState extends State<ProductsHorizontal> {
  
//   FavoritosBloc _favoritosBloc;
//   Responsive _responsive;
//   List<ProductoModel> lista;

//   final _pageController = new PageController(
//           initialPage:0,
//           viewportFraction:0.5,
//         );

//   _ProductsHorizontalState(List<ProductoModel> lista, FavoritosBloc favoritosBloc, Responsive responsive){
//     this.lista = lista;
//     this._favoritosBloc = favoritosBloc;
//     this._responsive = responsive;
//   }
  



//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 16/8,
//       child: _items()
//       );
//   }

//   _items(){
//     return Container( 
//       margin: EdgeInsets.only(left:20),
//       child:   ListView.builder(
//         scrollDirection: Axis.horizontal,
//             physics: CustomScrollPhysics(itemDimension: 300),
//       itemCount: lista.length,
//       itemBuilder: (BuildContext context,index){
//         ProductoModel p = lista[index];
//         return _createCard(p);
//       },
//     )
//     );
//   }


//   // Widget _productos(){
//   //   return ValueListenableBuilder(
//   //     valueListenable: box.listenable(), 
//   //     builder: (BuildContext context,value,_){
//   //     if(value.length>0){
//   //       return Container( 
//   //           margin: EdgeInsets.only(left:20),
//   //           child: ListView.builder(
//   //             addAutomaticKeepAlives: true,
//   //           scrollDirection: Axis.horizontal,
//   //           physics: CustomScrollPhysics(itemDimension: 300),
//   //           itemCount: value.length,
//   //           itemBuilder: (BuildContext context,index){
//   //             ProductoModel p = value.getAt(index);
//   //             return _createCard(p);
//   //           },
//   //       ),
//   //       );
//   //     }else{
//   //       return _emptyContain();
//   //     }
//   //   });
//   // }

 

//   _emptyContain(){
//     return Container(
//       width: _responsive.widht,
//       height: _responsive.ip(20),
//       margin: EdgeInsets.only(left: 15,right: 15,top: 10),
//       child:Row(
//         children:<Widget>[
//           Expanded(child: Container(
//                     decoration: BoxDecoration(
//             color: MyColors.PlaceholderBackground,
//             borderRadius:BorderRadius.circular(15),
//           ),
//                   ),),
//                   SizedBox(width:_responsive.ip(2)),
//                   Expanded(child: Container(
//                     decoration: BoxDecoration(
//             color: MyColors.PlaceholderBackground,
//             borderRadius:BorderRadius.circular(15),
//           ),
//           ),)
//         ]
//       )
//       // child: Image(image: AssetImage('assets/placeholder_products.gif'))
//     );
//   }
//   Widget _createCard(ProductoModel producto){
//     final tarjeta =  Container(  
//       width: _responsive.ip(20),
//       decoration: BoxDecoration(
//         color: miTema.accentColor,
//         borderRadius: BorderRadius.circular(10),
//       ),
//         margin: EdgeInsets.only(right:10.0),
//         child: Stack(
//          alignment: Alignment.center,
//         children : <Widget>[
//           Positioned(
//             top: _responsive.ip(2),
//             left: _responsive.ip(1),
//               child: Hero(
//               tag:producto.id,
//               child: ClipRRect(
//               borderRadius: BorderRadius.circular(20.0),
//               child: FadeInImage(
//               placeholder: AssetImage('assets/placeholder.png'), 
//               image: NetworkImage(producto.urlImagen),
//               fit : BoxFit.cover,
//               height: _responsive.ip(13),
//               ),
//               ),
//             ),
//           ),
          
//           Positioned(
//             top: _responsive.ip(0.5),
//             right: 0,
//             child: _buttonFav(producto)),
//           Positioned(
//             bottom: _responsive.ip(0.5),
//             child: Container(
//               height: _responsive.ip(7),
//               width: _responsive.ip(19),
//               decoration: BoxDecoration(
//                 color: Colors.black12,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: _description(producto),
//             )
//           ),

          
//         ]
//       ),
//     );
//     return GestureDetector(
//       onTap: (){
//         Navigator.pushNamed(context, 'product_detail',arguments: producto);
//       },
//       child:tarjeta,
//     );
//   }


//   _description(ProductoModel producto){
//     return Column(
//       children: <Widget>[
//         Text(
//           producto.nombre,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//             color:Colors.white,
//             fontFamily:'Quicksand',
//             fontWeight:FontWeight.w900,
//             fontSize:_responsive.ip(1.8)
//           ),
//         ),

//         Text(
//           "\$${producto.precioMay} Mayoreo",
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//             color:Colors.white,
//             fontFamily:'Quicksand',
//             fontWeight:FontWeight.w900,
//             fontSize:_responsive.ip(1.5)
//           ),
//         ),
//         Text(
//           "\$${producto.precioMen} Menudeo",
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//             color:Colors.white,
//             fontFamily:'Quicksand',
//             fontWeight:FontWeight.w900,
//             fontSize:_responsive.ip(1.5)
//           ),
//         ),
        
//       ],
//     );
//   }

//   _buttonFav(ProductoModel favorite){
//     return  LikeButton(
//         isLiked: _favoritosBloc.fav(favorite.id),
//         size: 30,
//         circleColor:
//         CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
//         bubblesColor: BubblesColor(
//           dotPrimaryColor: Colors.red,
//           dotSecondaryColor: Colors.redAccent,
//         ),
//         likeBuilder: (bool isLiked) {
//           return Icon(
//             isLiked? Icons.favorite:Icons.favorite_border,
//             color: Colors.white,
//             size: 25,
//           );
          
//         },
//           onTap: (bool isLiked) {
//         return _like (isLiked,favorite);
//         },
//         // onTap: onLikeButtonTapped,
//       );
//   }
//   Future<bool> _like (isLiked,ProductoModel producto) async {
//     if(isLiked){
//       _favoritosBloc.deleteFavorite(producto.id);
//     }else{

//       _favoritosBloc.addFavorite(producto);
//     }
//     return !isLiked;
//   }


// }
