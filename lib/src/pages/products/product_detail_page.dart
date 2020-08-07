
import 'package:app_invernadero/src/blocs/bottom_nav_bloc.dart';
import 'package:app_invernadero/src/blocs/client_bloc.dart';
import 'package:app_invernadero/src/blocs/favoritos_bloc.dart';
import 'package:app_invernadero/src/blocs/producto_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/blocs/shopping_cart_bloc.dart';
import 'package:app_invernadero/src/models/item_shopping_cart_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/pages/shopping_cart_page.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/alert_dialog_select.dart';
import 'package:app_invernadero/src/widgets/input_text.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';



import '../../../app_config.dart';
  import 'dart:math' show pi;

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
    String dropdownValue = 'Kilogramos';
    int unidades=1;
    FavoritosBloc favoritosBloc;
    bool _unidad=true;
    double _kilos=10;
    double _toneladas=1;

    int currentIndex = 0;
    PageController _pageController;

    ProductoBloc productoBloc;
    int _radioValue=-1;

    String unidadM = AppConfig.uniMedidaCaja;
    String unidad=AppConfig.uniMedidaCaja;


    @override
    void initState() {
       _pageController = PageController();
      FlutterStatusbarcolor.setStatusBarColor(miTema.accentColor);
      _dbProvider = DBProvider();
      _bottomNavBarBloc = BottomNavBloc();
     
      super.initState();
    }

    @override
    void didChangeDependencies() {
      responsive = Responsive.of(context);
      producto = ModalRoute.of(context).settings.arguments;
      favoritosBloc = Provider.favoritosBloc(context);
      _shoppingCartBloc = Provider.shoppingCartBloc(context);
      super.didChangeDependencies();
      productoBloc = Provider.productoBloc(context);

  
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
        
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                              child: CustomScrollView(
                slivers: <Widget>[
                  _appBar(),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _contenido(),
                    
                    ]),
                  ),
                 
      ],),
              ),
            _bottom()
            ],
          ),
        ),);
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
            color: Colors.white,
            height: responsive.height,
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                
              _background(),
              _encabezado(),
              _switch(),
              
              SizedBox(height:responsive.ip(1)),
              _control()
              // _descripcion(),
             // _dropDown()
             
              ],
            ),
          ),
        );
    }
  
    _background() {
      return AspectRatio(
        aspectRatio: 16/10,
            child: Container(
              color:miTema.accentColor,
              child: Stack(children: <Widget>[
          Positioned(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom:45.0),
                   child:Hero(
                      tag: producto.id,
                      child:  (producto.urlImagen!=null)? FadeInImage(
              placeholder: AssetImage('assets/placeholder.png'), 
              image: NetworkImage(producto.urlImagen),
              fit : BoxFit.cover,
              height: responsive.ip(25),
              ):
              Container(
                height:responsive.ip(13),
                child:Image.asset('assets/placeholder.png')
              )//(producto.urlImagen!=null)?
                    // FadeInImage(
                    //     width: responsive.ip(25),
                    //     image: NetworkImage(producto.urlImagen) , 
                    //     placeholder: AssetImage('assets/placeholder.png'),)
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Text(
              
            "Producto de ${producto.snombre}${producto.sdistrito}, ${producto.smunicipio}, región ${producto.sregion} " ,
              style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w700,color:Colors.grey,
              fontSize: responsive.ip(1.4)
              ),
              // textAlign: TextAlign.center,
            ),
            //             Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // children:<Widget>[  
            //   Column(
            //     children:<Widget>[
            //         Text("\$ ${producto.precioMay}",style: TextStyle(
            //           fontSize:responsive.ip(3),fontFamily: 'Quicksand',
            //     fontWeight: FontWeight.w900,color: miTema.accentColor,),),
            //     Text("\$ ${producto.precioMen}",style: TextStyle(
            //       fontSize:responsive.ip(3),fontFamily: 'Quicksand',
            //     fontWeight: FontWeight.w900,color: miTema.accentColor,),),
            //     ]
            //   ),
            //   Column(
            //     children:<Widget>[
            //       Text("Mayoreo",style: TextStyle(fontFamily:'Quicksand',
            //         fontWeight: FontWeight.w700,color:Colors.grey,fontSize: responsive.ip(1.5)),),
            //       SizedBox(height:responsive.ip(1.5)),
            //         Text("Menudeo",style: TextStyle(fontFamily:'Quicksand',
            //         fontWeight: FontWeight.w700,color:Colors.grey,fontSize: responsive.ip(1.5)),),
            //     ]
            //   ),
            //           ],
                      
            //             ),
                        // SizedBox(height:5),
                    //      Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //        children:<Widget>[
                    //          Text("Unidad de medida", style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w700,color:Colors.grey,
                    // fontSize: responsive.ip(1.7)
                    // ),),
                    //       _dropDown()
                    //        ]
                    //      )
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
  _switch(){
    return Container(
      // color: Colors.red,
      color: Colors.white,
      padding: EdgeInsets.only(left:30,right:30),
     
      height: responsive.ip(5),
      // child: //_dropDown(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:<Widget>[
          _dropDown(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children:<Widget>[
              Text("\$${producto.precioMen} MX",
                style: 
                TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w800,fontSize: responsive.ip(2)),

                ),
                // Text("Menudeo"),
                Text("Precio de mayoreos \$${producto.precioMay} Mx",
                  style:TextStyle(
                    fontSize: responsive.ip(1.5),
                    color:Colors.grey,
                    fontFamily:'Quicksand',
                    fontWeight:FontWeight.w800
                  ) ,)
            ]
          )
        ]
      ),
    );
  }


  _control(){
    return Container(
      padding: EdgeInsets.only(left:30,right:30),
      width: double.infinity,
      child: StreamBuilder(
        stream: productoBloc.uniMedidaStream ,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            List<dynamic> list = snapshot.data;
           unidad = list[0];

            if(unidad==AppConfig.uniMedidaKilo){
              return _slider();
            }else if(unidad==AppConfig.uniMedidaTonelada){
              return _inputNumber();
            }
            return _controlButton();

          }else{
            return _controlButton();
          }
        },
      ),
    );
    
  } 
  
  _controlButton(){
    return Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            
            IconButton(icon: Icon(LineIcons.minus_circle,size: responsive.ip(3.5)), onPressed: (){setState(() {
              unidades>1?unidades--:unidades=unidades;
            });}),
            Container(
              width: responsive.ip(3),
              child: Center(child: Text("$unidades",style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w800,fontSize: responsive.ip(2)),))),
            IconButton(icon: Icon(LineIcons.plus_circle,size: responsive.ip(3.5)), onPressed: (){setState(() {
              unidades++;
            });}),
          ],);
  }
  
    
    _dropDown(){
      return _uniIndicator();
    //  return Container(
    //    height: 500,
    //    width: double.infinity,
    //    child: radialm.RadialMenu(items, fanout: Fanout.bottomRight),
      
    //  );

    //   return ToggleSwitch(
    //   minWidth: 90.0,
    //   minHeight: 70.0,
    //   initialLabelIndex: 2,
    //   cornerRadius: 20.0,
    //   activeFgColor: Colors.grey,
    //   inactiveBgColor: Colors.white,
    //   inactiveFgColor: Colors.grey[500],
    //   labels: ['Cajas', 'Kg', 'Toneladas'],
    //   icons: [
    //     FontAwesomeIcons.boxOpen,
    //     FontAwesomeIcons.weight,
    //     FontAwesomeIcons.weightHanging
    //   ],
    //   iconSize: 20,
    //   activeBgColors: [Colors.greenAccent, Colors.pink, Colors.purple],
    //   onToggle: (index) {
    //     print('switched to: $index');
    //   },
    // );

      return LiteRollingSwitch(
        value: _unidad,
        textOn: 'Caja',
        textOff: 'Kg',
        text3:'tres',
        colorOn: miTema.accentColor,//Colors.greenAccent[700],
        colorOff:  Colors.redAccent[400],
        color3:Colors.yellow,
        iconOn: FontAwesomeIcons.boxOpen,
        iconOff: FontAwesomeIcons.weight,
        textSize: 14.0,
        onTap: (){
          setState(() {
            
          });
        },
        onChanged: (bool state) {

          
          _unidad=state;

        },
      );

    
    }


  _uniIndicator(){
    return GestureDetector(
      onTap: (){
        showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogSelect(unidad: unidad,);
      });


      },
          child: StreamBuilder(
            stream: productoBloc.uniMedidaStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){

              
              List<dynamic> list = snapshot.data;
              
              unidadM = list[0];

              return   Container(
              width: responsive.ip(15),
              decoration: BoxDecoration(
                color: miTema.accentColor,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:<Widget>[
                  Container(
                    margin: EdgeInsets.only(left:10),
                    child: Text(
                
                
                 list[0].toString()==AppConfig.uniMedidaKilo?'Kg':list[0].toString(),
              style:TextStyle(
                fontSize: responsive.ip(2),
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w900,

                color: Colors.white))),
            
            Stack(
              alignment: Alignment.center,
              children:<Widget>[
                Icon(Icons.brightness_1,color: Colors.white,size: responsive.ip(5),),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(list[1],color: miTema.accentColor),
                )
              ]
            )
          ]
        ),
      );
              }else{
                return   Container(
        width: responsive.ip(15),
        decoration: BoxDecoration(
          color: miTema.accentColor,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:<Widget>[
            Container(
              margin: EdgeInsets.only(left:10),
              child: Text( "unidad",
              style:TextStyle(
                fontSize: responsive.ip(2),
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w900,

                color: Colors.white))),
            
            Stack(
              alignment: Alignment.center,
              children:<Widget>[
                Icon(Icons.brightness_1,color: Colors.white,size: responsive.ip(5),),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(FontAwesomeIcons.ruler,color: miTema.accentColor),
                )
              ]
            )
          ]
        ),
      );
              }
            },
          ),
    );
  }
  _bottom(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        // padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom:responsive.ip(1),left: responsive.ip(2),right: responsive.ip(2)),
        width:double.infinity,
        height:responsive.ip(7),
       
        child: Row(
          children:<Widget>[
            Container(
              
              width: responsive.ip(6),
              height: responsive.ip(6),
              decoration: BoxDecoration(
              // color: Colors.green,
                borderRadius:BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: Colors.grey
                ),
              ),
              child: Center(
                child: _buttonFav(producto),
               // child: IconButton(icon: Icon(LineIcons.heart_o,color: Colors.grey,),onPressed: (){},)
              ),
            ),
            SizedBox(width:responsive.ip(2)),
            Expanded(child: 
           GestureDetector(
             onTap: (){
                if(unidad==AppConfig.uniMedidaCaja) //cajas
                  _shoppingCartBloc.insertItem(producto,unidadM,unidades);
                else if(unidad==AppConfig.uniMedidaKilo){
                 
                  _shoppingCartBloc.insertItem(producto,unidadM,_kilos);   
                }else if(unidad==AppConfig.uniMedidaTonelada){
                  _shoppingCartBloc.insertItem(producto,unidadM,_toneladas);
                }
                      setState(() {
                        
                      });
                    
                      Flushbar(
                        message:  "Se ha agregado al carrito de compras",
                        duration:  Duration(seconds: 2),              
                      )..show(context);
             },
                        child: Container(
              //  width: responsive.ip(10),
                height: responsive.ip(6),
                decoration: BoxDecoration(
                  color:MyColors.GreenAccent,
                  borderRadius:BorderRadius.circular(15)
                ),
               child:Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                //  Icon(FontAwesomeIcons.solidSmileBeam),
                 SvgPicture.asset('assets/icon/smile_icon.svg',
                height: 25,
                width: 25,
                ),
                 
                 SizedBox(width:2),
                 Text("Agregar",
                 
                 style: TextStyle(
                   letterSpacing: 2,
                   fontFamily: 'Quicksand',
                   fontWeight: FontWeight.w800,
                   fontSize: responsive.ip(2),
                   color:Colors.white),)
               ],)
             ),
           )
            )
            
          ]
        ),
      ),
    );

    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(bottom:10),
        width:double.infinity,
        height:responsive.ip(7),
        // color: Colors.redAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:<Widget>[
            IconButton(
              icon: Icon(LineIcons.minus,size: responsive.ip(3),color: Colors.black,), 
              onPressed: (){
                setState(() {
                  unidades--;
                });
              }),
            Text("$unidades",style: TextStyle(fontSize:responsive.ip(4),fontFamily:'Quicksand'),),
            IconButton(
              icon: Icon(LineIcons.plus,size: responsive.ip(3),color: Colors.black,),
               onPressed: (){
                 setState(() {
                   unidades++;
                 });
               }),
            // Icon(Icons.brightness_1)
            Container(
              width: responsive.ip(6),
              height: responsive.ip(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color:miTema.accentColor,
              ),
              child: Icon(LineIcons.shopping_cart,color:Colors.white,size:responsive.ip(4)),
            )
          ]
        ),
      ),);
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
            color: isLiked?Colors.redAccent:Colors.grey,
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

  
  
  _slider(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SliderTheme(
  data: SliderTheme.of(context).copyWith(
    activeTrackColor: Colors.red[700],
    inactiveTrackColor: Colors.white,
    trackShape: RoundedRectSliderTrackShape(),
    trackHeight: 4.0,
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
    thumbColor: Colors.redAccent,
    overlayColor: Colors.red.withAlpha(32),
    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
    tickMarkShape: RoundSliderTickMarkShape(),
    activeTickMarkColor: Colors.red[700],
    inactiveTickMarkColor: Colors.red[100],
    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
    valueIndicatorColor: Colors.redAccent,
    valueIndicatorTextStyle: TextStyle(
      color: Colors.white,
    ),
  ),
  child: Slider(
    value: _kilos,
    min: 10,
    max: 19,
    divisions: 9,
    label: '$_kilos',
    onChanged: (value) {
      setState(
        () {
          _kilos = value;

          print("Agregando kilos..... $_kilos");
        }
      );
    },
  ),
),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text("$_kilos kg",style: TextStyle(
            color:Colors.grey,
            fontFamily:'Quicksand',
            fontWeight:FontWeight.w800,
            fontSize: responsive.ip(1.8)
          ),),
        ),
      ],
    );
    // return 
  }


  _inputNumber(){

    return StreamBuilder(
      
      stream: _shoppingCartBloc.toneladasStream,
      builder: (BuildContext context,AsyncSnapshot snapshot){
        if(snapshot.hasData)
        _toneladas = double.parse(snapshot.data.toString());
        else
        _toneladas=1;

        
      return InputText(
        inputType: TextInputType.number,
        placeholder: 'Toneladas',
        validator: (String text){
        },
        icon: FontAwesomeIcons.weightHanging,
        onChange: _shoppingCartBloc.changeToneladas,
        errorText: snapshot.error,
        // inputFormatters: [maskTextInputFormatter], 
        //               autocorrect: false, 
      );
    });   

   
  }
  
   
  }
  
  

