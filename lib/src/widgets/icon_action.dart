import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class IconAction extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color iconCorlor;
  final Color color;
  
  const IconAction({ 
    this.icon, this.onPressed,
    this.iconCorlor=MyColors.BlackAccent,this.color=MyColors.Grey});

  @override
  _IconActionState createState() => _IconActionState();
}

class _IconActionState extends State<IconAction> {
  Responsive _responsive;

  @override
  void didChangeDependencies() {
    _responsive = Responsive.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: _responsive.ip(5),
        height: _responsive.ip(5),
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color:widget.color,
          shape: BoxShape.circle, 
        ),
        child:  IconButton(
        icon: Icon(widget.icon,color:widget.iconCorlor,
          size: _responsive.ip(2.5),
        ), 
        onPressed: widget.onPressed),
    );
  }
}