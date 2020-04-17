
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/flutkart.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/walkthrough.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_icons/line_icons.dart';

class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() {
    return IntroScreenState();
  }
}

class IntroScreenState extends State<IntroScreen> {
  final PageController controller = new PageController();
  int currentPage = 0;
  bool lastPage = false;

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == 3) {
        lastPage = true;
      } else {
        lastPage = false;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      
      body: Container(
      color: Colors.white,
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: SafeArea(
                child: Container(
                padding: EdgeInsets.only(top:20),
                child: Text('Invernadero Sebastián Atoyaquillo',
                  style: TextStyle(
                    color: Color(0xFFCDCDCD),
                    fontWeight: FontWeight.w500,
                    fontSize:responsive.ip(2.5),
                  ),),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: PageView(
              
               physics: BouncingScrollPhysics(),
              children: <Widget>[
                Walkthrough(
                  title: Flutkart.wt1,
                  content: Flutkart.wc1,
                  imgPath: 'assets/images/intro_screen/welcome.svg',
                ),
                Walkthrough(
                  title: Flutkart.wt2,
                  content: Flutkart.wc2,
                  imgPath: 'assets/images/intro_screen/search.svg',
                ),
                Walkthrough(
                  title: Flutkart.wt3,
                  content: Flutkart.wc3,
                  imgPath: 'assets/images/intro_screen/cart.svg',
                ),
                Walkthrough(
                  title: Flutkart.wt4,
                  content: Flutkart.wc4,
                  imgPath: 'assets/images/intro_screen/deliver.svg',
                ),
              ],
              controller: controller,
              onPageChanged: _onPageChanged,
            ),
          ),
          
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(lastPage ? "" : Flutkart.skip,
                      style: TextStyle(
                          color: Color(0xFFCDCDCD),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  onPressed: () =>
                      lastPage ? null : Navigator.pushReplacementNamed(context, 'login'),
                ),
                FlatButton(
                  child: Row(
                    children: <Widget>[
                      Text(lastPage ? Flutkart.gotIt : Flutkart.next,
                          style: TextStyle(
                              color: Color(0xFFCDCDCD),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      lastPage?
                       Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(LineIcons.check,color: Color(0xFFCDCDCD),size: 20,),
                      )
                      : Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(LineIcons.arrow_right,color: Color(0xFFCDCDCD),size: 20,),
                      )
                    ],
                  ),
                  onPressed: () => lastPage
                      ? Navigator.pushReplacementNamed(context, 'login')
                      : controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn),
                ),
              ],
            ),
          )
        ],
      ),
    ),
    );
  }
}