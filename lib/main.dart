import 'package:app_invernadero/pages/login_page.dart';
import 'package:flutter/material.dart';
 
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Invernadero',
      home: LoginPage(),
      theme: ThemeData(
        primaryColor: Colors.green
      ),
    );
  }
}