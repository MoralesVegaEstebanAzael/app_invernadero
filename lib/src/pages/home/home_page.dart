import 'package:app_invernadero/src/blocs/promociones_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/promocion_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final promocionesBloc = Provider.promocionesBloc(context);
    promocionesBloc.cargarPromociones();


    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio", style: TextStyle(color:Colors.grey),),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),

      body: _crearListado(promocionesBloc),
    );
  }

  


   Widget _crearListado(PromocionBloc bloc) {
    return StreamBuilder(
      stream: bloc.promocionStream,
      builder: (BuildContext context, AsyncSnapshot<List<PromocionModel>> snapshot){
         if(snapshot.hasData){
          final productos = snapshot.data;
          return Container(
          child: CarouselSlider.builder(
            itemCount: productos.length, 
            itemBuilder: (ctx, index) {
            return Container(
              child: Image.network(productos[index].urlImagen, fit: BoxFit.cover, height: 150,)
            );
          }, 
            options: CarouselOptions(
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            autoPlay: true,
          ),),
        );

         
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
  
 

  Widget _crearItem(BuildContext context, PromocionModel producto,PromocionBloc bloc){
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color : Colors.red
        ),
       // onDismissed: (direction) => bloc.borrarProducto(producto.id),
        child: Card(
          child: Column(
            children:<Widget>[
            (producto.urlImagen==null) 
              ? Image(image: AssetImage('assets/no-image.png'),)
              : FadeInImage(
                placeholder: AssetImage('assets/jar-loading.gif'), 
                image: NetworkImage(producto.urlImagen),
                height: 300.0,
                width: double.infinity,
                fit: BoxFit.cover,
                ),
                ListTile(
                  title: Text('${producto.descripcion } - ${producto.id}'),
                  subtitle: Text(producto.id.toString()),
                  onTap: ()=>Navigator.pushNamed(context, 'producto',arguments: producto),
                  ),
          ])
        )
    );
  }
}