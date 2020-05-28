// import 'package:app_invernadero/app_config.dart';
// import 'package:app_invernadero/src/blocs/favoritos_bloc.dart';
// import 'package:app_invernadero/src/blocs/producto_bloc.dart';
// import 'package:app_invernadero/src/blocs/provider.dart';
// import 'package:app_invernadero/src/models/item_shopping_cart_model.dart';
// import 'package:app_invernadero/src/models/producto_model.dart';
// import 'package:app_invernadero/src/pages/products/products_horizontal.dart';
// import 'package:app_invernadero/src/providers/db_provider.dart';
// import 'package:app_invernadero/src/theme/theme.dart';
// import 'package:app_invernadero/src/utils/responsive.dart';
// import 'package:flushbar/flushbar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:like_button/like_button.dart';
// import 'package:line_icons/line_icons.dart';

// class ProductPageView extends StatefulWidget {
//   ProductPageView({Key key}) : super(key: key);

//   @override
//   _ProductPageViewState createState() => _ProductPageViewState();
// }

// class _ProductPageViewState extends State<ProductPageView> {

//   DBProvider _dbProvider;
//   ProductoBloc _productoBloc;
//   FavoritosBloc _favoritosBloc;
//   Responsive responsive;
//   PageController _pageController;
//   int _selectedPage = 0;

//   @override
//   void initState() {
//     _dbProvider = DBProvider();
//     _pageController = PageController(initialPage: 0, viewportFraction:0.8);
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     if (_productoBloc == null) { 
//       _productoBloc = Provider.productoBloc(context);
//       _productoBloc.cargarProductos();
//       _favoritosBloc = Provider.favoritosBloc(context);
//     }
//     responsive = Responsive.of(context);
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//      width: double.infinity,
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children : <Widget>[

//           SizedBox(height: 5.0,),
//           StreamBuilder(
//             stream: _productoBloc.productoStream,
//             builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
//               if(snapshot.hasData){
//                 return ProductsHorizontal(
//                   productos: snapshot.data,
//                   nextPage: _productoBloc.cargarProductos,
//                 );
//               }else{
//                 return Container(
//                   height: 400.0,
//                   child: Center(child: CircularProgressIndicator())
//                 );
//               }
//             },
//           ),
//        ]
//      ),
//    );
//   }

//   Widget _item(ProductoModel data,int i) {
//     return GestureDetector(
//      onTap: (){
//        Navigator.pushNamed(context, 'product_detail',arguments: data);
//      }, 
//        child: Stack(
//         //alignment: Alignment.center,
        
        
//         children: <Widget>[
//           Container(
//             width: responsive.ip(30),
//             margin: EdgeInsets.fromLTRB(0, 0.0,5, 0), 
//               //padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(171, 196, 165, 1),
//                 borderRadius: BorderRadius.circular(20),),
//           ),
//           Positioned(
//           top: responsive.ip(2),
//           left:responsive.ip(5),
//           child: SizedBox(
//             child:Hero(
//               tag: data.id,
//               child: 
//              FadeInImage(
//                 width: responsive.ip(25),
//                 image: NetworkImage(data.urlImagen) , 
//                 placeholder: AssetImage('assets/placeholder.png'),)
//             ),
//           ),
//         ),
       
//        // _description(data),
          
//          ],
//       ), 
//     );

//   }


//   _description(ProductoModel data){    
//     return  Positioned(
//       bottom: 10,
//       left: 0,
//       width: responsive.ip(34),
//       child: Container(
//         margin: EdgeInsets.only(left:responsive.ip(1)),
//         padding: EdgeInsets.all(2),
//         decoration: BoxDecoration(
//           color: Colors.black26,
//           borderRadius: BorderRadius.circular(15.0),
//         ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children:<Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//             Text(data.nombre,style: TextStyle(color:Colors.white,fontFamily: 'Quicksand',fontWeight: FontWeight.w900,fontSize: responsive.ip(2.2)),),
//             _buttonFav(data.id)
//             // IconButton(
//             //   icon: Icon(
//             //     Icons.favorite_border,
//             //     color: Colors.white,), 
//             //     onPressed: ()=>print("add favorite"))
//           ],),
//           Text(
//           "Especificaciones: ${data.contCaja} ${AppConfig.uni_medida}" ,
//             style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w700,color:Colors.white),
//           ),
//           SizedBox(height:responsive.ip(.5)),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children:<Widget>[
//               Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children:<Widget>[
//                     Text("\$ ${data.precioMayoreo} MX",
//                       style: TextStyle(
//                         fontSize:15,fontFamily: 'Quicksand',
//                         fontWeight: FontWeight.w900,color: Colors.white,),),
//                     Text("\$ ${data.precioMenudeo} MX",style: TextStyle(
//                       fontSize:15,fontFamily: 'Quicksand',
//                     fontWeight: FontWeight.w900,color: Colors.white,),),
//                     ]
//               ),
//               Column(
//               children:<Widget>[
//                 Text("Mayoreo",
//                   style: TextStyle(
//                     fontFamily:'Quicksand',
//                     fontWeight: FontWeight.w700,
//                     color:Colors.white),),
//                 SizedBox(height:responsive.ip(0.5)),
//                   Text("Menudeo",
//                     style: TextStyle(
//                       fontFamily:'Quicksand',
//                       fontWeight: FontWeight.w700,
//                       color:Colors.white),),
//               ]
//             ),
//             Column(
//             children: <Widget>[
//               CupertinoButton(
//                 padding: EdgeInsets.zero,
//                 child: Container(
//                 padding: EdgeInsets.symmetric(horizontal:responsive.ip(2),vertical:8),
//                 decoration: BoxDecoration(
//                   color:Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [BoxShadow(
//                           color:Colors.black26,
//                           blurRadius: 5
//                   )]
//                 ),
//                 child://_button()
//                   Icon(LineIcons.shopping_cart,color:miTema.accentColor),//Text("Agregar",style: TextStyle(fontFamily: 'Quiksand',color:Colors.white,letterSpacing: 1,fontSize: 15),),
//                 ),
//                 onPressed: ()=>addShoppingCart(data)),
//                       ],
//                     ),     
//                   ]
//                   ),
                  
//           SizedBox(height:responsive.ip(1)),
//               ]
//             ),
            
//       ),
//     );
//   }
  
//   addShoppingCart(ProductoModel p){
//     ItemShoppingCartModel item = ItemShoppingCartModel(
//       producto: p,
//       cantidad: 1,
//       subtotal: 1*p.precioMenudeo
//     );

//     _dbProvider.insertItemSC(item);
//     Flushbar(
//       message:   "Se ha añadido al carrito.",
//       duration:  Duration(seconds:1),              
//     )..show(context);
  
//   }


//    _buttonFav(int id){
//     return  LikeButton(
//         isLiked: _favoritosBloc.fav(id),
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
//         return _like (isLiked,id);
//         },
//         // onTap: onLikeButtonTapped,
//       );
//   }

//    Future<bool> _like (isLiked,id) async {
//     print(isLiked);
//     print("id set$id");
//     if(isLiked){
//       _favoritosBloc.deleteFavorite(id);
//     }else{
//       _favoritosBloc.addFavorite(id);
//     }
//     return !isLiked;
//   }
// }