import 'package:app_invernadero/src/pages/item_page.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  
  @override
  void initState() { 
    super.initState();
    _tabController = TabController(length: 3, vsync: this);  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: ListView(
        padding: EdgeInsets.only(left:20.0),
        children: <Widget>[
          SizedBox(height:15.0),
          Text('Categorias',
                style:TextStyle(
                  fontFamily:'Varela',
                  fontSize: 42.0,
                  fontWeight: FontWeight.bold
                )
          ),
          SizedBox(height:15.0),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.transparent,
            labelColor: miTema.accentColor,
            isScrollable: true,
            labelPadding: EdgeInsets.only(right:45.0),
            unselectedLabelColor: Color(0xFFCDCDCD) ,
            tabs: <Widget>[
              Tab(
                child:Text('Tomate',
                  style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 21.0
                  ),),
              ),
              Tab(
                child:Text('Miltomate',
                  style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 21.0
                  ),),
              ),
              Tab(
                child:Text('Calabaza',
                  style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 21.0
                  ),),
              )
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height -30.0,
            width: double.infinity,
            child: TabBarView(
              controller: _tabController,
              children:[
                ItemPage(),
                ItemPage(),
                ItemPage()
              ] ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: miTema.accentColor,
        child: Icon(LineIcons.plus),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomBar(),
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(                          
        icon: Icon(LineIcons.arrow_left,color: Color(0xFF545D68),), 
        onPressed: (){}),
        title: Text('Inicio',
          style:TextStyle(
            fontFamily: 'Varela',fontSize:20.0,color:Color(0xFF545D68)
          ) ,
        ),
        actions: <Widget>[
          IconButton(
          icon: Icon(LineIcons.bell,color:Color(0xFF545D68),), 
          onPressed: (){}),
        ],
    );
  }
}