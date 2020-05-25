import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/providers/producto_provider.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class DataSearch extends SearchDelegate{

  final productProvider = ProductoProvider();
  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam',
    'Ironman',
    'Capitan America'
  ];  

  final peliculasResientes=[
    'Capitan America',
    'Spiderman'
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    // acciones del appbar(icon para limpiar o cancelar bussqueda)
    return [
      IconButton(
        icon:Icon(LineIcons.times_circle),
        onPressed: (){
          query='';
        },)
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda
    return Row(
      children: <Widget>[
        IconAction(
          icon:LineIcons.angle_left,
          onPressed:()=>close(context,null)
        ),
      ],
    );
    // return IconButton(
    //   icon: AnimatedIcon(
    //     icon: AnimatedIcons.menu_arrow,
    //     progress: transitionAnimation,
    //     ), 
    //   onPressed: (){
    //     close(context, null);
    //   });
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados a mostrar
    return Container();
  }

  @override
  String get searchFieldLabel => 'Buscar';

  @override
  Widget buildSuggestions(BuildContext context) {
    // sugerencias que aparecen al escribir
    if(query.isEmpty){
      return Container();
    }

    return FutureBuilder(
      future: productProvider.searchProduct(query),
      builder: (BuildContext context,AsyncSnapshot<List<ProductoModel>> snapshot){
        if(snapshot.hasData){
          final productos = snapshot.data;
            return ListView(
              children: productos.map((p){
                return ListTile(
                  leading: FadeInImage(
                    placeholder:AssetImage('assets/placeholder.png'), 
                    image: NetworkImage(p.urlImagen),
                    width: 50.0,
                    fit:BoxFit.contain
                    ),
                    title: Text(p.nombre),
                    subtitle: Text("\$ ${p.precioMenudeo} MX"),
                    onTap: (){
                      close(context, null);
                      Navigator.pushNamed(context, 'product_detail',arguments: p);
                    },
                );
              }).toList(),
            );
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
      );

  }

}