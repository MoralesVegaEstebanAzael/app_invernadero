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
  Stream<List<ItemShoppingCartModel>> _stream;

  BottomNavBloc _bottomNavBloc;

  Box box ;
  @override
  void initState() { 
    _bottomNavBloc = BottomNavBloc();
    super.initState();
  }

  @override
  void dispose() {
    _shoppingCartBloc.dispose();
    super.dispose();
  }
  
  @override
  void didChangeDependencies() {
    _shoppingCartBloc = Provider.shoppingCartBloc(context);
    _shoppingCartBloc.loadItems();
    _stream = _shoppingCartBloc.shoppingCartStream;
   
    responsive = Responsive.of(context);
    super.didChangeDependencies();

    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _shoppingCartBloc.isEmpty()? 
        PlaceHolder( 
        img: 'assets/images/empty_states/empty_cart.svg',
        title: 'No tienes productos',):
        _listItems()
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
            Text( 
                  "Mis productos (${box.length})",
                  style: TextStyle(
                    fontSize: responsive.ip(2),
                    color:Colors.grey,
                    fontFamily:'Quicksand',
                    fontWeight: FontWeight.w900
                  ),
                ),
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
              setState(() {
                 _shoppingCartBloc.deleteItem(item);
               });

                setState(() {});
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


  Widget _appBar(){
    return AppBar(
      brightness :Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      title: Text("Carrito de compras",
        style:TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w900,
          fontSize:responsive.ip(2.5),color:Color(0xFF545D68)
        ) ,
      ),
       leading:Row(
         children: <Widget>[
            IconAction(
              icon:LineIcons.angle_left,
              onPressed:()=>Navigator.of(context).pop(),

              color: Colors.black12,
            ),
         ],
       ),
      actions: <Widget>[
        IconAction(
          icon:LineIcons.trash_o,
          onPressed:()=>setState(() { _shoppingCartBloc.deleteAllItems(); 
          }),
          color: MyColors.Grey
        ),
        // IconAction(
        //   icon:LineIcons.bell,
        //   onPressed:()=> Navigator.pushNamed(context, 'notifications')
        // )
      ],
    );
  }
  //add items or substract items
  Widget _controlButtons(int index,ItemShoppingCartModel item){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
      GestureDetector(
        onTap: ()=>_shoppingCartBloc.decItem(item),
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
          onTap: ()=>_shoppingCartBloc.incItem(item),
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
