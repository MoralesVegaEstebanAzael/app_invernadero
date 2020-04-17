import 'package:app_invernadero/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: Colors.transparent,
      elevation: 9.0,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height:50.0,
        decoration: BoxDecoration(
          borderRadius:BorderRadius.only(
            topLeft:Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width/2-40.0,
              child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: <Widget>[
                 Icon(LineIcons.home,color:miTema.primaryColor),
                 Icon(LineIcons.user,color:Color(0xFF676E79))
               ],
              ),
              ),
              
            Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width/2-40.0,
              child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: <Widget>[
                 Icon(LineIcons.search,color:Color(0xFF676E79)),
                 Icon(LineIcons.shopping_cart,color:Color(0xFF676E79))
               ],
              ),
              )
          ]
        ),
      ),
    );
  }
}