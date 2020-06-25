import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flutter/material.dart';


class BadgeIcon extends StatelessWidget {
  final IconButton iconButton;
  final int number;
  final VoidCallback onTap;

  const BadgeIcon({Key key, this.iconButton, this.number, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Responsive _responsive = Responsive.of(context);

    return  new Container( 
      child: new GestureDetector(
        onTap: onTap,
        child: new Stack(
          children: <Widget>[
            iconButton,
            (number>=0)?
           new Positioned(
            right: _responsive.ip(0.6),
            top: _responsive.ip(1),
              child: new Stack(
              alignment: Alignment.center,
              children: <Widget>[
                new Icon(
                    Icons.brightness_1,
                    size: _responsive.ip(2), color: miTema.accentColor),
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
        ),
      )
    );
  }
}