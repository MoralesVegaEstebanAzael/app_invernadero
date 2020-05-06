
import 'package:app_invernadero/src/blocs/producto_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/planta_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/pages/products/tab2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 

class Tab1 extends StatefulWidget {
  @override
  _Tab1State createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> with SingleTickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;
  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 5, vsync: this);
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }
  
  _plantSelector(int index){
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget){
        double value = 1;
        if(_pageController.position.haveDimensions){
          value = _pageController.page - index;
          value = (1 - (value.abs()*0.3)).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 500.0,
            width: Curves.easeInOut.transform(value) * 400.0,
            child: widget,
          ),
        );
      },                  
       child: GestureDetector(
        onTap: (){
          Navigator.push(context, 
            MaterialPageRoute(builder: (_) => Tab2(plant: plants[index])
           )
          );
        }, 
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF32A060),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 30.0),
                  child: Stack( children: <Widget>[
                    Center(child: Hero(
                      
                      tag: plants[index].imageUrl,
                      child: Image(
                        height: 250.0, 
                        width: 250.0, 
                        image: AssetImage('assets/images/plant$index.png')),
                    ),
                   ),
                   Positioned(
                     top: 30.0, 
                     right: 30.0,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                         Text('FROM', style: TextStyle(color: Colors.white, fontSize: 15),),
                         Text('\$${plants[index].price}', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600))               
                       ],
                     ),
                    ),
                    Positioned(
                      left: 30.0,
                      bottom: 40.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(plants[index].category.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 15),),
                          SizedBox(height: 5.0),
                          Text(plants[index].name, style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600)),                 
                        ],
                      )
                    ),
                  ],
                  ),
                ),
              Positioned(
                bottom: 4.0,
                child: RawMaterialButton(
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.black,
                  child: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () => print('Agregar al carrito'),
                )
              )
            ],
      ), 
       ),
    );

  }


  @override
  Widget build(BuildContext context) {
    ProductoBloc productBloc = Provider.productoBloc(context);
    productBloc.cargarProductos();


    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[ 
                  Icon(
                    Icons.shopping_cart,
                    size: 25.0,
                    color: Colors.black,
                  )
                ],
              ),
            ), 
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Productos',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
              ),
            ), 
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey.withOpacity(0.6),
              labelPadding: EdgeInsets.symmetric(horizontal: 35.0),
              isScrollable: true,
              tabs: <Widget>[
                Tab(
                  child: Text('Top', 
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                ),
                Tab(
                  child: Text('Macetas', 
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                ),
                Tab(
                  child: Text('Frutales', 
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                ),
                Tab(
                  child: Text('Sucuelentas', 
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                ),
                Tab(
                  child: Text('Captus', 
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                ),
              ],
            ), 

          StreamBuilder(
      stream: productBloc.productoStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
         if(snapshot.hasData){

          return  AspectRatio(
            aspectRatio: 16/15,
            child: LayoutBuilder(
              builder:(_,contraints){
              return Container(
              height: contraints.maxHeight*.4,
              width: contraints.maxWidth,
              child: PageView.builder(controller: _pageController,
              onPageChanged: (int index){
                setState(() {
                  _selectedPage = index;
                });
              },
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                return _item(snapshot.data[index],index);
              },
             ),
            );
        }
      )
    ); 
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ),
           /* AspectRatio(
            aspectRatio: 16/15,
            child: LayoutBuilder(
              builder:(_,contraints){
              return Container(
              height: contraints.maxHeight*.4,
              width: contraints.maxWidth,
              child: PageView.builder(controller: _pageController,
              onPageChanged: (int index){
                setState(() {
                  _selectedPage = index;
                });
              },
              itemCount: plants.length,
              itemBuilder: (BuildContext context, int index){
                return _plantSelector(index);
              },
             ),
            );
        }
      )
    ),*/    
    
           
            Padding(padding: EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Descripción', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
                  SizedBox(height: 10.0,),
                  Text(plants[_selectedPage].description, style: TextStyle(color: Colors.black87, fontSize: 16.0),)
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _item(ProductoModel data,int i) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget){
        double value = 1;
        if(_pageController.position.haveDimensions){
          value = _pageController.page - i;
          value = (1 - (value.abs()*0.3)).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 500.0,
            width: Curves.easeInOut.transform(value) * 400.0,
            child: widget,
          ),
        );
      },                  
       child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, 'product_detail',arguments: data);
        }, 
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF32A060),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 30.0),
                  child: Stack( children: <Widget>[
                    Center(child: Hero(
                      
                      tag: data.urlImagen,
                      child:Image.network(data.urlImagen, fit: BoxFit.cover, height: 150,),
                    ),
                   ),
                   Positioned(
                     top: 30.0, 
                     right: 30.0,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                         Text('FROM', style: TextStyle(color: Colors.white, fontSize: 15),),
                         Text('\$${data.precioMenudeo}', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600))               
                       ],
                     ),
                    ),
                    Positioned(
                      left: 30.0,
                      bottom: 40.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(data.nombre.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 15),),
                          SizedBox(height: 5.0),
                          Text(data.nombre, style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600)),                 
                        ],
                      )
                    ),
                  ],
                  ),
                ),
              Positioned(
                bottom: 4.0,
                child: RawMaterialButton(
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.black,
                  child: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () => print('Agregar al carrito'),
                )
              )
            ],
      ), 
       ),
    );

  }
}