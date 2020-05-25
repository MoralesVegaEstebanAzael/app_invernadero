import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/blocs/shopping_cart_bloc.dart';
import 'package:app_invernadero/src/models/item_shopping_cart_model.dart';
import 'package:app_invernadero/src/models/shopping_cart_model.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:line_icons/line_icons.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({Key key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Responsive responsive;
  Box box;
  ShoppingCartBloc _shoppingCartBloc;
  int _radioValue=-1;
  //Stream<List<ShoppingCartModel>> _stream;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    responsive = Responsive.of(context);
    _shoppingCartBloc = Provider.shoppingCartBloc(context);
    _shoppingCartBloc.loadItems();
    box = _shoppingCartBloc.box();
   // _stream = _shoppingCartBloc.shoppingCartStream;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body:_listItems()
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
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
            color: Colors.black12,
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
         
          WatchBoxBuilder(
          box: box, 
          builder: (BuildContext context,Box box){
            return 
              Expanded(
                child:  ListView.builder(
                  itemCount:  box.length,
                  itemBuilder: (context, index) {
                    ItemShoppingCartModel item = box.getAt(index);
                    return _itemView(item,index);
                    })
              );
          }),
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
            child: Text("Cajas: ${item.cantidad}")),
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
      width: responsive.widht,
      height: responsive.ip(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children:<Widget>[
          Text("Dirección calle vicente Guerrero"),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children:<Widget>[
              Text("Dirección de envio",
                style: TextStyle(
                  color:Colors.grey
                ),
              ),
              SizedBox(width: responsive.ip(1),),
              Container(
                
                decoration: BoxDecoration(
                color: miTema.accentColor,
                shape: BoxShape.circle,
                ),
                child: Icon(LineIcons.check,color: Colors.white,)),
             
            ]
          ),
          Container(
            height: 2,
            color:MyColors.Grey,
          ),
        ]
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
                      stream: _shoppingCartBloc.total ,
                      initialData: 0 ,
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        return Text( 
                          "\$ ${snapshot.data} MX",
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
                  onPressed: (_radioValue!=-1)? ()=>print("object"):null),
            ]
          ),
        )
    );
  }


  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }
}