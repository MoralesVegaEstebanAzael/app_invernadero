
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/pages/home/home_page.dart';
import 'package:app_invernadero/src/pages/intro_screen.dart';
import 'package:app_invernadero/src/pages/login/code_verification_page3.dart';
import 'package:app_invernadero/src/pages/login/config_account_page.dart';
import 'package:app_invernadero/src/pages/login/config_location.dart';
import 'package:app_invernadero/src/pages/login/config_password_page.dart';
import 'package:app_invernadero/src/pages/login/create_account_page.dart';
import 'package:app_invernadero/src/pages/login/login_page.dart';
import 'package:app_invernadero/src/pages/login/login_password_page.dart';
import 'package:app_invernadero/src/pages/login/login_phone_page.dart';
import 'package:app_invernadero/src/pages/login/pin_code_page.dart';
import 'package:app_invernadero/src/pages/notifications/notifications_page.dart';
import 'package:app_invernadero/src/pages/pedidos/pedido_detalle_page.dart';
import 'package:app_invernadero/src/pages/pedidos/pedidos_page.dart';
import 'package:app_invernadero/src/pages/products/product_detail_page.dart';
import 'package:app_invernadero/src/pages/shopping_cart_page.dart';
import 'package:app_invernadero/src/pages/tabs_page.dart';
import 'package:app_invernadero/src/pages/test_page.dart';
import 'package:app_invernadero/src/pages/user/address_page.dart';
import 'package:app_invernadero/src/pages/user/configuration_page.dart';

import 'package:app_invernadero/src/pages/user/user_acercade_page.dart';
import 'package:app_invernadero/src/pages/user/user_ayuda_page.dart';
import 'package:app_invernadero/src/pages/user/user_datos_update.dart';
import 'package:app_invernadero/src/pages/user/user_detalle_page.dart';
import 'package:app_invernadero/src/pages/user/user_favoritos_page.dart';
import 'package:app_invernadero/src/pages/user/user_profile_page.dart';

import 'package:app_invernadero/src/pages/checkout_page.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/push_notifications_provider.dart';
import 'package:app_invernadero/src/services/local_services.dart';
import 'package:app_invernadero/src/services/notifications_service.dart';
import 'package:app_invernadero/src/services/product_services.dart';
import 'package:app_invernadero/src/services/promocion_services.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/widgets/menu_bar.dart';
import 'package:feature_discovery/feature_discovery.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:app_invernadero/src/blocs/provider.dart' as customProvider;

void main() async{
  //var path = await getApplicationDocumentsDirectory();
  //Hive.init(path.path );
    
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new SecureStorage();
  await prefs.initPrefs();

  DBProvider db = DBProvider();
  await db.initDB();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
   systemNavigationBarColor: Colors.white, // navigation bar color
    statusBarColor: Colors.white, // status bar color
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.dark,
    
  ));

  PushNotificationsProvider provider = PushNotificationsProvider();
  provider.initNotifications();
  provider.getToken();

// SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyl e.dark);
  runApp(MyApp());
} 


class MyApp extends StatelessWidget {
  final prefs = new SecureStorage();

  
  @override
  Widget build(BuildContext context) { 
    
    return FeatureDiscovery(
          child: customProvider.Provider(
            child: MultiProvider(
          providers: [
            //ChangeNotifierProvider(create: (_)=> new LocalService()),
            ChangeNotifierProvider(create: (_)=> new PromocionService(),),
            ChangeNotifierProvider(create: (_)=> new ProductoService(),),
            ChangeNotifierProvider(create: (_)=> new NotificationService(),)
          ],
          
          child: MaterialApp(
              debugShowCheckedModeBanner: false,  
              
              title: 'App Invernadero',
              theme: miTema,
              initialRoute: prefs.route,
              routes: {
                'test'                  : (BuildContext)=>TestApp(),
                'intro'                 : (BuildContext)=>IntroScreen(),
                'home'                  : (BuildContext)=>BottomNavBarApp(),///BottomNavigationMenu(),
                'login_phone'           : (BuildContext)=>LoginPhonePage(),
                'login_password'        : (BuildContext)=>LoginPasswordPage(),
                'pin_code'              : (BuildContext)=>PinCodePage(),
                'config_password'       : (BuildContext)=>ConfigPasswordPage(),
                'config_account'        : (BuildContext)=>ConfigAccountPage(),
                'config_location'       : (BuildContext)=>ConfigLocation(),
                'user_profile'          : (BuildContext)=>UserProfilePage(),
                'login'                 : (BuildContext)=>LoginPage(),
                'create_account'        : (BuildContext)=>CreateAccountPage(), 
                'code_verification_3'   : (BuildContext)=>CodeVerificationPage3(),

                'favoritos'             : (BuildContext)=>FavoritosPage(),
                'faq'                   : (BuildContext)=>AyudaPage(), 
                'about'                 : (BuildContext)=>AcercaDePage(), 
                'user_detalle'          : (BuildContext)=>UserDetallePage(),
                'configuracion'         : (BuildContext)=>ConfigurationPage(),

                'product_detail'        : (BuildContext)=>ProductDetailPage(),
                
                'checkout'              : (BuildContext)=>CheckoutPage(),

                'notifications'         : (BuildContext)=>NotificationsPage(),


                'store'                 : (BuildContext)=>HomePage(),
                'shopping_cart'         : (BuildContext)=>ShoppingCartPage(),
                
                'pedidos'               : (BuildContext)=>PedidosPage(),
                'address'               : (BuildContext)=>AddressPage(),

                'detalleDatosUpdate'         : (BuildContext)=>DetalleDatosUpdate(),

                  'checkout'              : (BuildContext)=>CheckoutPage(),

              'notifications'         : (BuildContext)=>NotificationsPage(),


              'store'                 : (BuildContext)=>HomePage(),
              'shopping_cart'         : (BuildContext)=>ShoppingCartPage(),
              
              'pedidos'               : (BuildContext)=>PedidosPage(),
              'address'               : (BuildContext)=>AddressPage(),

              'detalleDatosUpdate'         : (BuildContext)=>DetalleDatosUpdate(),

              'pedidoDetalle'          : (BuildContext)=>PedidoDetalle()
              },
            ),
         
        ),
    ));
  }
}