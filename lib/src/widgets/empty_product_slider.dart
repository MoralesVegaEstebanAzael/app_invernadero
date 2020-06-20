import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class EmptySliderProduct extends StatelessWidget {

  final Responsive responsive;

  const EmptySliderProduct({Key key,@required this.responsive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Container(
      width: responsive.widht,
      height: responsive.ip(20),
      margin: EdgeInsets.only(left: 15,right: 15,top: 10),
      child:Row(
        children:<Widget>[
          Expanded(child: Container(
                    decoration: BoxDecoration(
            color: MyColors.PlaceholderBackground,
            borderRadius:BorderRadius.circular(15),
          ),
                  ),),
                  SizedBox(width:responsive.ip(2)),
                  Expanded(child: Container(
                    decoration: BoxDecoration(
            color: MyColors.PlaceholderBackground,
            borderRadius:BorderRadius.circular(15),
          ),
          ),)
        ]
      )
      // child: Image(image: AssetImage('assets/placeholder_products.gif'))
    );
  }
}