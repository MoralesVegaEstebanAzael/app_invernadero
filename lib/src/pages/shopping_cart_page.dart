import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/blocs/shopping_cart_bloc.dart';
import 'package:app_invernadero/src/models/shopping_cart_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/app_bar.dart';
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
  Stream<List<ShoppingCartModel>> _stream;
  
  @override
  void initState() { 
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
    Box box = _shoppingCartBloc.box();
    return Container(
      width: responsive.widht,
      height: responsive.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left:responsive.ip(2),bottom:responsive.ip(2)),
            child:
            StreamBuilder(
              stream: _shoppingCartBloc.count ,
              initialData: 0 ,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return Text( 
                  "Mis productos (${snapshot.data})",
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
            // StreamBuilder(
            //   stream: _stream ,
            //   builder: (BuildContext context,AsyncSnapshot<List<ShoppingCartModel>> snapshot){
            //     if(snapshot.hasData){ 
            //       return 
            //           Expanded(
            //             child:  ListView.builder(
            //               itemCount:  snapshot.data.length,
            //               itemBuilder: (context, index) {
            //                 ShoppingCartModel item = snapshot.data[index];
            //                 print("ITEM ${item.imagenUrl}");
            //                 return _itemView(index,item);
            //                 })
            //       );
            //     }else{
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }            
            //   },
            // ),

            WatchBoxBuilder(
              box: box, 
              builder: (BuildContext context,Box box){
                return 
                      Expanded(
                        child:  ListView.builder(
                          itemCount:  box.length,
                          itemBuilder: (context, index) {
                            ShoppingCartModel item = box.getAt(index);
                            print("ITEM ${item.imagenUrl}");
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
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.only(bottom:5,left: 4,right: 4),
          padding: EdgeInsets.all(7),
          height:responsive.ip(13),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:<Widget>[
                  Text("Total: \$",
                    style: TextStyle(
                          fontSize: responsive.ip(2),
                          color:Colors.grey,
                          fontFamily:'Quicksand',
                          fontWeight: FontWeight.w900
                        ),),
                  SizedBox(width:responsive.ip(1)),
                  Container(
                    width: responsive.ip(10),
                    child: StreamBuilder( 
                      stream: _shoppingCartBloc.total ,
                      initialData: 0 ,
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        return Text( 
                          "${snapshot.data}",
                          style: TextStyle(
                            fontSize: responsive.ip(2),
                            color:Colors.black,
                            fontFamily:'Quicksand',
                            fontWeight: FontWeight.w900
                          ),
                        );
                      },
                  ),
                  ),
                ]
              ),
              SizedBox(height:responsive.ip(1)),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                padding: EdgeInsets.symmetric(horizontal:responsive.ip(2),vertical:responsive.ip(1)),
                decoration: BoxDecoration(
                  color:miTema.accentColor,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [BoxShadow(
                          color:Colors.black26,
                          blurRadius: 5
                  )]
                ),
                child:
                Text("Ordenar ",style: TextStyle(color:Colors.white),)
                  //Icon(LineIcons.shopping_cart,color:miTema.accentColor),//Text("Agregar",style: TextStyle(fontFamily: 'Quiksand',color:Colors.white,letterSpacing: 1,fontSize: 15),),
                ),
                onPressed: ()=>print("object")
              ),
            ],
          ), 
        )
    );
  }
  Widget _itemView(int index,ShoppingCartModel item){
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
          image: NetworkImage(item.imagenUrl), 
          placeholder: AssetImage('assets/placeholder.png')),
        ),
        Container(
          width: responsive.ip(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>[
            Text(item.nombre,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,fontSize: responsive.ip(2)),),
            Text("Precio Menudeo: \$ ${item.precioMenudeo}",
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
                  _shoppingCartBloc.deleteItem(item);
                  _shoppingCartBloc.totalItems();
               //});

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
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      title: Text("Carrito de compras",
        style:TextStyle(
          fontFamily: 'Quicksand',fontSize:responsive.ip(2.5),color:Color(0xFF545D68)
        ) ,
      ),
      actions: <Widget>[
       
       Container(
          width: responsive.ip(5),
          height: responsive.ip(5),
          margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: MyColors.Grey,
          shape: BoxShape.circle,
        
        ),
        child:  IconButton(
        icon: Icon(LineIcons.bell,color:Color(0xFF545D68),size: responsive.ip(2.5),), 
        onPressed: (){
            Navigator.pushNamed(context, 'notifications');
        }),
        ),

        // IconButton(
        //   icon: Icon(LineIcons.trash,color:Color(0xFF545D68)), 
        //   onPressed: (){
           
        //     setState(() { _shoppingCartBloc.deleteAllItems(); });
        //   })

        Container(
          width: responsive.ip(5),
          height: responsive.ip(5),
          margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: MyColors.Grey,
          shape: BoxShape.circle,
        
        ),
        child:  IconButton(
        icon: Icon(LineIcons.trash,color:Color(0xFF545D68),size: responsive.ip(2.5),), 
        onPressed: (){
          setState(() { _shoppingCartBloc.deleteAllItems(); }); Navigator.pushNamed(context, 'notifications');
        }),
        ),
      ],
    );
  }
  //add items or substract items
  Widget _controlButtons(int index,ShoppingCartModel item){
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

  


  

}