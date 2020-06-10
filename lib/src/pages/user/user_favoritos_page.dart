import 'package:app_invernadero/src/blocs/favoritos_bloc.dart';
import 'package:app_invernadero/src/blocs/producto_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/favorite_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:line_icons/line_icons.dart';

class FavoritosPage extends StatefulWidget { 

  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  Responsive responsive;
  FavoritosBloc _favoritosBloc;

  Box _favoriteBox;
  
  @override
  void didChangeDependencies() {
    _favoritosBloc = Provider.favoritosBloc(context);
   
    
    _favoriteBox = _favoritosBloc.box();
    responsive = Responsive.of(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _listItems(),
    );
  }

  _appBar(){
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      title: Text("Favoritos",style: 
        TextStyle(color:Colors.black,fontFamily: 'Quicksand'),),
      // leading:Row(children:<Widget>[
      //   IconAction(icon: LineIcons.angle_left, onPressed: () => Navigator.of(context).pop())
      // ]) ,
  
    actions: <Widget>[
      IconAction(
        icon:Icons.search,
      )
      ],
    );
  }

  _listItems(){
    return Container(
      padding: EdgeInsets.only(top:10),
      width: responsive.widht,
      height: responsive.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[ 
          // StreamBuilder(
          //   stream: _stream ,
          //   builder: (BuildContext context,AsyncSnapshot<List<ProductoModel>> snapshot){
          //     if(snapshot.hasData){ 
          //       return 
          //           Expanded(
          //             child:  ListView.builder(
          //               itemCount:  snapshot.data.length,
          //               itemBuilder: (context, index) {
          //                 ProductoModel item = snapshot.data[index];

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
            box: _favoriteBox, 
            builder:(BuildContext context,Box box){

            if(box.length>0){
             return 
                    Expanded(
                      child:  ListView.builder(
                        itemCount:  box.length,
                        itemBuilder: (context, index) {
                          FavoriteModel fav = box.getAt(index);

                          return _itemView(index,fav.producto);
                          })
                );
            }else{
              return Container();
            }
    }
            
          )

           
        ],
      ),
    ); 
  }


  Widget _itemView(int index,ProductoModel item){
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
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:<Widget>[
        Container(
          margin:EdgeInsets.only(right:responsive.ip(2)),
          padding: const EdgeInsets.all(4),
          child: FadeInImage(
            width: 90,
            height: double.infinity,
            image: NetworkImage(item.urlImagen), 
            placeholder: AssetImage('assets/placeholder.png')),
        ),
        Container(
          width: responsive.ip(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
            Text(item.nombre,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w900,fontSize: responsive.ip(1.8)),),
            Text("Precio Menudeo: \$ ${item.precioMen}",
                style: TextStyle(color:Colors.grey),
                ),
            // _controlButtons(index,item),
            ]
          ),
        ),
        //SizedBox(width:responsive.ip(2)),
        Expanded(
          child:IconButton(icon:  Icon(Icons.favorite,color:Colors.redAccent,size: 25,),   
                onPressed:(){
                _favoritosBloc.deleteFavorite(item.id);
                setState(() {});
             }),
          //         child: Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children:<Widget>[
              
          //     IconButton(icon:  Icon(Icons.favorite,color:Colors.redAccent,size: 25,),   
          //       onPressed:(){
          //     // setState(() {
          //         // _shoppingCartBloc.deleteItem(item);
          //         // _shoppingCartBloc.totalItems();
          //      //});

          //       setState(() {});
          //    }),
          //  // SizedBox(height:responsive.ip(2)),
          //     // Text("\$ ${item.precioMenudeo} MX",
          //     //   style: TextStyle(fontWeight: FontWeight.bold,fontSize: responsive.ip(1.7),fontStyle:FontStyle.italic))
          //   ]
          // ),
        )
      ]
    ),
        ),
      );
  }

  
  
}