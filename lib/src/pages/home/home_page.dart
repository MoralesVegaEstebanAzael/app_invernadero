import 'dart:async';

import 'package:app_invernadero/src/blocs/client_bloc.dart';
import 'package:app_invernadero/src/blocs/favoritos_bloc.dart';
import 'package:app_invernadero/src/blocs/producto_bloc.dart';
import 'package:app_invernadero/src/blocs/promociones_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/blocs/shopping_cart_bloc.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/models/promocion_model.dart';
import 'package:app_invernadero/src/pages/products/products_horizontal.dart';
import 'package:app_invernadero/src/pages/shopping_cart_page.dart';
import 'package:app_invernadero/src/search/search_delegate.dart';
import 'package:app_invernadero/src/services/local_services.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';

import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart' as prov;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin,
  AutomaticKeepAliveClientMixin<HomePage> {
  ClientBloc _clientBloc;
  ShoppingCartBloc _shoppingCartBloc;
  ProductoBloc _productoBloc;

  AnimationController _controller;
  PromocionBloc _promocionBloc;
  Responsive _responsive;
  Stream<List<PromocionModel>> promocionesStream;
  int _current=0;

  Box _productsBox;
  FavoritosBloc _favoritosBloc;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_promocionBloc==null){
      _promocionBloc = Provider.promocionesBloc(context);
      _promocionBloc.cargarPromociones(context);
      promocionesStream = _promocionBloc.promocionStream;

      _clientBloc = Provider.clientBloc(context);
      _clientBloc.dirClient();
      _responsive = Responsive.of(context);
      _productoBloc = Provider.productoBloc(context);

      _shoppingCartBloc = Provider.shoppingCartBloc(context);
      _shoppingCartBloc.countItems();

      _favoritosBloc = Provider.favoritosBloc(context);


      _productsBox = _productoBloc.box();
    }
  }



  @override
  void dispose() {
    _controller.dispose(); 
    _productoBloc.dispose();
    super.dispose();  
  }

 

  @override
  Widget build(BuildContext context) { 
    prov.Provider.of<LocalService>(context);
    _shoppingCartBloc.countItems();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: Container(
        width: _responsive.widht,
        height: _responsive.height,
        child: RefreshIndicator(
          onRefresh: _pullData,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(  
                children: <Widget>[
                _sliderPage(),
                GestureDetector(
                  onTap: ()=>showSearch(
                            context: context, delegate: DataSearch()),
                                  child: Container(
                    // color: Colors.red,
                    width: _responsive.widht,
                    height: _responsive.ip(10),
                    child: Center(
                      child: Container(
                        height: _responsive.ip(5),
                        width: _responsive.wp(90),
                        decoration: BoxDecoration(
                          color: MyColors.Grey,
                          borderRadius:BorderRadius.circular(15)
                        ),
                        child:Row(children: <Widget>[
                           IconButton(
                            icon:Icon(LineIcons.search,color:Colors.grey), 
                            onPressed:()=>showSearch(
                            context: context, delegate: DataSearch()),),
                          
                          Expanded(child: Container(
                            child: Text(
                              "Buscar",
                              style: TextStyle(
                                color:Colors.grey,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w900
                                ),
                                ),
                          )),
                         Expanded(child: Container()),
                        ],)
                      ),
                    ),
                  ),
                ),

                ProductosScrollView(
                  productsBox:_productsBox,
                  favoritosBloc:_favoritosBloc,
                  responsive:_responsive),
                ],
              ),
          ),
        ),
      ),     
    );
  }
  
  
  Widget _sliderPage() {
    return StreamBuilder(
      stream: promocionesStream,
      builder: (BuildContext context, AsyncSnapshot<List<PromocionModel>> snapshot){
        print("slider");
        print(snapshot.data);
        if(snapshot.data!=null&&  snapshot.data.isNotEmpty){
          return  _crearItem(snapshot,context); 
        }else {
          return Container(
            width:_responsive.widht,
            height:_responsive.ip(20),
            decoration: BoxDecoration(
              color:MyColors.PlaceholderBackground,
              borderRadius:BorderRadius.circular(15),
            ),  
            margin: EdgeInsets.only(left: 15,right: 15,top: 10),
            // child:  Image(image: AssetImage('assets/placeholder_promocion.gif')),
          );

          
        }
      },
    );
  }
  
  Widget _crearItem(AsyncSnapshot<List<PromocionModel>> snapshot,BuildContext context){
    final promocion = snapshot.data;
    if(promocion.length>0){
      return Container(
        decoration: BoxDecoration(
          color:miTema.primaryColor,
          borderRadius:BorderRadius.circular(15),
        ),
        margin: EdgeInsets.only(left: 15,right: 15,top: 10),
        child: Column(
        children: <Widget>[
          CarouselSlider.builder(
            itemCount: promocion.length, 
            itemBuilder: (ctx, index) {
              return Stack(
                children: <Widget>[
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Image.network(promocion[index].urlImagen, fit: BoxFit.cover, width: _responsive.ip(19),)
                  ),
                  Positioned(
                    top: _responsive.ip(2),
                    left: _responsive.ip(2),
                    child: Container(
                      width: _responsive.wp(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[                        
                          Text("Producto",
                            style: TextStyle(
                              color:Colors.white,fontFamily:'Quicksand',fontWeight:FontWeight.w900,
                              fontSize:_responsive.ip(2)
                            ),
                          ),
                          SizedBox(height:_responsive.ip(1)),
                          Text(promocion[index].descripcion,
                            textWidthBasis: TextWidthBasis.longestLine,
                            style: TextStyle(
                              color:Colors.white,fontFamily:'Quicksand',fontWeight:FontWeight.w300,
                              fontSize:_responsive.ip(2)
                            ),
                          ),
                          SizedBox(height:_responsive.ip(1)),
                          Container(
                            width: _responsive.ip(13),
                            child: _button()
                          ),
                          //_button()
                        ],
                      ),
                    )),

                    
                
                ],

                
              );
              }, 
            options: CarouselOptions(
            height: _responsive.ip(20),
           // aspectRatio: 16/9,
            // onPageChanged: (index, reason) {
            // setState(() {
            //   _current = index;
            // });},
             viewportFraction: 1.0,
             
              enlargeCenterPage: true,
            autoPlay: true,
          ),),
          Row( //indicadores
            mainAxisAlignment: MainAxisAlignment.center,
            children: promocion.map((p) {
              int index = promocion.indexOf(p);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                    ? Color.fromRGBO(255, 255,255, 0.9)
                    : Color.fromRGBO(255, 255, 255, 0.4),
                ),
              );
            }).toList()),
        ],
        ),
      );
    }else{
      print("Ha ocurrido un error");
      return Container();
    }
  }

  
  _button(){
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
      padding: EdgeInsets.symmetric(horizontal:_responsive.ip(1.5),vertical:_responsive.ip(1.3)),
      decoration: BoxDecoration(
        color: miTema.accentColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(
                color:Colors.black26,
                blurRadius: 5
        )]
      ),
      child: Row(
        children: <Widget>[
          Text("COMPRAR",
            style: TextStyle(
              fontFamily: 'Quiksand',
              color:Colors.white,letterSpacing: 1,
              fontSize: _responsive.ip(1.5)),),
          SizedBox(width:5),
          //Icon(LineIcons.check,color:Colors.white,size: _responsive.ip(2),)
        ],
      ),
      ),
      onPressed:  ()=>print("Comprar"));
  }

  _appBar() {
    return AppBar(
      brightness :Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: GestureDetector(
        onTap: (){
          bool flagFrom=true;
          Navigator.pushNamed(context, 'config_location',arguments:flagFrom );
        },
        
        child: Container(
        child: Row(
            children:<Widget>[

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.location_on,color: Colors.grey,size: _responsive.ip(2),),
              ),
              StreamBuilder(
                stream: _clientBloc.dirStream,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                    
                  if(snapshot.hasData){
                   return Container(
                     width: _responsive.widht*.55,
                     child: Text("${snapshot.data}",
                      overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily:'Quicksand',
                          fontSize:_responsive.ip(1.5),
                          fontWeight:FontWeight.w700
                        ),
                      ),
                   );
                  }
                  return Container(); 
                },
              ),
              
            ]
          ),
        ),
      ),

       actions: <Widget>[
        //  IconAction(icon:LineIcons.search,onPressed:()=>showSearch(
        //    context: context, delegate: DataSearch())),
        // IconButton(icon: Icon(LineIcons.search,color: Colors.grey,), onPressed: null),
        // IconButton(icon: Icon(LineIcons.shopping_cart,color: Colors.grey,), onPressed: null),
      
          // Icon(LineIcons.shopping_cart,color:Colors.grey)
        // IconAction(icon:LineIcons.shopping_cart,
        //   onPressed:()=> Navigator.pushNamed(context, 'shopping_cart'),
        // )

        _cartItems()
      ],
    );
  }


  _cartItems(){
    return  new Container( 
      child: new GestureDetector(
        onTap: () {
          Navigator.of(context).push(
              new MaterialPageRoute(
                  builder:(BuildContext context) =>
                  new ShoppingCartPage()
              )
          );
        },

        child: new Stack(

          children: <Widget>[
            new IconButton(icon: new Icon(LineIcons.shopping_cart,
              color: MyColors.BlackAccent,),
                onPressed: null,
            ),

            StreamBuilder(
              stream: _shoppingCartBloc.count,
              builder: (BuildContext context, AsyncSnapshot snapshot){
               
                if(snapshot.hasData){
                  return new Positioned(
                  
                  right: _responsive.ip(0.6),
                  top: _responsive.ip(1),
                
                child: new Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    new Icon(
                        Icons.brightness_1,
                        size: _responsive.ip(2), color: miTema.accentColor),
                    new Text(
                      snapshot.data.toString(),
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: _responsive.ip(1),
                          fontWeight: FontWeight.w500
                      ),
                    ),


                  ],
                ));
                }
                return Container();
              },
            ),



            

          ],
        ),
      )
    );
  }


  Future<Null> _pullData()async{
    final duration = Duration(seconds: 2);
    new Timer(duration,(){
      _productoBloc.cargarProductos();
      _promocionBloc.cargarPromociones(context);
    });

    return Future.delayed(duration);
  }

   @override
  bool get wantKeepAlive => true;
 
}

