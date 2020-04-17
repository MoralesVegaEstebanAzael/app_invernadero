import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Welcome extends StatelessWidget {
  final  title,imgPath;
  final heightPercent,widthPercent,topPercent;
  const Welcome({
    @required this.title,
    @required this.imgPath,
    @required this.heightPercent,
    @required this.widthPercent,
    @required this.topPercent}) :assert(title!=null,imgPath!=null);


  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return AspectRatio(
        aspectRatio: 16/12,
        child: LayoutBuilder(

          builder:(_,contraints){
            return Container(

              child: Stack(
                alignment: Alignment.center,
                
                children: <Widget>[
                  
                  Positioned(
                    
                    top: contraints.maxHeight*0.80,
                    child: Column(
                      children:<Widget>[
                        Container(
                      height: 3,
                      width: contraints.maxWidth,
                      color: Color(0xFFEEEEEE),
                    ),
                    SizedBox(height:responsive.ip(3)),
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize:responsive.ip(2.5),
                        fontWeight:FontWeight.w600
                      ),
                      )
                      ]
                    )
                  ),
                  Positioned(
                    top:contraints.maxHeight*.11,
                    right: 0,
                    left: 0,
                    child: SvgPicture.asset('assets/images/fondo.svg',
                   
                      height: contraints.maxHeight*.7,
                      width: contraints.maxWidth,
                    ),
                  ),
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: <Widget>[
                      Positioned(
                        top:contraints.maxHeight*0.21,
                        child: SvgPicture.asset('assets/images/sun.svg',
                          width: contraints.maxWidth*0.10,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: contraints.maxHeight*topPercent,
                    child: SvgPicture.asset(imgPath,
                    width: contraints.maxWidth*widthPercent,
                    height: contraints.maxHeight*heightPercent,
                    
                    ),
                  ),
                ]
              ),
            );
          }
        )
    );
  }
}