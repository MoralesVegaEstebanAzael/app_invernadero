import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:app_invernadero/src/widgets/place_holder.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key}) : super(key: key);
  
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Responsive _responsive;
  
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
      body:PlaceHolder(
        img: 'assets/images/empty_states/empty_notifications.svg',
        title: 'No tienes notificaciones',
      ),
    );
  }


  _appBar(){
    return AppBar(
      brightness :Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      title: Text("Notificaciones",
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
        IconAction(
          icon:LineIcons.shopping_cart,
          onPressed:()=> Navigator.pushNamed(context, 'shopping_cart')
        )
      ],
    );
  }
}