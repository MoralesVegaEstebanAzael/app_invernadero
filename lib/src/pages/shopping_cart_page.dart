import 'package:app_invernadero/src/blocs/bottom_nav_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/blocs/shopping_cart_bloc.dart';
import 'package:app_invernadero/src/models/item_shopping_cart_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:app_invernadero/src/widgets/place_holder.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:line_icons/line_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ShoppingCartPage extends StatefulWidget { 


  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  Responsive responsive;
  ShoppingCartBloc _shoppingCartBloc;
  Stream<List<ItemShoppingCartModel>> _streamItems;

  BottomNavBloc _bottomNavBloc;

  Box box ;
  bool flagFrom;

  //*** */
   final TextEditingController _filter = new TextEditingController();

  String _searchText = "";
  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(LineIcons.search,color: Colors.grey,);
  Widget _appBarTitle = new Text( 'Carrito de compras',style: TextStyle(color:Colors.grey), );

  Widget leading;
  ///
  @override
  void initState() { 
    _bottomNavBloc = BottomNavBloc();
   
    super.initState();
  }

  @override
  void dispose() {
    _shoppingCartBloc.dispose();
    if(flagFrom)
     FlutterStatusbarcolor.setStatusBarColor(miTema.accentColor);
    super.dispose();
  }
  
  @override
  void didChangeDependencies() {
    _shoppingCartBloc = Provider.shoppingCartBloc(context);
    _shoppingCartBloc.loadItems();

    //news methods 
    _shoppingCartBloc.cargarArtic();
    _streamItems = _shoppingCartBloc.artcStream;

    this.leading = IconButton(
        icon: Icon(LineIcons.angle_left,color: Colors.grey,), onPressed: ()=>Navigator.pop(context));
    ///
    responsive = Responsive.of(context);

    flagFrom =   ModalRoute.of(context).settings.arguments;
    
    if(flagFrom==null)
      flagFrom=false;
     if(flagFrom)
      FlutterStatusbarcolor.setStatusBarColor(Colors.white);
   
    
  }
 
   Widget _buildBar(BuildContext context) {
    return new AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      title: _appBarTitle,
      // leading: new IconButton(
      //   icon: _searchIcon,
      //   onPressed: _searchPressed,

      // ),
      leading: IconButton(
        icon: Icon(LineIcons.angle_left,color: Colors.grey,), onPressed: ()=>Navigator.pop(context)),
      actions: <Widget>[
        // IconAction(
        //   icon: LineIcons.search,
        //   onPressed: _searchPressed,
        // ),
        IconButton(icon: _searchIcon , onPressed: _searchPressed),
        IconAction(
          icon:LineIcons.trash,
          onPressed:(){
            setState(() {
              _shoppingCartBloc.deleteAllSC();
            });
          },
        )
      ],
    );
  }
 
 void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == LineIcons.search) {
        this._searchIcon = new Icon(LineIcons.times_circle,color: Colors.grey,);
        this._appBarTitle = new TextField(
          controller: _filter,
          onChanged: (f)=>_shoppingCartBloc.filter(f),
          decoration: new InputDecoration(
            hintText: 'Buscar...',
            focusedBorder:  UnderlineInputBorder(      
              borderSide: BorderSide(color:Color(0xffdddddd))),
            enabledBorder: UnderlineInputBorder(      
                          borderSide: BorderSide(color:Color(0xffdddddd)),),
          ),
        );
      } else {
        this._searchIcon = new Icon(LineIcons.search,color: Colors.grey,);
        this._appBarTitle = new Text( 'Carrito de compras',style: TextStyle(color:Colors.grey), );
       // filteredNames = names;
        _filter.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //_shoppingCartBloc.db.filterSC();
    return Scaffold(
      appBar: _buildBar(context),
      body: _shoppingCartBloc.isEmpty()? 
        PlaceHolder( 
        img: 'assets/images/empty_states/empty_cart.svg',
        title: 'No tienes productos',):
        _cuerpo()
    );
  } 

  _title(){
    return  Text( 
      "Mis productos (${box.length})",
      style: TextStyle(
        fontSize: responsive.ip(2),
        color:Colors.grey,
        fontFamily:'Quicksand',
        fontWeight: FontWeight.w900
      ),
    );
  }

  Widget _cuerpo(){
    return Container(
      width: responsive.widht,
      height: responsive.height,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //  _title(),
          //   ValueListenableBuilder(
          //     valueListenable: box.listenable(),
          //      builder: (BuildContext context,value,_){
          //       return 
          //       Expanded(
          //         child:  ListView.builder(
          //           itemCount:  value.length,
          //           itemBuilder: (context, index) {
          //             ItemShoppingCartModel item = value.getAt(index);
          //             return _itemView(index,item);
          //             })
          //   );
          //     }),
          StreamBuilder(
            stream: _streamItems ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                 return 
                Expanded(
                  child:  ListView.builder(
                    itemCount:  snapshot.data.length,
                    itemBuilder: (context, index) {
                      ItemShoppingCartModel item = snapshot.data[index];
                      return _itemView(index,item);
                      })
            );
              } 
              return Container(
                child: Text("no data"),
              );
            },
          ),
            _order()
        ],
      ),
    );
  }


  Widget _listItems(){
    box = _shoppingCartBloc.box();
    return Container(
      width: responsive.widht,
      height: responsive.height,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
           _title(),
            ValueListenableBuilder(
              valueListenable: box.listenable(),
               builder: (BuildContext context,value,_){
                return 
                Expanded(
                  child:  ListView.builder(
                    itemCount:  value.length,
                    itemBuilder: (context, index) {
                      ItemShoppingCartModel item = value.getAt(index);
                      return _itemView(index,item);
                      })
            );
              }),
            _order()
        ],
      ),
    ); 
  }

  Widget _order(){
    return //total ui
      Align(
        alignment: Alignment.bottomRight,
        child: Container(
          padding: EdgeInsets.all(7),
          height:responsive.ip(8),           
          child:
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>[
            Expanded(
                child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Row(
                          children: <Widget>[
                            
                            Icon(LineIcons.info_circle,size: responsive.ip(3),color: Colors.grey,),
                            SizedBox(width:2),
                            Text("Total: ",
                              style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w900,
                              fontSize: responsive.ip(2)
                          ),),

                          ],
                        ),

                         Expanded(
                                    child: StreamBuilder( 
                              stream: _shoppingCartBloc.total ,
                              initialData: 0 ,
                              builder: (BuildContext context, AsyncSnapshot snapshot){
                                return Text( 
                                  "\$ ${snapshot.data} MX",
                                  style: TextStyle(
                                    fontSize: responsive.ip(2),
                                    color:Colors.grey,
                                    fontFamily:'Quicksand',
                                    fontWeight: FontWeight.w900
                                  ),
                                );
                              },
                          ),
                    ),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      print("Seguir comprando");
                      _bottomNavBloc.pickItem(2);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children:<Widget>[
                        //  Icon(LineIcons.angle_double_left,size: responsive.ip(3),color: Colors.grey,),
                        //       SizedBox(width:2),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text("Seguir comprando",
                                  style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w900,
                                  fontSize: responsive.ip(2)
                            ),),
                              ),
                      ]
                    ),
                  )
                ],
              ),
            ),
          _button()
        ]),
       )
    );
  }
  Widget _itemView(int index,ItemShoppingCartModel item){
    return Padding(
        padding: const EdgeInsets.symmetric(vertical:4,horizontal: 8),
        child: Container(
         decoration: BoxDecoration(
           
    border: Border(
      bottom: BorderSide(width: 3, color: Color.fromRGBO(228, 228, 228, 1)),
    ),),
    width: responsive.widht,
    height:90,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:<Widget>[
        Padding(
        padding: const EdgeInsets.all(4),
        child: FadeInImage(
          width: 90,
          height: double.infinity,
          image: NetworkImage(item.producto.urlImagen), 
          placeholder: AssetImage('assets/placeholder.png')),
        ),
        Container(
          width: responsive.ip(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>[
            Text(item.producto.nombre,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,fontSize: responsive.ip(2)),),
            Text("Precio Menudeo: \$ ${item.producto.precioMen}",
                style: TextStyle(color:Colors.grey,fontSize: responsive.ip(1.5)),
                ),
            _controlButtons(index,item),
            ]
          ),
        ),
        Container(
          width: responsive.ip(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:<Widget>[

             IconButton(icon:  Icon(LineIcons.times_circle,color:Colors.redAccent,size: 18,),   
             onPressed:(){
              // setState(() {
              //    _shoppingCartBloc.deleteItem(item);
              //  });

              //   setState(() {});
              _shoppingCartBloc.delItem(item);
             }),
            SizedBox(height:responsive.ip(2)),
            Text("\$ ${item.subtotal} MX",
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,fontSize: responsive.ip(1.5)))
            ]
          ),
        )
      ]
    ),
        ),
      );
  }


  // Widget _appBar(){
  //   return AppBar(
  //     brightness :Brightness.light,
  //     backgroundColor: Colors.white,
  //     elevation: 0.0,
  //     centerTitle: true,
  //     title: Text("Carrito de compras",
  //       style:TextStyle(
  //         fontFamily: 'Quicksand',
  //         fontWeight: FontWeight.w900,
  //         fontSize:responsive.ip(2.5),color:Color(0xFF545D68)
  //       ) ,
  //     ),
  //      leading:Row(
  //        children: <Widget>[
  //           IconAction(
  //             icon:LineIcons.angle_left,
  //             onPressed:()=>Navigator.of(context).pop(),

  //             color: Colors.black12,
  //           ),
  //        ],
  //      ),
  //     actions: <Widget>[
  //       IconAction(
  //         icon:LineIcons.search,
  //         onPressed: (){},
  //       ),
  //       // IconAction(
  //       //   icon:LineIcons.trash_o,
  //       //   onPressed:()=>print("Eliminar todo"),//_shoppingCartBloc.deleteAllSC(),
  //       //   color: MyColors.Grey
  //       // ),

  //       IconButton(icon: Icon(LineIcons.trash), onPressed: (){
  //         print("eliminnad");
  //       })
  //       //IconButton(icon: Icon(LineIcons.trash), onPressed: ()=>_shoppingCartBloc.deleteAllSC())

      
  //     ],
  //   );
  // }
  //add items or substract items
  Widget _controlButtons(int index,ItemShoppingCartModel item){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
      GestureDetector(
        //onTap: ()=>_shoppingCartBloc.decItem(item),
        onTap: ()=>_shoppingCartBloc.decItems(item),
        child: Container(
            height: responsive.ip(3.5),
            width: responsive.ip(6),
            decoration: BoxDecoration(
              color: miTema.accentColor,//Color.fromRGBO(172, 238, 180, 1),
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
          
              child: Center(child: Icon(Icons.remove,color: Colors.white,))
            ),
      ),
        SizedBox(width:responsive.ip(2)),
        
        Container(
          
          width: responsive.ip(4),
          child: Center(child: Text(item.cantidad.toString(),style: TextStyle(fontWeight:FontWeight.bold,fontSize: responsive.ip(2)),))),
        
        SizedBox(width:responsive.ip(2)),
        GestureDetector(
          //onTap: ()=>_shoppingCartBloc.incItem(item),
          onTap: ()=>_shoppingCartBloc.incItems(item),  
            child: Container(
            height: responsive.ip(3.5),
            width: responsive.ip(6),
            decoration: BoxDecoration(
              color: miTema.accentColor,//Color.fromRGBO(172, 238, 180, 1),
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
              child: Icon(Icons.add,color:Colors.white,)
            ),
        ),
        
      ],
    );
  }

  

  _button(){
    return  CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
      padding: EdgeInsets.symmetric(horizontal:responsive.ip(1.5),vertical:responsive.ip(1.3)),
      decoration: BoxDecoration(
        color: miTema.accentColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(
                color:Colors.black26,
                blurRadius: 5
        )]
      ),
      child: Row(
        children: <Widget>[
          Text("SIGUIENTE",
            style: TextStyle(
              fontFamily: 'Quiksand',
              color:Colors.white,letterSpacing: 1,
              fontSize: responsive.ip(1.5)),),
          SizedBox(width:5),
          Icon(LineIcons.arrow_right,color:Colors.white,size: responsive.ip(2),)
        ],
      ),
      ),
   onPressed: ()=>Navigator.pushNamed(context, 'checkout'));
  }
  

}
