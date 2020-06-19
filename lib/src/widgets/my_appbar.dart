import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final List<Widget> actions;

  const MyAppBar({Key key, 
  @required this.title, 
  this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);

    return AppBar(
      brightness: Brightness.light,
      elevation: 0.0,
      backgroundColor: Colors.white,
      leading: IconButton(icon: Icon(LineIcons.angle_left,color: Colors.grey,), 
      onPressed:()=> Navigator.pop(context)),
      centerTitle: true,
      title: Text(
          this.title,
          style:TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w900,
            fontSize:responsive.ip(2.5),color:Color(0xFF545D68)
          ) ,
        ),
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>  Size(double.infinity, kToolbarHeight);
}