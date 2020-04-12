
import 'package:app_invernadero/src/pages/login_page.dart';
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
      home: LoginPage(),
    );
  }
}