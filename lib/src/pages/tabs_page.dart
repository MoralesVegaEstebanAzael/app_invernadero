
import 'package:app_invernadero/src/pages/home/home_page.dart';
import 'package:app_invernadero/src/pages/products/products.dart';
import 'package:app_invernadero/src/pages/shopping_cart_page.dart';

import 'package:app_invernadero/src/pages/user/user_profile_page.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:provider/provider.dart';


class TabsPages extends StatefulWidget {
  const TabsPages({Key key}) : super(key: key);

  @override
  _TabsPagesState createState() => _TabsPagesState();
}

class _TabsPagesState extends State<TabsPages> {
  SecureStorage _prefs = SecureStorage();

  @override
  void initState() { 
    super.initState();
    _prefs.route= 'home';
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => new _NavegacionModel(),
        child: Scaffold(  
        body: _Paginas(),
        floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: miTema.accentColor,
        child: Icon(LineIcons.home,size: 30,),
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
      notchMargin:6,
      color: Colors.transparent,
      elevation: 9.0,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height:55,
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
            
             currentIndex:  navegacionModel.pagActual,
             onTap: (i) => navegacionModel.pagActual = i,
             type: BottomNavigationBarType.fixed, 
             iconSize: 24, 
             
              items: [
                BottomNavigationBarItem(
                    icon: Icon(LineIcons.home),
                    title: Text('Inicio'),
                  //icon: Container(padding: EdgeInsets.all(5), 
                  ),//child: Icon(LineIcons.home),), title: Text("data",style:TextStyle(fontSize: 6))), 
                BottomNavigationBarItem(
                    icon: Icon(LineIcons.search),
                    title: Text('Productos'),),
                 BottomNavigationBarItem(
                    icon: Container(),
                    title: Container(),),
                

                BottomNavigationBarItem(
                  icon: Icon(LineIcons.shopping_cart),
                    title: Text('Compras'),
                  //icon: Container(padding: EdgeInsets.only(left: 70.0), 
                  ),//child: Icon(LineIcons.shopping_cart)), title: Container()),
                BottomNavigationBarItem(
                  icon: Icon(LineIcons.user),
                    title: Text('Yo'),
                  )//icon: Container(padding: EdgeInsets.all(5), child: Icon(LineIcons.user),), title: Container()),
              
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
          Products(),
          ShoppingCartPage(),
          ShoppingCartPage(),
          UserProfilePage(),
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
    if(valor!=2){
      this._pagActual = valor;
      _pageController.animateToPage(valor, duration: Duration(milliseconds: 50), curve: Curves.slowMiddle);
      notifyListeners();
    }
  }

  PageController get pageController => this._pageController;
}

