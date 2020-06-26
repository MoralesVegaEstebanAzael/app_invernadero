import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flutter/material.dart';


class BadgeBottomIcon extends StatelessWidget {
  final Icon icon;
  final int number;

  const BadgeBottomIcon({Key key, this.icon, this.number}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Responsive _responsive = Responsive.of(context);

    return  new Container( 
      width: _responsive.ip(3),
      child: new Stack(
        children: <Widget>[
          icon,
          (number>0)?
          new Positioned(
          right: _responsive.ip(-0.1),
          top: _responsive.ip(-.2),
            child: new Stack(
            alignment: Alignment.center,
            children: <Widget>[
              new Icon(
                  Icons.brightness_1,
                  size: _responsive.ip(2), color:Colors.redAccent),
              new Text(
              number.toString(),
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: _responsive.ip(1),
                    fontWeight: FontWeight.w500
                ),
              ),
            ],
          ))
          :
          Container()
        ],
      )
    );
  }
}