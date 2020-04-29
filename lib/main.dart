
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/pages/home_page.dart';
import 'package:app_invernadero/src/pages/intro_screen.dart';
import 'package:app_invernadero/src/pages/login/code_verification_page3.dart';
import 'package:app_invernadero/src/pages/login/config_account_page.dart';
import 'package:app_invernadero/src/pages/login/config_password_page.dart';
import 'package:app_invernadero/src/pages/login/create_account_page.dart';
import 'package:app_invernadero/src/pages/login/login_page.dart';
import 'package:app_invernadero/src/pages/login/login_password_page.dart';
import 'package:app_invernadero/src/pages/login/login_phone_page.dart';
import 'package:app_invernadero/src/pages/login/pin_code_page.dart';
import 'package:app_invernadero/src/pages/user/user_profile_page.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new SecureStorage();
  await prefs.initPrefs();
  
  
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  final prefs = new SecureStorage();


  @override
  Widget build(BuildContext context) { 
    
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App Invernadero',
        theme: miTema,
        initialRoute: 'config_account',//prefs.sesion?'user_profile':'login_phone',

        routes: {
          'login'                 : (BuildContext)=>LoginPage(),
          'create_account'        : (BuildContext)=>CreateAccountPage(), 
          'intro'                 : (BuildContext)=>IntroScreen(),
          'home'                  : (BuildContext)=>HomePage(),
          'login_phone'           : (BuildContext)=>LoginPhonePage(),
          'pin_code'              : (BuildContext)=>PinCodePage(),
          'code_verification_3'   : (BuildContext)=>CodeVerificationPage3(),
          'config_password'       : (BuildContext)=>ConfigPasswordPage(),
          'config_account'        : (BuildContext)=>ConfigAccountPage(),
          'user_profile'          : (BuildContext)=>UserProfilePage(),
          'login_password'        : (BuildContext)=>LoginPasswordPage(),
        },
      ),
    );
  }
}