import 'package:app_invernadero/src/blocs/favoritos_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/favorite_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:app_invernadero/src/widgets/place_holder.dart';
import 'package:app_invernadero/src/widgets/search_appbar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class FavoritosPage extends StatefulWidget { 

  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  Responsive responsive;
  FavoritosBloc _favoritosBloc;
  Stream<List<FavoriteModel>> _favStream;
  
  
  @override
  void didChangeDependencies() {
    _favoritosBloc = Provider.favoritosBloc(context);
    _favoritosBloc.loadFavorites();
    _favStream = _favoritosBloc.favoritesStream;
    
    
    responsive = Responsive.of(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        title: "Mis Favoritos", 
        actions: <Widget>[
          IconButton(
            icon:Icon(LineIcons.trash,color: Colors.grey,),
           onPressed:()=> _deleteAllFav(),
            )
        ],
        onChanged: (f)=>_favoritosBloc.filter(f)),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
         child: (_favoritosBloc.isEmpty())
        ? PlaceHolder( 
          img: 'assets/images/empty_states/empty_fav.svg',
          title: 'No hay productos en \ntu lista de favoritos',
        )
        :
        _listItems()
       )
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
          StreamBuilder(
            stream: _favStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                 return 
                  Expanded(
                      child:  ListView.builder(
                        itemCount:  snapshot.data.length,
                        itemBuilder: (context, index) {
                          FavoriteModel fav = snapshot.data[index];
                          return _itemView(index,fav.producto);
                          })
                );
              }
              return Container(child:Center(child:CircularProgressIndicator() ));
            },
          ),
        ],
      ),
    ); 
  }


  Widget _itemView(int index,ProductoModel item){
    return GestureDetector(
      onTap:()=> Navigator.pushNamed(context, 'product_detail',arguments: item),
          child: Padding(
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
            child:(item.urlImagen!=null)? FadeInImage(
              width: 90,
              height: double.infinity,
              image: NetworkImage(item.urlImagen), 
              placeholder: AssetImage('assets/placeholder.png'))
              :
              Container(
                width:90,
                height:double.infinity,
                child:Image.asset('assets/placeholder.png')
              )
              ,

              
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
        ),
    );
  }

  _deleteAllFav(){
    setState(() {
      _favoritosBloc.deleteAllFav();
    });
  }
  
  
}