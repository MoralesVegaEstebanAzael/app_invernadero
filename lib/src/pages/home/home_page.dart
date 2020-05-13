import 'package:app_invernadero/src/blocs/promociones_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/promocion_model.dart';
import 'package:app_invernadero/src/widgets/app_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flushbar/flushbar.dart';
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
    print("CARGANDO PAGINA");
    _controller = AnimationController(vsync: this);

  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_promocionBloc==null){
      _promocionBloc = Provider.promocionesBloc(context);
      _promocionBloc.cargarPromociones(context);
    }
    
  }
  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();  
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: PreferredSize(
        child: MyAppBar(title: "INVERNADERO"),
        preferredSize: Size.fromHeight(80),
      ),
      body: _sliderPage(_promocionBloc),
      
    );
  }
  
  Widget _sliderPage(PromocionBloc bloc) {
    return StreamBuilder(
      stream: bloc.promocionStream,
      builder: (BuildContext context, AsyncSnapshot<List<PromocionModel>> snapshot){
        if(snapshot.hasData){
          return Container(
          child: _crearItem(snapshot,context),); 
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
  
  Widget _crearItem(AsyncSnapshot<List<PromocionModel>> snapshot,BuildContext context){
    final productos = snapshot.data;
    if(productos.length>0){
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
    }else{
      print("Ha ocurrido un error");
      return Container();
    }
  }

  
  
}