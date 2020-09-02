import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/blocs/bottom_nav_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/blocs/shopping_cart_bloc.dart';
import 'package:app_invernadero/src/blocs/test_bloc.dart';
import 'package:app_invernadero/src/models/item_shopping_cart_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:app_invernadero/src/widgets/place_holder.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:app_invernadero/src/widgets/search_appbar.dart';
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
  ShoppingCartBloc _shoppingCartBloc=ShoppingCartBloc();
  Stream<List<ItemShoppingCartModel>> _streamItems;
  BottomNavBloc _bottomNavBloc;
  bool flagFrom;
  
  //TestBloc _testBloc = TestBloc();
  ///
  @override
  void initState() { 
    _bottomNavBloc = BottomNavBloc();
   //_testBloc.shoppingCartFect();
    _shoppingCartBloc.cargarArtic();

    //_shoppingCartBloc.shoppingCartFetch();


    super.initState();
  }

  @override
  void dispose() {
    //_shoppingCartBloc.dispose();
    if(flagFrom)
     FlutterStatusbarcolor.setStatusBarColor(miTema.accentColor);
    super.dispose();
  }
  
  @override
  void didChangeDependencies() {
   // _shoppingCartBloc = Provider.shoppingCartBloc(context);

    //news methods 
   
    //_shoppingCartBloc.shoppingCartFect();
    
    _streamItems = _shoppingCartBloc.artcStream;

   
    
    ///
    responsive = Responsive.of(context);
    flagFrom =   ModalRoute.of(context).settings.arguments;
    
    if(flagFrom==null)
      flagFrom=false;
     if(flagFrom)
      FlutterStatusbarcolor.setStatusBarColor(Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        title: "Carrito de compras",
        leading: IconButton(
        icon: Icon(LineIcons.angle_left,color: Colors.grey,), onPressed: ()=>Navigator.pop(context)),
        actions: <Widget>[
          IconAction(
          icon:LineIcons.trash,
          onPressed:(){
            setState(() {
              _shoppingCartBloc.deleteAllSC();
            });
          },
        )
        ],
        
        onChanged:(f)=> _shoppingCartBloc.filter(f),
      ),//_buildBar(context),
      
      body: GestureDetector(
        onTap: (){
            FocusScope.of(context).unfocus();
          },
        child: 
          _shoppingCartBloc.isEmpty()? 
          PlaceHolder( 
          img: 'assets/images/empty_states/empty_cart.svg',
          title: 'No tienes productos',):
          _cuerpo(),
      )
    );
  } 

  _title(){
    return StreamBuilder(
      stream: _shoppingCartBloc.count ,
      initialData: 0 ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
         return  Text( 
          "Mis productos (${snapshot.data})",
          style: TextStyle(
            fontSize: responsive.ip(2),
            color:Colors.grey,
            fontFamily:'Quicksand',
            fontWeight: FontWeight.w900
          ),
        );
      },
    );
  }

  Widget _cuerpo(){
    return Container(
      width: responsive.widht,
      height: responsive.height,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _title(),
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
    ProductoModel prodTemp = _shoppingCartBloc.getItem(item.producto.id);
    
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
        child: 
          prodTemp.cantExis>0? //no agotado
          Container(
            child:(item.producto.urlImagen!=null)?
             FadeInImage(
          width: 90,
          height: double.infinity,
          image: NetworkImage(item.producto.urlImagen), 
          placeholder: AssetImage('assets/placeholder.png')):
          Container(
              width: 90,
            height: double.infinity,
            child:Image.asset('assets/placeholder.png')
          )
          )
          :
          Container(
            height:90,
            width:90,
            child:Column(
              children: <Widget>[
              SvgPicture.asset('assets/images/item_agotado.svg',
              height: 65,
              width: 65,
              ),
              Text("Agotado",style:TextStyle(fontSize:responsive.ip(1.2),color: Colors.redAccent,fontFamily: 'Quicksand',fontWeight: FontWeight.w700))
            ],)
          ),
          
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
          width: responsive.ip(8),
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
            //SizedBox(height:responsive.ip(1)),
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

  
  //add items or substract items
  Widget _controlButtons(int index,ItemShoppingCartModel item){
    final myStyle = TextStyle(fontWeight:FontWeight.bold,fontSize: responsive.ip(2));

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
        SizedBox(width:responsive.ip(1)),
        
        Container(
          
          width: responsive.ip(6),
          child: Center( 
            child:( item.cantidad==null)
            ?
              (item.unidad==AppConfig.uniMedidaKilo)
              ?
              Text("${item.kilos} kg")
              :
              Text("${item.kilos} T")
            :
              Text("${item.cantidad} C")
              )),
        
        SizedBox(width:responsive.ip(1)),
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
