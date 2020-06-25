import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class ProductsEmpty extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    return Container(
  //     margin: EdgeInsets.only(left: 15,right: 15,top: 10),
      width: double.infinity,
     height: responsive.ip(20),
      
       child:Row(
        children:<Widget>[
          Expanded(child: _container(responsive)),
          Expanded(child: _container(responsive))
        ]
      )
      
    );
  }
  
  _container(Responsive responsive){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:MyColors.Grey,   
      ),
      margin: EdgeInsets.symmetric(vertical:5,horizontal:5),
      child: Stack(
           alignment: Alignment.center,
          children : <Widget>[
            Positioned(
              top: responsive.ip(2),
              left: responsive.ip(1),
                child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  height: responsive.ip(13),
                  child: Image.asset('assets/placeholder.png'))
                
                
                ),
            ),
            
            // Positioned(
            //   top:responsive.ip(0.5),
            //   right: 0,
            //   child: _buttonFav(producto)),
            Positioned(
              bottom: responsive.ip(0.5),
              child: Container(
                height: responsive.ip(7),
                width: responsive.ip(19),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(),
              )
            ),

            
          ]
        ),
    );
  }
}