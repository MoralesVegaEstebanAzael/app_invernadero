
import 'package:app_invernadero/src/blocs/producto_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/planta_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/models/shopping_cart_model.dart';
import 'package:app_invernadero/src/pages/products/tab2.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> with SingleTickerProviderStateMixin {
  DBProvider _dbProvider;
  ProductoBloc _productoBloc;
  TabController _tabController;
  PageController _pageController;
  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();
    _dbProvider = DBProvider();
    _tabController = TabController(initialIndex: 0, length: 5, vsync: this);
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_productoBloc == null) { 
      _productoBloc = Provider.productoBloc(context);
      _productoBloc.cargarProductos();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: PreferredSize(
        child: MyAppBar(title: "PRODUCTOS"),
        preferredSize: Size.fromHeight(80),
      ),
      body: ListView(
       
        children: <Widget>[
          _tabBar(),
          _pageView(),
        ],
      )
    );
  }

  


  Widget _tabBar(){
    return TabBar(
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
    );
  }

  Widget _pageView() {
    return StreamBuilder(
      stream: _productoBloc.productoStream,
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
                  onPressed: () => addShoppingCart(data),
                )
              )
            ],
      ), 
       ),
    );

  }


  addShoppingCart(ProductoModel p){

    ShoppingCartModel shoppingCartModel = 
    ShoppingCartModel(
      productoId: p.id,
      nombre: p.nombre,
      contCaja:p.contCaja,
      precioMayoreo:p.precioMayoreo,
      precioMenudeo:p.precioMenudeo,
      cantidad:1,
      imagenUrl:p.urlImagen);
    _dbProvider.insert(shoppingCartModel);
  }

  Widget _description(){
    return Padding(padding: EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Descripción', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
          SizedBox(height: 10.0,),
          Text(plants[_selectedPage].description, style: TextStyle(color: Colors.black87, fontSize: 16.0),)
        ],
      ),
    );
  }
}