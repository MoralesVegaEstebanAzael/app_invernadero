
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/pages/intro_screen.dart';
import 'package:app_invernadero/src/pages/login/code_verification_page3.dart';
import 'package:app_invernadero/src/pages/login/config_account_page.dart';
import 'package:app_invernadero/src/pages/login/config_password_page.dart';
import 'package:app_invernadero/src/pages/login/create_account_page.dart';
import 'package:app_invernadero/src/pages/login/login_page.dart';
import 'package:app_invernadero/src/pages/login/login_password_page.dart';
import 'package:app_invernadero/src/pages/login/login_phone_page.dart';
import 'package:app_invernadero/src/pages/login/pin_code_page.dart';
import 'package:app_invernadero/src/pages/notifications/notifications_page.dart';
import 'package:app_invernadero/src/pages/products/product_detail_page.dart';
import 'package:app_invernadero/src/pages/tabs_page.dart';
import 'package:app_invernadero/src/pages/user/user_acercade_page.dart';
import 'package:app_invernadero/src/pages/user/user_ayuda_page.dart';
import 'package:app_invernadero/src/pages/user/user_detalle_page.dart';
import 'package:app_invernadero/src/pages/user/user_favoritos_page.dart';
import 'package:app_invernadero/src/pages/user/user_profile_page.dart';

import 'package:app_invernadero/src/pages/checkout_page.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async{
  //var path = await getApplicationDocumentsDirectory();
  //Hive.init(path.path );
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new SecureStorage();
  await prefs.initPrefs();

  DBProvider db = DBProvider();
  await db.initDB();
  
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  final prefs = new SecureStorage();

  
  @override
  Widget build(BuildContext context) { 
    
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,  
      //   localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: [
      //   const Locale('en'), // English
      //   const Locale.fromSubtags(languageCode: 'zh'), // Chinese *See Advanced Locales below*
      //   const Locale('es')
      // ],
        title: 'App Invernadero',
        theme: miTema,
        initialRoute: prefs.route,
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
          'faq'                   : (BuildContext)=>AyudaPage(), 
          'about'                 : (BuildContext)=>AcercaDePage(), 
          'user_detalle'          : (BuildContext)=>UserDetallePage(),


          'product_detail'        : (BuildContext)=>ProductDetailPage(),
          
          'checkout'              : (BuildContext)=>CheckoutPage(),

          'notifications'         : (BuildContext)=>NotificationsPage(),
        },
      ),
    );
  }
}