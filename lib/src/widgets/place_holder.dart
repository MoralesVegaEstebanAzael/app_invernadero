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
          aspectRatio: 16/18,
          child: LayoutBuilder(
            builder:(_,contraints){
              return Container(
               child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: SvgPicture.asset(_imgPath,
                        height: contraints.maxHeight*.3,
                        width: contraints.maxWidth,
                      ),
                  ),
                  SizedBox(height:responsive.ip(2)),
                  Text(
                    _title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      letterSpacing: 1,
                        fontSize: responsive.ip(1.5),
                        fontWeight: FontWeight.w900,
                        color:Color(0xffbbbbbb)),
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