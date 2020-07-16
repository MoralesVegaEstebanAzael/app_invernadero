import 'package:app_invernadero/src/blocs/bottom_nav_bloc.dart';
import 'package:app_invernadero/src/blocs/notification_bloc.dart';
import 'package:app_invernadero/src/models/notification_model.dart';
import 'package:app_invernadero/src/pages/home/home_page.dart';
import 'package:app_invernadero/src/pages/notifications/notifications_page.dart';
import 'package:app_invernadero/src/pages/pedidos/pedidos_page.dart';
import 'package:app_invernadero/src/pages/user/profile_page.dart';
import 'package:app_invernadero/src/pages/user/user_favoritos_page.dart';
import 'package:app_invernadero/src/pages/user/user_profile_page.dart';
import 'package:app_invernadero/src/services/notifications_service.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/badge_bottom_icon.dart';
import 'package:app_invernadero/src/widgets/badge_icon.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';


class BottomNavBarApp extends StatefulWidget {
  createState() => _BottomNavBarAppState();
}

class _BottomNavBarAppState extends State<BottomNavBarApp> with AutomaticKeepAliveClientMixin{
  BottomNavBloc _bottomNavBarBloc;
  Responsive _responsive;
  SecureStorage _prefs = SecureStorage();
  NotificacionesBloc _notificacionesBloc = NotificacionesBloc();

  final _homePage = HomePage();
  final _pedidosPage = PedidosPage();
  final _userProfilePage = ProfilePage();// UserProfilePage();
  final _notificationsPage = NotificationsPage();
  final _favoritesPage = FavoritosPage();

  List<Widget> pageList = List<Widget>();

