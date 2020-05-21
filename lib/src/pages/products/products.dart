
import 'package:app_invernadero/src/blocs/producto_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/planta_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/models/promocion_model.dart';
import 'package:app_invernadero/src/models/shopping_cart_model.dart';
import 'package:app_invernadero/src/pages/products/tab2.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/search/search_delegate.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/app_bar.dart';
import 'package:app_invernadero/src/widgets/network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;

import '../../../app_config.dart'; 

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> with SingleTickerProviderStateMixin {
  DBProvider _dbProvider;
  ProductoBloc _productoBloc;
  Responsive responsive;
  TabController _tabController;
  PageController _pageController;
  int _selectedPage = 0;
  

   AnimationController animationController;
   Animation<dynamic> animation;


  var _alignment = Alignment.bottomCenter;
  int currentState = 0;

  @override
  void initState() {
    super.initState();
    _dbProvider = DBProvider();
    _tabController = TabController(initialIndex: 0, length: 5, vsync: this);
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);


    //


    //  animationController = AnimationController(duration: Duration(milliseconds: 500),vsync: this);
    // animation = Tween(begin: 0,end: 60).animate(animationController)..addListener((){
    //   setState(() {
        
    //   });
    // });
   
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_productoBloc == null) { 
      _productoBloc = Provider.productoBloc(context);
      _productoBloc.cargarProductos();
    }

    responsive = Responsive.of(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       appBar:_appBar(),
      body: ListView(
        children: <Widget>[
         // _tabBar(),
        
          _pageView(),
        ],
      )
    );
  
   // return _animated();
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
          aspectRatio: 16/18,
          child:
             PageView.builder(controller: _pageController,
             onPageChanged: (int index){
               setState(() {
                 _selectedPage = index;
               });
             },
             itemCount: snapshot.data.length,
             itemBuilder: (BuildContext context, int index){
               return _item(snapshot.data[index],index);
             },
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
    return GestureDetector(
     onTap: (){
       Navigator.pushNamed(context, 'product_detail',arguments: data);
     }, 
       child: Stack(
        //alignment: Alignment.center,
        children: <Widget>[
          Container( 
            //width: 150,
            width: responsive.ip(36),
            margin: EdgeInsets.fromLTRB(0, 0.0,15, 0), 
            //padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
      // Box decoration takes a gradient
      gradient: LinearGradient(
        // Where the linear gradient begins and ends
        begin: Alignment.bottomLeft,
        end: Alignment(0.1, 0),
        tileMode: TileMode.repeated, // repeats the gradient over the canvas
        colors: [
          // Colors are easy thanks to Flutter's Colors class.

          Colors.greenAccent,
          miTema.accentColor,
        ],
      ),

    ),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(20),
            //   gradient: LinearGradient(
            //   begin: Alignment.topRight,
            //   end: Alignment.bottomLeft ,
            //   colors: [miTema.primaryColor, miTema.accentColor])
            // ),
           
           // margin: EdgeInsets.fromLTRB(0, 0.0, 0, 0), 
            
          //  child: Row(
          //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //    children:<Widget>[
          //      Container(
          //       width: responsive.ip(18),
          //        decoration: BoxDecoration(
          //     //color: Color(0xFF32A060),
          //     color:miTema.primaryColor,
          //     borderRadius: BorderRadius.only(
          //       topLeft:Radius.circular(20),
          //       bottomLeft:Radius.circular(20)
          //     ),
              
          //   ),
          //       ),
          //         Container(
          //           width: responsive.ip(19),
          //           decoration: BoxDecoration(
          //     //color: Color(0xFF32A060),
          //     color:miTema.accentColor,
          //     borderRadius: BorderRadius.only(
          //       bottomRight: Radius.circular(20),
          //       topRight:Radius.circular(20)),
              
          //   ),
          //       )
          //    ]
          //  ),
          ),
          // Positioned(
          //   child: SvgPicture.asset('assets/images/back2.svg',         
          //   ),
          // ),

          Positioned(
          top: responsive.ip(6),
          left:responsive.ip(5),
          child: SizedBox(
            child:Hero(
              tag: data.id,
              child: 
           
             FadeInImage(
                width: responsive.ip(25),
                image: NetworkImage(data.urlImagen) , 
                placeholder: AssetImage('assets/placeholder.png'),)
              // :
              // Image(image: AssetImage('assets/placeholder.png'),height: responsive.ip(20)),
            ),
          ),
        ),
       
        _description(data),

       


          
         ],
      ), 
    );

  }

  
   _description(ProductoModel data){

    _productoBloc.favorite(data.id);

    // return StreamBuilder(
    //   stream:  _productoBloc.isFavorite ,
      
    //   builder: (BuildContext context, AsyncSnapshot snapshot){
    //     return Container(
    //       child: Text(snapshot.data),
    //     );
    //   },
    // );
    
    return  Positioned(
      bottom: 10,
      left: 0,
      width: responsive.ip(34),
      child: Container(
        margin: EdgeInsets.only(left:responsive.ip(1)),
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(15.0),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:<Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            Text(data.nombre,style: TextStyle(color:Colors.white,fontFamily: 'Quicksand',fontWeight: FontWeight.w900,fontSize: responsive.ip(2.2)),),
            _buttonFav(data.id)
            // IconButton(
            //   icon: Icon(
            //     Icons.favorite_border,
            //     color: Colors.white,), 
            //     onPressed: ()=>print("add favorite"))
          ],),
          Text(
          "Especificaciones: ${data.contCaja} ${AppConfig.uni_medida}" ,
            style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w700,color:Colors.white),
          ),
          SizedBox(height:responsive.ip(.5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:<Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:<Widget>[
                    Text("\$ ${data.precioMayoreo} MX",
                      style: TextStyle(
                        fontSize:15,fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w900,color: Colors.white,),),
                    Text("\$ ${data.precioMenudeo} MX",style: TextStyle(
                      fontSize:15,fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w900,color: Colors.white,),),
                    ]
              ),
              Column(
              children:<Widget>[
                Text("Mayoreo",
                  style: TextStyle(
                    fontFamily:'Quicksand',
                    fontWeight: FontWeight.w700,
                    color:Colors.white),),
                SizedBox(height:responsive.ip(0.5)),
                  Text("Menudeo",
                    style: TextStyle(
                      fontFamily:'Quicksand',
                      fontWeight: FontWeight.w700,
                      color:Colors.white),),
              ]
            ),
            Column(
            children: <Widget>[
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                padding: EdgeInsets.symmetric(horizontal:responsive.ip(2),vertical:8),
                decoration: BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(
                          color:Colors.black26,
                          blurRadius: 5
                  )]
                ),
                child://_button()
                  Icon(LineIcons.shopping_cart,color:miTema.accentColor),//Text("Agregar",style: TextStyle(fontFamily: 'Quiksand',color:Colors.white,letterSpacing: 1,fontSize: 15),),
                ),
                onPressed: ()=>addShoppingCart(data)),
                      ],
                    ),     
                  ]
                  ),
                  
          SizedBox(height:responsive.ip(1)),
              ]
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

    Flushbar(
      message:   "Se ha añadido al carrito.",
      duration:  Duration(seconds:1),              
    )..show(context);
  
  }
  
 
   Widget _appBar(){
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      title: Text("Productos",
        style:TextStyle(
          fontFamily: 'Varela',fontSize:responsive.ip(2.5),color:Color(0xFF545D68)
        ) ,
      ),
    //  leading:  IconButton(
    //     icon: Icon(LineIcons.search,color:Color(0xFF545D68),), 
    //     onPressed: (){
    //      // Navigator.pushNamed(context, 'notifications');
    //      showSearch(
    //        context: context, delegate: DataSearch());
    //     }),
      actions: <Widget>[
        Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black12,
          shape: BoxShape.circle,
        
        ),
        child:  IconButton(
        icon: Icon(LineIcons.search,color:Color(0xFF545D68),), 
        onPressed: (){
         // Navigator.pushNamed(context, 'notifications');
         showSearch(
           context: context, delegate: DataSearch());
        }),
        ),

         Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black12,
          shape: BoxShape.circle,
        
        ),
        child:  IconButton(
        icon: Icon(LineIcons.bell,color:Color(0xFF545D68),), 
        onPressed: (){
            Navigator.pushNamed(context, 'notifications');
        }),
        ),
       
      ],
    );
  }

  _buttonFav(int id){
    return  LikeButton(
        isLiked: _productoBloc.fav(id),
        size: 30,
        circleColor:
        CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
        bubblesColor: BubblesColor(
          dotPrimaryColor: Colors.red,
          dotSecondaryColor: Colors.redAccent,
        ),
        likeBuilder: (bool isLiked) {
          return Icon(
            isLiked? Icons.favorite:Icons.favorite_border,
            color: Colors.white,
            size: 25,
          );
        },
          onTap: (bool isLiked) {
        return _like (isLiked,id);
        },
        // onTap: onLikeButtonTapped,
      );
  }
  Future<bool> _like (isLiked,id) async {
    print(isLiked);
    print("id set$id");
    if(isLiked){
      _productoBloc.deleteFavorite(id);
    }else{
      _productoBloc.addFavorite(id);
    }
    return !isLiked;
  }

}