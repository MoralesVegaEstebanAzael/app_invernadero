import 'package:app_invernadero/src/blocs/promociones_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/promocion_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  PromocionBloc _promocionBloc;
 
  int _current=0;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose(); 
    
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    _promocionBloc = Provider.promocionesBloc(context);
    _promocionBloc.cargarPromociones();
    return Scaffold(
      appBar: _appBar(),

      body: _sliderPage(_promocionBloc),
    );
  }

  
  
  
  Widget _sliderPage(PromocionBloc bloc) {
    return StreamBuilder(
      stream: bloc.promocionStream,
      builder: (BuildContext context, AsyncSnapshot<List<PromocionModel>> snapshot){
         if(snapshot.hasData){
          return Container(
          child: _crearItem(snapshot),
        ); 
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
  
 

  Widget _crearItem(AsyncSnapshot<List<PromocionModel>> snapshot){
    final productos = snapshot.data;
    return Column(
      
      children: <Widget>[
        CarouselSlider.builder(
          itemCount: productos.length, 
          itemBuilder: (ctx, index) {
            return Container(
              child: Image.network(productos[index].urlImagen, fit: BoxFit.cover, height: 150,)
            );
            }, 
          options: CarouselOptions(
          aspectRatio: 16/9,
          onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });},
          enlargeCenterPage: true,
          autoPlay: true,
        ),),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: productos.map((p) {
            int index = productos.indexOf(p);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                  ? Color.fromRGBO(0, 0, 0, 0.9)
                  : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList()),
      ],
      );
  }


  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,

        title: Text('INVERNADERO',
          style:TextStyle(
            fontFamily: 'Varela',fontSize:25.0,color:Color(0xFF545D68)
          ) ,
        ),
        actions: <Widget>[
          IconButton(
          icon: Icon(LineIcons.bell,color:Color(0xFF545D68),), 
          onPressed: (){}),
        ],
    );
  }
}