  TextStyle _titleStyle = TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w600);
  TextStyle _subtitleStyle =  TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w700);

  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBloc();
    _prefs.route = 'home';

    
    // pageList.add(_pedidosPage);
    // pageList.add(_notificationsPage);
    // pageList.add(_homePage);
    // pageList.add(_favoritesPage);
    // pageList.add(_userProfilePage);

    
    
  SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
    FeatureDiscovery.discoverFeatures(
      context,
      const <String>{ // Feature ids for every feature that you want to showcase in order.
        'pedidos_feature_id',
        'notificaciones_feature_id',
        'favoritos_feature_id',
        'user_feature_id',
        'home_feature_id',
        'shopping_cart_feature_id',
      },
    ); 
  });

  }
  
  

  @override
  void didChangeDependencies() {
    _responsive = Responsive.of(context);
    Provider.of<NotificationService>(context);
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    _bottomNavBarBloc.dispose();
    super.dispose();
  }

 
  int indice;
 
  @override
  Widget build(BuildContext context) {

   
    
    
    return Scaffold(
        backgroundColor: Colors.white,
        // body: IndexedStack(
        //   children: pageList,
        //   index: _bottomNavBarBloc.index(),   
        // ),
        
        body: StreamBuilder<NavBarItem>(
      stream: _bottomNavBarBloc.itemStream,
      initialData: _bottomNavBarBloc.defaultItem,
      builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
      
        switch (snapshot.data) {
          case NavBarItem.HOME:
            return _homePage;
          case NavBarItem.PEDIDOS:
            return _pedidosPage;
          case NavBarItem.PROFILE:
            return _userProfilePage;
          case NavBarItem.NOTIFICACIONES:
            return _notificationsPage;
          case NavBarItem.FAVORITOS:
            return _favoritesPage;
        }
      },
    ),
        bottomNavigationBar: BottomAppBar(
    shape: CircularNotchedRectangle(),
    notchMargin:10,
    color: Colors.transparent,
    elevation: 10.0,
    clipBehavior: Clip.antiAlias,
    child: Container(
      height:_responsive.ip(7),
      decoration: BoxDecoration(
      borderRadius:BorderRadius.only(
      topLeft:Radius.circular(25.0),
      topRight: Radius.circular(25.0),
      ),
      color: Colors.white,
    ),
            child: ClipRRect(
               borderRadius: BorderRadius.only(topRight: Radius.circular(25.0), topLeft: Radius.circular(25.0)),
                              child: StreamBuilder(
      stream: _bottomNavBarBloc.itemStream,
      initialData: _bottomNavBarBloc.defaultItem,
      builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
        
        return BottomNavigationBar(
              fixedColor: miTema.accentColor,
              unselectedItemColor: Colors.grey,
              currentIndex: snapshot.data.index,
              onTap: _bottomNavBarBloc.pickItem,//_onTap,
              items: [
                BottomNavigationBarItem(
                  title: Text('Pedidos',style: TextStyle(
                  fontFamily:'Quicksand',fontSize:_responsive.ip(1),fontWeight: FontWeight.w900
                ),),

                  icon: DescribedFeatureOverlay(
                    featureId: 'pedidos_feature_id', // Unique id that identifies this overlay.
                    tapTarget: const Icon(LineIcons.mobile_phone), // The widget that will be displayed as the tap target.
                    title: Text('Pedidos',style: _titleStyle),
                    description: Text('Toca el icono para ver tus pedidos.',
                      style: _subtitleStyle
                    ),
                    backgroundColor: MyColors.YellowDiscovery,// Theme.of(context).primaryColor,
                  
                    targetColor:Colors.white,
                    
                    textColor: Colors.grey[800],
                    child: Icon(LineIcons.mobile_phone)
                  ),
                  // icon: Icon(LineIcons.mobile_phone,),

                
                ),

                BottomNavigationBarItem(
                  title: Text('Notificaciones',style: TextStyle(
                  fontFamily:'Quicksand',fontSize:_responsive.ip(1),fontWeight: FontWeight.w900
                ),),
                  icon: StreamBuilder(
                    stream: _notificacionesBloc.unreadNotificationsStream ,
                    builder: (BuildContext context, AsyncSnapshot<List<NotificacionModel>> snapshot){
                      if(snapshot.data!=null){
                        return  BadgeBottomIcon(
                          icon:Icon(LineIcons.bell),
                          number:snapshot.data.length,
                        );
                      }
                      return   DescribedFeatureOverlay(
                    featureId: 'notificaciones_feature_id', // Unique id that identifies this overlay.
                    tapTarget: const Icon(LineIcons.bell), // The widget that will be displayed as the tap target.
                    title: Text('Notificaciones',style: _titleStyle),
                    description: Text('Toca el icono para ver tus notificaciones.',
                      style: _subtitleStyle
                    ),
                    backgroundColor: MyColors.YellowDiscovery,// Theme.of(context).primaryColor,
                  
                    targetColor:Colors.white,
                    
                    textColor: Colors.grey[800],
                    child: Icon(LineIcons.bell)
                  );
                    },
                  ),//Icon(LineIcons.bell,),
                ),


                BottomNavigationBarItem(
                  title: Container(),
                  icon: Container(),
                ),
                 BottomNavigationBarItem(
                 title: Text('Favoritos',style: TextStyle(
                  fontFamily:'Quicksand',fontSize:_responsive.ip(1),fontWeight: FontWeight.w900
                ),),
                  icon: DescribedFeatureOverlay(
                    featureId: 'favoritos_feature_id', // Unique id that identifies this overlay.
                    tapTarget: const Icon(LineIcons.heart_o), // The widget that will be displayed as the tap target.
                    title: Text('Favoritos',style: _titleStyle),
                    description: Text('Agrega productos a tu lista de favoritos.',
                      style: _subtitleStyle
                    ),
                    backgroundColor: MyColors.YellowDiscovery,// Theme.of(context).primaryColor,
                  
                    targetColor:Colors.white,
                    
                    textColor: Colors.grey[800],
                    child: Icon(LineIcons.heart_o)
                  ),
                ),

                BottomNavigationBarItem(
                 title: Text('Yo',style: TextStyle(
                  fontFamily:'Quicksand',fontSize:_responsive.ip(1),fontWeight: FontWeight.w900
                ),),
                  icon: DescribedFeatureOverlay(
                    featureId: 'user_feature_id', // Unique id that identifies this overlay.
                    tapTarget: const Icon(LineIcons.user), // The widget that will be displayed as the tap target.
                    title: Text('Cuenta',style: _titleStyle),
                    description: Text('Configura tu cuenta.',
                      style: _subtitleStyle
                    ),
                    backgroundColor: MyColors.YellowDiscovery,// Theme.of(context).primaryColor,
                  
                    targetColor:Colors.white,
                    
                    textColor: Colors.grey[800],
                    child: Icon(LineIcons.user)
                  ),
                ),
              ],
        );

      },
    ),
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton(
      backgroundColor: miTema.accentColor,
      onPressed: () {
        //indice=2;
        _bottomNavBarBloc.pickItem(2);
        // setState(() {
          
        // });
      },
      child: DescribedFeatureOverlay(
                    featureId: 'home_feature_id', // Unique id that identifies this overlay.
                    tapTarget: const Icon(Icons.store), // The widget that will be displayed as the tap target.
                    title: Text('Inicio',style: _titleStyle),
                    description: Text('Descubre productos.',
                      style: _subtitleStyle
                    ),
                    backgroundColor: MyColors.YellowDiscovery,// Theme.of(context).primaryColor,
                  
                    targetColor:Colors.white,

                    textColor: Colors.grey[800],
                    child: Icon(Icons.store)
                  )
      
      // Icon(Icons.store),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _onTap(int i){

    _bottomNavBarBloc.pickItem(i);
    setState(() {
      
    });
  }
}


/**
 * StreamBuilder<NavBarItem>(
          stream: _bottomNavBarBloc.itemStream,
          initialData: _bottomNavBarBloc.defaultItem,
          builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          
            switch (snapshot.data) {
              case NavBarItem.HOME:
                return _homePage;
              case NavBarItem.PEDIDOS:
                return _pedidosPage;
              case NavBarItem.PROFILE:
                return _userProfilePage;
              case NavBarItem.NOTIFICACIONES:
                return _notificationsPage;
              case NavBarItem.FAVORITOS:
                return _favoritesPage;
            }
          },
        ),
 * 
 */