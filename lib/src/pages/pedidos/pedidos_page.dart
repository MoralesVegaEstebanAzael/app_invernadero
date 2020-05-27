import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class PedidosPage extends StatefulWidget {
  PedidosPage({Key key}) : super(key: key);

  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  Responsive _responsive;

  @override
  void initState() {
   
    super.initState();
  }

  @override
  void didChangeDependencies() {
     _responsive = Responsive.of(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: Container(),
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
      leading:Row(
         children: <Widget>[
           IconAction(
              icon:LineIcons.bell,
              onPressed:()=>Navigator.of(context).pop()
            ),
         ],
       ),
      actions: <Widget>[
        IconAction(
          icon:LineIcons.search,
          onPressed:null
        ),
        IconAction(
          icon:LineIcons.shopping_cart,
          onPressed:()=> Navigator.pushNamed(context, 'shopping_cart')
        )
      ],
    );
  }
}