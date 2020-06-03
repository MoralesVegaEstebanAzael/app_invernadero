import 'package:app_invernadero/src/blocs/favoritos_bloc.dart';
import 'package:app_invernadero/src/blocs/producto_bloc.dart';
import 'package:app_invernadero/src/blocs/promociones_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/models/promocion_model.dart';
import 'package:app_invernadero/src/pages/products/products.dart';
import 'package:app_invernadero/src/pages/products/products_horizontal.dart';
import 'package:app_invernadero/src/pages/products/products_page_view.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/search/search_delegate.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';

import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/app_bar.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:line_icons/line_icons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  PromocionBloc _promocionBloc;
  Responsive _responsive;
  
  int _current=0;
  @override
  void initState() {
    //FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    super.initState();
    _controller = AnimationController(vsync: this);

  

  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_promocionBloc==null){
      _promocionBloc = Provider.promocionesBloc(context);
      _promocionBloc.cargarPromociones(context);
    }

    //
    

    //
    _responsive = Responsive.of(context);
    
  }
  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();  
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: Container(
        width: _responsive.widht,
        height: _responsive.height,
        child: SingleChildScrollView(
                  child: Column(
              
              children: <Widget>[
              _sliderPage(_promocionBloc),

                Container(
              color: Colors.white,
              width: _responsive.widht,
              height: _responsive.ip(10),
                    ),
             ProductsHorizontal(),
              // Container(
              // color: Colors.white,
              // width: _responsive.widht,
              // height: _responsive.ip(10),
              //       ),
            //ProductPageView()
                // Container(
                //   width: _responsive.widht,
                //   height: _responsive.ip(25),
                //   child: ProductPageView())
              ],
            ),
        ),
      ),
      
    );
  }
  
  Widget _sliderPage(PromocionBloc bloc) {
    return StreamBuilder(
      stream: bloc.promocionStream,
      builder: (BuildContext context, AsyncSnapshot<List<PromocionModel>> snapshot){
        if(snapshot.hasData){
          return  _crearItem(snapshot,context); 
        }else{
          return Center(
            child: CircularProgressIndicator(),
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
            onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });},
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
      centerTitle: true,
      leading:  Row(
        children: <Widget>[
          IconAction(
            //icon:LineIcons.sun_o,
            icon: LineIcons.bell,
            onPressed:()=>print("Clima")
          )
        ],
      ),
      
      title: Container(
        child: Row(
          children:<Widget>[
            Icon(Icons.location_on,color: Colors.grey,size: 20,),  
            Container(
              margin: EdgeInsets.only(left:5),
              width: _responsive.wp(37),
              child: Text("Mi ubicación Colonia pueblo nuevo",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily:'Quicksand',
                  fontSize:_responsive.ip(1.5),
                  fontWeight:FontWeight.w700
                ),
              ),
            ),

            Icon(Icons.arrow_right,color: Colors.grey,)
          ]
        ),
      ),

       actions: <Widget>[
         IconAction(icon:Icons.search,onPressed:()=>showSearch(
           context: context, delegate: DataSearch())),

        IconAction(icon:LineIcons.shopping_cart,
          onPressed:()=> Navigator.pushNamed(context, 'shopping_cart'),
        )
      ],
    );
  }
  
}
