import 'package:app_invernadero/src/blocs/bottom_nav_bloc.dart';
import 'package:app_invernadero/src/pages/home/home_page.dart';
import 'package:app_invernadero/src/pages/notifications/notifications_page.dart';
import 'package:app_invernadero/src/pages/pedidos/pedidos_page.dart';
import 'package:app_invernadero/src/pages/user/user_favoritos_page.dart';
import 'package:app_invernadero/src/pages/user/user_profile_page.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';


class BottomNavBarApp extends StatefulWidget {
  createState() => _BottomNavBarAppState();
}

class _BottomNavBarAppState extends State<BottomNavBarApp> with AutomaticKeepAliveClientMixin{
  BottomNavBloc _bottomNavBarBloc;
  Responsive _responsive;
  SecureStorage _prefs = SecureStorage();
  
  final _homePage = HomePage();
  final _pedidosPage = PedidosPage();
  final _userProfilePage = UserProfilePage();
  final _notificationsPage = NotificationsPage();
  final _favoritesPage = FavoritosPage();

  List<Widget> pageList = List<Widget>();



  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBloc();
    _prefs.route = 'home';

    
    pageList.add(_pedidosPage);
    pageList.add(_notificationsPage);
    pageList.add(_homePage);
    pageList.add(_favoritesPage);
    pageList.add(_userProfilePage);
  }

  @override
  void didChangeDependencies() {
    _responsive = Responsive.of(context);
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    //_bottomNavBarBloc.close();
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
            //indice=2;
            _bottomNavBarBloc.pickItem(2);
            // setState(() {
              
            // });
          },
          child: Icon(Icons.store),
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