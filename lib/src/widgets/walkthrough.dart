import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Walkthrough extends StatefulWidget {
  final title;
  final content;
  final imgPath;
  final imagecolor;

  Walkthrough(
      {this.title,
      this.content,
      this.imgPath,
      this.imagecolor = Colors.redAccent});

  @override
  WalkthroughState createState() {
    return WalkthroughState();
  }
}

class WalkthroughState extends State<Walkthrough>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween(begin: -250.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

    animation.addListener(() => setState(() {}));

    animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return AspectRatio(
        
        aspectRatio: 16/11,
        child: LayoutBuilder(

          builder:(_,contraints){
            return Container(

             child: Column(
               crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            
            Stack(
              children: <Widget>[
               
                 Positioned(
                    top:contraints.maxHeight*.01,
                    right: 0,
                    left: 0,
                    child: SvgPicture.asset('assets/images/intro_screen/stain.svg',
                   
                      height: contraints.maxHeight*.6,
                      width: contraints.maxWidth,
                    ),
                  ),
                   Container(
                        child: SvgPicture.asset(widget.imgPath,
                          height: contraints.maxHeight*.6,
                          width: contraints.maxWidth,
                        ),
                      ),
              ],
            ),
           new Transform(
              transform:
                  new Matrix4.translationValues(animation.value, 0.0, 0.0),
              child: new Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1,
                    fontSize: responsive.ip(3),
                    fontWeight: FontWeight.bold,
                    color:miTema.primaryColor),
              ),
            ),
            Transform(
              transform:
                  new Matrix4.translationValues(animation.value, 0.0, 0.0),
              child: new Text(widget.content,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0,
                      color: Color(0xFFCDCDCD))),
            ),
          ],
        ),
            );
          }
        )
    );
  }
}



 