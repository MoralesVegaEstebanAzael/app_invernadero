import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/blocs/shopping_cart_bloc.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/badge_icon.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:app_invernadero/src/widgets/place_holder.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../shopping_cart_page.dart';

class PedidosPage extends StatefulWidget {
  PedidosPage({Key key}) : super(key: key);

  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  Responsive _responsive;
  ShoppingCartBloc _shoppingCartBloc;
  @override
  void initState() {
   
    super.initState();
  }

  @override
  void didChangeDependencies() {
     _responsive = Responsive.of(context);

     _shoppingCartBloc = Provider.shoppingCartBloc(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    _shoppingCartBloc.countItems();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: PlaceHolder( 
        img: 'assets/images/empty_states/empty_order.svg',
        title: 'No haz realizado pedidos',)//Container(),
    );
  }

  _appBar(){
    return AppBar(
      brightness :Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      title: Text("Mis pedidos",
        style:TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w900,
          fontSize:_responsive.ip(2.5),color:Color(0xFF545D68)
        ) ,
      ),
     
      actions: <Widget>[
        IconAction(
          icon:LineIcons.search,
          onPressed:null
        ),
         StreamBuilder(
          stream: _shoppingCartBloc.count ,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              int number = snapshot.data;
              return BadgeIcon(
                iconButton:  new IconButton(icon: new Icon(LineIcons.shopping_cart,
                color: MyColors.BlackAccent,),
                  onPressed: null,
              ),
              number: number,
              onTap:() =>_func()
         
        , 
              );
            }
            return Container();
          },
        ),
      ],
    );
  }

   _func(){
     Navigator.of(context).push(
              new MaterialPageRoute(
                  builder:(BuildContext context) =>
                  new ShoppingCartPage()
              )
          );
  }
}