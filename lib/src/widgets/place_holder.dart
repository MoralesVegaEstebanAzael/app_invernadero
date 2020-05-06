import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class PlaceHolder extends StatelessWidget {
  String _imgPath;
  String _title;

  PlaceHolder({@required img,@required title}){
    this._imgPath = img;
    this._title = title;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return  Center(
      child: AspectRatio( 
          aspectRatio: 16/16,
          child: LayoutBuilder(
            builder:(_,contraints){
              return Container(
               child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: SvgPicture.asset(_imgPath,
                        height: contraints.maxHeight*.6,
                        width: contraints.maxWidth,
                      ),
                  ),
                  Text(
                    _title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 1,
                        fontSize: responsive.ip(3),
                        fontWeight: FontWeight.normal,
                        color:miTema.primaryColor),
              ),
            ],
          ),
              );
            }
          )
      ),
    );
  }
}