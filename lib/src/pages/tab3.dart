import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/place_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';

class Tab3 extends StatelessWidget { 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: PlaceHolder(
        img: 'assets/images/empty_cart.svg',
        title: 'No hay articulos',
      )
    );
  }
  
  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
        title: Text('SHOPPING BAG',
          style:TextStyle(
            fontFamily: 'Varela',fontSize:25.0,color:Color(0xFF545D68)
          ) ,
        ),
        actions: <Widget>[
          IconButton(
          icon: Icon(LineIcons.bell,color:Color(0xFF545D68),), 
          onPressed: (){}),
        ],
    );
  }

}