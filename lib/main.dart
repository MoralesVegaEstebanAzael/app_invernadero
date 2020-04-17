
import 'package:app_invernadero/src/pages/create_account_page.dart';
import 'package:app_invernadero/src/pages/home_page.dart';
import 'package:app_invernadero/src/pages/intro_screen.dart';
import 'package:app_invernadero/src/pages/login_page.dart';
import 'package:app_invernadero/src/pages/splash_screen_page.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:flutter/material.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Invernadero',
      theme: miTema,
      initialRoute: 'intro',
      routes: {
        'splash_screen'   : (BuildContext)=>SignInOne(),
        'login'           : (BuildContext)=>LoginPage(),
        'create_account'  : (BuildContext)=>CreateAccountPage(), 
        'intro'           : (BuildContext)=>IntroScreen(),
        'home'            : (BuildContext)=>HomePage(),
      },
    );
  }
}