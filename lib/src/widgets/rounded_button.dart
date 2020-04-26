
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const RoundedButton({Key key,@required this.label,@required this.onPressed}) 
    :assert(label!=null), super(key: key);

  @override
  Widget build(BuildContext context) {
   return CupertinoButton(
     padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal:35,vertical:10),
        decoration: BoxDecoration(
          color: onPressed==null?Colors.grey:miTema.accentColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(
            color:Colors.black26,
            blurRadius: 5
          )]
        ),
        child: Text(this.label,style: TextStyle(color:Colors.white,letterSpacing: 1,fontSize: 18),),
      ),
      onPressed: onPressed);
  }
}