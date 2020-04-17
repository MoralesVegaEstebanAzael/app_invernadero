
import 'package:flutter/material.dart';
class SignInOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SafeArea(
          
                  child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background2.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter
              )
            ),
          ),
        )
       
      ],
    );
  }
}