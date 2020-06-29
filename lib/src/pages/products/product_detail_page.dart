
import 'package:app_invernadero/src/blocs/bottom_nav_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/blocs/shopping_cart_bloc.dart';
import 'package:app_invernadero/src/models/item_shopping_cart_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/pages/shopping_cart_page.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:line_icons/line_icons.dart';



import '../../../app_config.dart';

class ProductDetailPage extends StatefulWidget {
  
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
    ShoppingCartBloc _shoppingCartBloc;
    BottomNavBloc _bottomNavBarBloc;
    Responsive responsive;
    ProductoModel producto; 
    DBProvider _dbProvider;
    
    @override
    void initState() {
      FlutterStatusbarcolor.setStatusBarColor(miTema.accentColor);
      _dbProvider = DBProvider();
      _bottomNavBarBloc = BottomNavBloc();
      super.initState();
    }

    @override
    void didChangeDependencies() {
      responsive = Responsive.of(context);
      producto = ModalRoute.of(context).settings.arguments;

      _shoppingCartBloc = Provider.shoppingCartBloc(context);
      super.didChangeDependencies();
    }
    @override
    void dispose() {
      FlutterStatusbarcolor.setStatusBarColor(Colors.white);
      super.dispose();
    }


    @override
    Widget build(BuildContext context) {
      _shoppingCartBloc.countItems();
      return  Scaffold(
        body: CustomScrollView(
        slivers: <Widget>[
        _appBar(),
        SliverList(
          delegate: SliverChildListDelegate([
            _contenido()
          ]),
        ),
      ],),);
    }
  
    
    Widget _appBar(){
      return SliverAppBar(
        brightness :Brightness.dark,
        elevation: 0,
        backgroundColor: miTema.accentColor,
        leading: IconButton(
          icon:Icon(LineIcons.angle_left),
          onPressed: () {
            
            Navigator.of(context).pop();
          } 
        ),
        actions: <Widget>[
          _cartItems()
        ],
      );
    }
  
  _cartItems(){
    return  Container( 
       width: responsive.ip(5),
      height: responsive.ip(5),
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color:Colors.black12,
        shape: BoxShape.circle, 
      ),
      child:  GestureDetector(
        onTap: () {
          //Navigator.pop(context);
          bool flagFrom=true;
          Navigator.pushNamed(context, 'shopping_cart',arguments:flagFrom );
        },
        child: Stack(
          children: <Widget>[
           IconButton(icon: Icon(LineIcons.shopping_cart,
              color: Colors.white,),
                onPressed: null,
            ),
            StreamBuilder(
              stream: _shoppingCartBloc.count,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  return Positioned(
                    right: responsive.ip(0.6),
                    top: responsive.ip(1),
                
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                   Icon(
                        Icons.brightness_1,
                        size: responsive.ip(2), color: Colors.white),
                    new Text(
                      snapshot.data.toString(),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: responsive.ip(1),
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ));
                }
                return Container();
              },
            ),],
        ),
      )
    );
  }
  
    Widget _contenido() {
      return SingleChildScrollView(
        
          child: Container(
            height: responsive.height,
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              
              _background(),
              _encabezado(),
              _descripcion()
              ],
            ),
          ),
        );
    }
  
    _background() {
      return AspectRatio(
        aspectRatio: 16/12,
            child: Container(
              color:miTema.accentColor,
              child: Stack(children: <Widget>[
          Positioned(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom:45.0),
                   child:Hero(
                      tag: producto.id,
                      child: //(producto.urlImagen!=null)?
                    FadeInImage(
                        width: responsive.ip(25),
                        image: NetworkImage(producto.urlImagen) , 
                        placeholder: AssetImage('assets/placeholder.png'),)
                    ),
                ),
              ),
              ),
        ],
        ),
      ),
      );
    }
    
    _encabezado() {
      return Container(
       // margin: EdgeInsets.symmetric(horizontal:15),
        padding: EdgeInsets.all(0),
        width: double.infinity,
        transform: Matrix4.translationValues(0.0, -40.0, 0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 30.0,
                right: 30.0,
                top: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text(
                producto.nombre,
                style: TextStyle(
                  color: Color.fromRGBO(43, 43, 43, 1),
                  fontSize: responsive.ip(2.7),fontFamily: 'Quicksand',fontWeight: FontWeight.w900),
              ),
            SizedBox(height: responsive.ip(2)),
            Text(
            "Especificaciones: ${producto.equiKilos} ${AppConfig.uni_medida} | Existencias: " ,
              style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w700,color:Colors.grey,
              fontSize: responsive.ip(1.7)
              ),
            ),
            SizedBox(height: responsive.ip(2)),
                        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:<Widget>[  
              Column(
                children:<Widget>[
                    Text("\$ ${producto.precioMay}",style: TextStyle(
                      fontSize:responsive.ip(3),fontFamily: 'Quicksand',
                fontWeight: FontWeight.w900,color: miTema.accentColor,),),
                Text("\$ ${producto.precioMen}",style: TextStyle(
                  fontSize:responsive.ip(3),fontFamily: 'Quicksand',
                fontWeight: FontWeight.w900,color: miTema.accentColor,),),
                ]
              ),
              Column(
                children:<Widget>[
                  Text("Mayoreo",style: TextStyle(fontFamily:'Quicksand',
                    fontWeight: FontWeight.w700,color:Colors.grey,fontSize: responsive.ip(1.5)),),
                  SizedBox(height:responsive.ip(1.5)),
                    Text("Menudeo",style: TextStyle(fontFamily:'Quicksand',
                    fontWeight: FontWeight.w700,color:Colors.grey,fontSize: responsive.ip(1.5)),),
                ]
              ),
            Column(
              children: <Widget>[
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                  padding: EdgeInsets.symmetric(horizontal:responsive.ip(2),vertical:responsive.ip(1.5)),
                  decoration: BoxDecoration(
                    color: miTema.accentColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [BoxShadow(
                            color:Colors.black26,
                            blurRadius: 5
                    )]
                  ),
                  child: Text("AGREGAR",style: TextStyle(fontFamily: 'Quiksand',color:Colors.white,letterSpacing: 1,fontSize: 15),),
                  ),
                  onPressed: (){
                    
                    _shoppingCartBloc.insertItem(producto);
                    
                      setState(() {
                        
                      });
                    
                      Flushbar(
                        message:  "Se ha agregado al carrito de compras",
                        duration:  Duration(seconds: 2),              
                      )..show(context);
                  }),
                        ],
                      )
                      ],
                      
                        )
                      ],
                    ),
                  ),
                  
                ],
              ),
        );
    }
    
    _descripcion() {
      return  Expanded(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal:15),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            Row(
              children: <Widget>[
                Icon(LineIcons.align_center,color: Colors.black,),
                SizedBox(width:responsive.ip(1)),
              Text('Descripción', style: TextStyle(fontFamily:'Quicksand',fontSize: 18.0, fontWeight: FontWeight.w600)),
              ],
            ),
          ],),
        ),
      );
    } 
  
  
   
  }
  
  

