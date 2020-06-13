import 'package:app_invernadero/src/blocs/favoritos_bloc.dart';
import 'package:app_invernadero/src/blocs/producto_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/favorite_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:app_invernadero/src/widgets/place_holder.dart';
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
      body:(_favoriteBox.isNotEmpty)
        ?  _listItems()
        :
        PlaceHolder( 
          img: 'assets/images/empty_states/empty_fav.svg',
          title: 'No hay productos en \ntu lista de favoritos',
        )
    );
  }

   _appBar(){
    return AppBar(
      brightness :Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      title: Text("Mis Favoritos",
        style:TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w900,
          fontSize:responsive.ip(2.5),color:Color(0xFF545D68)
        ) ,
      ),
     
      actions: <Widget>[
        IconAction(
          icon:LineIcons.search,
          onPressed:null
        ),
        IconAction(
          icon:LineIcons.trash,
          onPressed:()=> _deleteAllFav()

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
          ValueListenableBuilder(
            valueListenable: _favoriteBox.listenable(), 
            builder:(BuildContext context,value,_){
              if(value.length>0){
                return 
                  Expanded(
                      child:  ListView.builder(
                        itemCount:  value.length,
                        itemBuilder: (context, index) {
                          FavoriteModel fav = value.getAt(index);
                          return _itemView(index,fav.producto);
                          })
                );
              }else{
                return Container();
              }
            }
          ),  
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
        )
      ]
    ),
        ),
      );
  }

  _deleteAllFav(){
    setState(() {
      _favoritosBloc.deleteAllFav();
    });
  }
  
  
}