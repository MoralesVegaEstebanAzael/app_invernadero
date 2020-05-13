import 'package:app_invernadero/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class MyAppBar extends StatelessWidget {
  String _title;

  MyAppBar({@required title}){
    this._title = title;
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      title: Text(_title,
        style:TextStyle(
          fontFamily: 'Varela',fontSize:25.0,color:Color(0xFF545D68)
        ) ,
      ),
      actions: <Widget>[
        IconButton(
        icon: Icon(LineIcons.bell,color:Color(0xFF545D68),), 
        onPressed: (){
          Navigator.pushNamed(context, 'notifications');
        }),
      ],

    );
  }
}