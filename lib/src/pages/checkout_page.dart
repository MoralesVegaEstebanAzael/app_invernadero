import 'package:app_invernadero/src/blocs/client_bloc.dart';
import 'package:app_invernadero/src/blocs/feature_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/blocs/shopping_cart_bloc.dart';
import 'package:app_invernadero/src/models/client_model.dart';
import 'package:app_invernadero/src/models/item_shopping_cart_model.dart';
import 'package:app_invernadero/src/pages/paypal/paypalPayment.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:line_icons/line_icons.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({Key key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Responsive responsive;
  // Box box;
  ShoppingCartBloc _shoppingCartBloc = ShoppingCartBloc();
  ClientBloc _clientBloc;
  // FeatureBloc _featureBloc;
  List<ItemShoppingCartModel> itemsFinal=List();
  int _radioValue=-1;
  //Stream<List<ShoppingCartModel>> _stream;
  bool _isLoading=false;
  String tipo_entrega;
  Map<dynamic,dynamic> defaultCurrency = {"symbol": "MXN ", "decimalDigits": 2, "symbolBeforeTheNumber": true, "currency": "MXN"};
  String total=""; 

  @override
  void initState() {
    super.initState();
    itemsFinal = _shoppingCartBloc.getItemsFinalList();
    _shoppingCartBloc.onChangeIsLoading(false);
  }

  @override
  void didChangeDependencies() {
    responsive = Responsive.of(context);
    _clientBloc = Provider.clientBloc(context);
    _clientBloc.dirClient();
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    _shoppingCartBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // return StreamBuilder(
    //   key: _scaffoldKey,
    //   stream: _shoppingCartBloc.isLoadingStream ,
    //   initialData: _shoppingCartBloc.isLoading ,
    //   builder: (BuildContext context, AsyncSnapshot snapshot){
    //     return Stack(
    //       key: _scaffoldKey,
    //       children: <Widget>[
    //         Positioned(
    //           child: Scaffold(
    //             key: _scaffoldKey,
    //             appBar: _appBar(),
    //             backgroundColor: Colors.white,
    //             body: Positioned(child:  _listItems()),
    //           ),
    //         ),
    //         snapshot.data?  
    //         Positioned.fill(child:  Container(
    //           color:Colors.white,
    //           child: Center(
    //             child:SpinKitCircle(color: miTema.accentColor),
    //           ),
    //         )):
    //         Container()
    //       ],
    //     );
    //   },
    // );
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: Stack(
        children:<Widget>[
          Positioned(child:  _listItems()),

          StreamBuilder(
            stream: _shoppingCartBloc.isLoadingStream ,
            initialData: _shoppingCartBloc.isLoading ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              print("Dataaaa::: ${snapshot.data}");
              if(snapshot.data){
                return Positioned.fill(child:  Container(
                      color:Colors.white,
                      child: Center(
                        child:SpinKitCircle(color: miTema.accentColor),
                      ),
                    ));
              }else{
                return Container();
              }
            },
          ),
          
          // _isLoading? Positioned.fill(child:  Container(
          //             color:Colors.white,
          //             child: Center(
          //               child:SpinKitCircle(color: miTema.accentColor),
          //             ),
          //           ))
          // : Container()
        ]
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: Text("Carrito de compras",
      style:TextStyle(
        fontFamily: 'Quicksand',
        fontWeight: FontWeight.w900,
        fontSize:responsive.ip(2.5),color:Color(0xFF545D68)
      ) ,
    ),
      leading: Container(
        margin: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        child: IconButton(
          icon: Icon(LineIcons.angle_left, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ), 
    );
  }


  
  Widget _listItems(){
    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.only(top:8),
       width: responsive.widht,
      height: responsive.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _header(),
          Container(
            height: 2,
            color:MyColors.Grey,
          ),
          (_radioValue==0)? _location():Container(),

          Container(
            margin: EdgeInsets.only(left:10),
            child: Text("Productos",
              style: TextStyle(
                fontFamily:'Quicksand',
                fontWeight:FontWeight.w900,
                fontSize:responsive.ip(2)
              ),
            ),
          ),
         
          // WatchBoxBuilder(
          // box: box, 
          // builder: (BuildContext context,Box box){
          //   return 
              Expanded(
                child:  ListView.builder(
                  itemCount:  itemsFinal.length,
                  itemBuilder: (context, index) {
                    ItemShoppingCartModel item = itemsFinal[index];
                    return _itemView(item,index);
                    })
              // );
          //}
          ),
          _confirmation()
        ],
      ),
    );
  }
  
  _itemView(ItemShoppingCartModel item,int index){
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal:8),
      width: responsive.widht,
      height: responsive.ip(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:<Widget>[
          Container(
            
            width: responsive.wp(40),
            child: Text(
              item.producto.nombre,
              style: TextStyle(
                fontFamily:'Quicksand',fontWeight:FontWeight.w900,
                fontSize: responsive.ip(1.5)
              ),
              )),
          Container(
            width: responsive.wp(20),
            // child: Text(item.unidad ?
            //       "Cajas: ${item.cantidad}"
            //       :
            //       "Kg: ${item.kilos}"
            //       )
                  
                  child: Text("${item.unidad}"),
                  ),
          Container(
              width: responsive.wp(25),
              child: Text("\$ ${item.subtotal} MX",textAlign: TextAlign.right,)),

         
        ]
      ),
    );
  }

  _header(){
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height:responsive.ip(5),
        child: Row(
          children:<Widget>[
            GestureDetector(
              onTap:()=> _handleRadioValueChange(0),
                          child: Container(
                child: Row(
                  children: <Widget>[
                    Radio(
                      activeColor: miTema.accentColor,
                      value: 0, 
                      groupValue:_radioValue, 
                      onChanged: _handleRadioValueChange),
                    Text("Dirección de envio",
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily:'Quicksand',
                        fontWeight:FontWeight.w900,
                      ),
                    ),
                  ],
                )),
            ),
            
            GestureDetector( 
              onTap: ()=>_handleRadioValueChange(1),
                          child: Container(
                child: Row(
                  children: <Widget>[
                    Radio(
                      activeColor: miTema.accentColor,
                      value: 1, 
                      groupValue:_radioValue, 
                      onChanged: _handleRadioValueChange),
                    Text("Recoger",
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily:'Quicksand',
                        fontWeight:FontWeight.w900,
                      ), 
                    ),
                    
                  ],
                ),
              ),
            ),


          ]
        ),
      ),
    );
  }

  _location(){
    return Container(
      // color: Colors.red,
      width: responsive.widht,
      height: responsive.ip(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children:<Widget>[
                GestureDetector(
                  onTap: ()=>Navigator.pushNamed(context, 'address'),
                  child: Row(
                  children: <Widget>[
                    Icon(LineIcons.edit,color: Colors.grey),
                      Text("Otra dirección",
                          style: TextStyle(color:Colors.grey),
                        )
                    ],
                  ),
                ),
              
              ]
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:<Widget>[
              Container(
                width: responsive.wp(50),
                child: StreamBuilder(
                  stream: _clientBloc.dirStream ,
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.hasData){
                      tipo_entrega = snapshot.data;
                      print("-------------------- direccion : ${tipo_entrega}" );
                      return Text(
                        snapshot.data,
                        overflow: TextOverflow.ellipsis,
                        );
                    }
                    return Container();
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:<Widget>[
                  Text("Dirección de envio",
                    style: TextStyle(
                      color:Colors.grey
                    ),
                  ),
                  SizedBox(width: responsive.ip(1),),
                  Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        new Icon(
                            Icons.brightness_1,
                            size: responsive.ip(2), color: miTema.accentColor),
                        new Icon(
                          LineIcons.check,
                          size: responsive.ip(1),
                          color: Colors.white,
                        ),
                      ],)
                ]
              ),
              Container(
                height: 2,
                color:MyColors.Grey,
              ),
            ]
          ),
        ],
      ),
    );
  }


  _confirmation(){
    return  Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom:5,left: 4,right: 4),
          padding: EdgeInsets.all(7),
          height:responsive.ip(7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>[
              Row(
                children: <Widget>[
                  
                  Icon(LineIcons.info_circle,size: responsive.ip(3),color: Colors.grey,),
                  SizedBox(width:2),
                  Text("Total: ",
                    style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w900,
                    fontSize: responsive.ip(2)
                ),),
                ],
              ),

              StreamBuilder( 
                      //stream: _shoppingCartBloc.total ,
                      stream: _shoppingCartBloc.totalFinal,
                      initialData: 0 ,
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        total = snapshot.data.toString();
                        return
               Text( 
                          "\$ ${snapshot.data} MX",
                          //"\$ ${_shoppingCartBloc.totalFinal} MX",
                          style: TextStyle(
                            fontSize: responsive.ip(2),
                            color:Colors.grey,
                            fontFamily:'Quicksand',
                            fontWeight: FontWeight.w900
                          ),
                        );
                      },
                  ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                  padding: EdgeInsets.symmetric(horizontal:responsive.ip(1.5),vertical:responsive.ip(1.3)),
                  decoration: BoxDecoration(
                    color: (_radioValue!=-1)?miTema.accentColor:Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [BoxShadow(
                            color:Colors.black26,
                            blurRadius: 5
                    )]
                  ),
                  child: Row(
                    children: <Widget>[
                      Text("CONFIRMAR",
                        style: TextStyle(
                          fontFamily: 'Quiksand',
                          color:Colors.white,letterSpacing: 1,
                          fontSize: responsive.ip(1.5)),),
                      SizedBox(width:5),
                      Icon(LineIcons.check,color:Colors.white,size: responsive.ip(2),)
                    ],
                  ),
                  ),
                  onPressed: (_radioValue!=-1)? ()=>_pagoPaypal():null),
            ]
          ),
        )
    );
  }
  bool validaData(ClientModel c){
    if(c.nombre==null || c.ap==null|| c.am==null)
      return false;
    return true;
  }
  void _pagoPaypal(){
    ClientModel cliente = _clientBloc.cliente();

    print("total $total");
    if(validaData(cliente)){
       print("nombre ${cliente.nombre} ${cliente.ap} ${cliente.am} ${cliente.direccion} ${cliente.celular}");




    List<dynamic> list = _toList();
    
    
    String totalAmount = total;
    String subTotalAmount = total;
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    String userFirstName = cliente.nombre;
    String userLastName = cliente.ap;
    String addressCity = 'Delhi';
    String addressStreet = 'Mathura Road';
    String addressZipCode = '110014';
    String addressCountry = 'Mexico';
    String addressState = 'Oaxaca';
    String addressPhoneNumber = cliente.celular;
    _shoppingCartBloc.onChangeIsLoading(true);
    Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => 
                            PaypalPayment(
                              onFinish: (number) async {
                                print('order id: '+number);
                                _shoppingCartBloc.deleteAllSC();
                                Flushbar(
                                  message:  "Pedido enviado",
                                  duration:  Duration(seconds: 1),              
                                  )..show(_scaffoldKey.currentContext).then((f){
                                    Navigator.pop(_scaffoldKey.currentContext); 
                                    Navigator.pop(_scaffoldKey.currentContext);
                                  });

                               

                              },
                              list: list,
                              totalAmount: totalAmount,
                              subTotalAmount: subTotalAmount,
                              shippingCost: shippingCost,
                              shippingDiscountCost: shippingDiscountCost,
                              userFirstName: userFirstName,
                              userLastName: userLastName,
                              addressCity: addressCity,
                              addressStreet: addressStreet,
                              addressZipCode: addressZipCode,
                              addressCountry: addressCountry,
                              addressState: addressState,
                              addressPhoneNumber: addressPhoneNumber,
                              tipoEnvio:_radioValue,
                              tipoEntrega: tipo_entrega,
                              itemFinal: itemsFinal,
                            ),
                          ),
      );
      
    }else{
       Flushbar(
        message:  "Configura tus datos",
        duration:  Duration(seconds: 2),              
        )..show(context).then((f){
           Navigator.pushNamed(context, 'configuracion');
        });
    }
    
   
  }


  
  // void _confirmar()async{
   
  //   setState(() {
  //      _isLoading=true;
  //   });
  //   Map response = await _shoppingCartBloc.sendPedido(itemsFinal, tipo_entrega);
  //   setState(() {
  //     _isLoading=false;
  //   });
  //   switch(response['ok']){
  //     case 1:
  //       print("TOODO CON EXITO");
  //       //
  //       // Flushbar(
  //       //       message:  "Tu pedido ha sido enviado.",
  //       //       duration:  Duration(seconds: 2),              
  //       //     )..show(context);
  //       _shoppingCartBloc.deleteAllSC();
  //       final nav = Navigator.of(context);
  //       nav.pop();
  //       nav.pop();
  //     break;
  //     case 0:
  //      Flushbar(
  //             message:  "Algo ha salido mal.",
  //             duration:  Duration(seconds: 2),              
  //           )..show(context);
  //     break;
  //     case 2:
  //     print("CONFIGURAR DATOS");
  //       // Navigator.pushNamed(context, 'detail');
  //         Flushbar(
  //             message:  "Configura tus datos",
  //             duration:  Duration(seconds: 2),              
  //           )..show(context);
  //       Navigator.pushNamed(context, 'configuracion');
  //     break;
  //   }
  // }

  
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
    
    (value == 1) ? tipo_entrega='Recoger': '';
    print("-------- ${tipo_entrega}");
  }

  List<dynamic> _toList(){
     List items = List();

    itemsFinal.forEach((f){
      print("mandando objetos....");
      print("${f.producto.nombre}");
      

  String itemName = f.producto.nombre;
  int quantity =f.cantidad!=null?f.cantidad:1;
  double temp = f.subtotal/quantity;
  String itemPrice = temp.toString();
  
       dynamic item = {
      "name": itemName,
      "quantity": quantity,
      "price": itemPrice,
      "currency": defaultCurrency["currency"]
    };

     print("mandando objetos...***.$item");
      items.add(item);
    });

    return items;
  }
}