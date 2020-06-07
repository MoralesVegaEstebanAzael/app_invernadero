import 'package:app_invernadero/src/blocs/bottom_nav_bloc.dart';
import 'package:app_invernadero/src/pages/home/home_page.dart';
import 'package:app_invernadero/src/pages/notifications/notifications_page.dart';
import 'package:app_invernadero/src/pages/pedidos/pedidos_page.dart';
import 'package:app_invernadero/src/pages/user/user_favoritos_page.dart';
import 'package:app_invernadero/src/pages/user/user_profile_page.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';


class BottomNavBarApp extends StatefulWidget {
  createState() => _BottomNavBarAppState();
}

class _BottomNavBarAppState extends State<BottomNavBarApp> {
  BottomNavBloc _bottomNavBarBloc;
  Responsive _responsive;
  SecureStorage _prefs = SecureStorage();
  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBloc();
    _prefs.route = 'home';
  }

  @override
  void didChangeDependencies() {
    _responsive = Responsive.of(context);
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    _bottomNavBarBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<NavBarItem>(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
        
          switch (snapshot.data) {
            case NavBarItem.HOME:
              return HomePage();
            case NavBarItem.PEDIDOS:
              return PedidosPage();
            case NavBarItem.PROFILE:
              return UserProfilePage();
            case NavBarItem.NOTIFICACIONES:
              return NotificationsPage();
            case NavBarItem.FAVORITOS:
              return FavoritosPage();
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
                  onTap: _bottomNavBarBloc.pickItem,
                  items: [
                    BottomNavigationBarItem(
                      title: Text('Pedidos',style: TextStyle(
                      fontFamily:'Quicksand',fontSize:_responsive.ip(1),fontWeight: FontWeight.w900
                    ),),
                      icon: Icon(LineIcons.mobile_phone,),
                    ),

                    BottomNavigationBarItem(
                      title: Text('Notificaciones',style: TextStyle(
                      fontFamily:'Quicksand',fontSize:_responsive.ip(1),fontWeight: FontWeight.w900
                    ),),
                      icon: Icon(LineIcons.bell,),
                    ),


                    BottomNavigationBarItem(
                      title: Container(),
                      icon: Container(),
                    ),
                     BottomNavigationBarItem(
                     title: Text('Favoritos',style: TextStyle(
                      fontFamily:'Quicksand',fontSize:_responsive.ip(1),fontWeight: FontWeight.w900
                    ),),
                      icon: Icon(LineIcons.heart_o),
                    ),

                    BottomNavigationBarItem(
                     title: Text('Yo',style: TextStyle(
                      fontFamily:'Quicksand',fontSize:_responsive.ip(1),fontWeight: FontWeight.w900
                    ),),
                      icon: Icon(LineIcons.user),
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
            _bottomNavBarBloc.pickItem(2);
          },
          child: Icon(Icons.store),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

 
}