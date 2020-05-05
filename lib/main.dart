
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/pages/intro_screen.dart';
import 'package:app_invernadero/src/pages/items/tabs_page.dart';
import 'package:app_invernadero/src/pages/login/code_verification_page3.dart';
import 'package:app_invernadero/src/pages/login/config_account_page.dart';
import 'package:app_invernadero/src/pages/login/config_password_page.dart';
import 'package:app_invernadero/src/pages/login/create_account_page.dart';
import 'package:app_invernadero/src/pages/login/login_page.dart';
import 'package:app_invernadero/src/pages/login/login_password_page.dart';
import 'package:app_invernadero/src/pages/login/login_phone_page.dart';
import 'package:app_invernadero/src/pages/login/pin_code_page.dart';
import 'package:app_invernadero/src/pages/user/user_acercade_page.dart';
import 'package:app_invernadero/src/pages/user/user_ayuda_page.dart';
import 'package:app_invernadero/src/pages/user/user_favoritos_page.dart';
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
        initialRoute:prefs.route,
        routes: {
          'intro'                 : (BuildContext)=>IntroScreen(),
          'home'                  : (BuildContext)=>TabsPages(),
          'login_phone'           : (BuildContext)=>LoginPhonePage(),
          'login_password'        : (BuildContext)=>LoginPasswordPage(),
          'pin_code'              : (BuildContext)=>PinCodePage(),
          'config_password'       : (BuildContext)=>ConfigPasswordPage(),
          'config_account'        : (BuildContext)=>ConfigAccountPage(),
          'user_profile'          : (BuildContext)=>UserProfilePage(),
          'login'                 : (BuildContext)=>LoginPage(),
          'create_account'        : (BuildContext)=>CreateAccountPage(), 
          'code_verification_3'   : (BuildContext)=>CodeVerificationPage3(),

          'favoritos'             : (BuildContext)=>FavoritosPage(),
          'faq'                 : (BuildContext)=>AyudaPage(), 
          'about'              : (BuildContext)=>AcercaDePage(),   

        },
      ),
    );
  }
}