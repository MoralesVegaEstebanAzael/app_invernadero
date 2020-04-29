
import 'package:app_invernadero/src/pages/items/tab1.dart';
import 'package:app_invernadero/src/pages/items/tab2.dart';
import 'package:app_invernadero/src/pages/items/tab3.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:provider/provider.dart';
import '../../theme/theme.dart';
import '../home_page.dart';
import '../user/user_profile_page.dart'; 

class TabsPages extends StatelessWidget {
  const TabsPages({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => new _NavegacionModel(),
        child: Scaffold(  
        body: _Paginas(),
        floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: miTema.accentColor,
        child: Icon(LineIcons.plus),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _Navegacion(),
      ),
    );
  }
}

class _Navegacion extends StatelessWidget {   

  @override
  Widget build(BuildContext context) {
    
    final navegacionModel = Provider.of<_NavegacionModel>(context);

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: Colors.transparent,
      elevation: 9.0,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height:50.0,
        decoration: BoxDecoration(
          borderRadius:BorderRadius.only(
            topLeft:Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          color: Colors.white,
        ),
        child: ClipRRect(
          
          borderRadius: BorderRadius.only(topRight: Radius.circular(25.0), topLeft: Radius.circular(25.0)),
            child: BottomNavigationBar(
            
             currentIndex: navegacionModel.pagActual,
             onTap: (i) => navegacionModel.pagActual = i,
             type: BottomNavigationBarType.fixed, 
             iconSize: 24, 
             
              items: [
                BottomNavigationBarItem(icon: Container(padding: EdgeInsets.all(5), child: Icon(LineIcons.home)), title: Container()), 
                BottomNavigationBarItem(icon: Container(padding: EdgeInsets.only(right: 70.0), child: Icon(LineIcons.user)), title: Container()),
                BottomNavigationBarItem(icon: Container(padding: EdgeInsets.only(left: 70.0), child: Icon(LineIcons.search)), title: Container()),
                BottomNavigationBarItem(icon: Container(padding: EdgeInsets.all(5), child: Icon(LineIcons.shopping_cart),), title: Container()),
              
              ], 
             elevation: 50.0,
            selectedItemColor: Color.fromRGBO(43, 154, 101, 1),
          ),
        ),
      ), 
    );
   
  }
}

class _Paginas extends StatelessWidget { 

  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<_NavegacionModel>(context);
    return  PageView(
        controller: navegacionModel.pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          HomePage(),
          UserProfilePage(),
          Tab1(),
          Tab3()
        ], 
    );
  }
}


class _NavegacionModel with ChangeNotifier{
  int _pagActual = 0;
  PageController _pageController =  new PageController();

  //set y get de pagina actual
  int get pagActual => this._pagActual;
  
  set pagActual(int valor){
    this._pagActual = valor;
    _pageController.animateToPage(valor, duration: Duration(milliseconds: 50), curve: Curves.slowMiddle);
    notifyListeners();
  }

  PageController get pageController => this._pageController;
}


/*
 return BottomNavigationBar(
      currentIndex: navegacionModel.pagActual,
      onTap: (i) => navegacionModel.pagActual = i,
      type: BottomNavigationBarType.fixed, 
      
      items: [
        BottomNavigationBarItem(icon: Icon(LineIcons.home,color:Color(0xFF676E79)), title: Container()),
        BottomNavigationBarItem(icon: Icon(LineIcons.user,color:Color(0xFF676E79)), title: Container()),
        BottomNavigationBarItem(icon: Icon(LineIcons.search,color:Color(0xFF676E79)), title: Container()),
        BottomNavigationBarItem(icon: Icon(LineIcons.shopping_cart,color:Color(0xFF676E79)), title: Container()),
      ],
      selectedItemColor: miTema.primaryColor,
    );
 */