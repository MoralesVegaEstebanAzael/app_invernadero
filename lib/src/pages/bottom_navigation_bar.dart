import 'package:app_invernadero/src/blocs/bottom_nav_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/pages/home/home_page.dart';
import 'package:app_invernadero/src/pages/pedidos/pedidos_page.dart';
import 'package:app_invernadero/src/pages/shopping_cart_page.dart';
import 'package:app_invernadero/src/pages/user/user_profile_page.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';


class BottomNavigationMenu extends StatefulWidget {
  
  const BottomNavigationMenu({
    Key key,
  }) : super(key: key);

  @override
  // _CounterState createState() => _CounterState()

  // BottomNavigationMenu({Key key}) : super(key: key);

  @override
  BottomNavigationMenuState createState() => BottomNavigationMenuState();
}

class BottomNavigationMenuState extends State<BottomNavigationMenu> with TickerProviderStateMixin {
   TabController   tabController;
   // use this instead of DefaultTabController
  Color c1 = Colors.grey;
  Color c2 = Colors.grey;
  // static int index=0;

  // static GlobalKey<BottomNavigationMenuState> menuState = GlobalKey();
  
  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    print("Volviendo..");
    tabController = TabController(length: 3,vsync: this, );
    //menuState = GlobalKey();
    

    super.initState();
    

  }
  @override
  Widget build(BuildContext context) {
  //final child = KeyedSubtree(key: key, child: widget.child);
   return  Scaffold(
        body: TabBarView(
         // key: menuState,
          controller: tabController,
          children: [ // these are your pages 
           HomePage(),
           PedidosPage(),
           UserProfilePage()
          ],
        ),
        bottomNavigationBar: BottomAppBar(
         
          color: Colors.white,
          shape: CircularNotchedRectangle(),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                 setState(() {
                  c2 = Colors.grey;
                  c1 =Colors.green;
                 });
                  
                  tabController.animateTo(1);
                }, //
                icon: Icon(LineIcons.mobile_phone,color: c1)
              ),
              
              SizedBox(),
              IconButton(onPressed: null, // go to page 2
              icon: Container()),

               IconButton(onPressed: (){
                
                 setState(() {
                  c2 = Colors.green;
                  c1 =Colors.grey;
                 });

                  tabController.animateTo(2);
               }, // go to page 2
              icon: Icon(LineIcons.user,color: c2,))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: miTema.accentColor,
          onPressed: () {
            setState(() {
                  c2 = Colors.grey;
                  c1 =Colors.grey;
                 });

            
             tabController.animateTo(0);
          },
          child: Icon(Icons.store),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
  }


    
}
