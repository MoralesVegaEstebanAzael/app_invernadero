import 'package:app_invernadero/src/models/oferta_model.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliderOfertas extends StatefulWidget {
  final List<Oferta> ofertas;

  const SliderOfertas({Key key, this.ofertas}) : super(key: key);

  @override
  _SliderOfertasState createState() => _SliderOfertasState();
}

class _SliderOfertasState extends State<SliderOfertas> {
    int current=0;

  @override
  Widget build(BuildContext context) {

    print("PASADNDO POR BUILD DE SLIDER");

    Responsive _responsive = Responsive.of(context);

    return Container(
      child: widget.ofertas.length>0?
      _createItems(widget.ofertas, _responsive)
      :
      Container(
            width:_responsive.widht,
            height:_responsive.ip(20),
            decoration: BoxDecoration(
              color:MyColors.PlaceholderBackground,
              borderRadius:BorderRadius.circular(15),
            ),  
            margin: EdgeInsets.only(left: 15,right: 15,top: 10),
            // child:  Image(image: AssetImage('assets/placeholder_promocion.gif')),
          ) 
      ,
    );
  }

  _createItems(List<Oferta> ofertas,Responsive _responsive){
    return Container(
        decoration: BoxDecoration(
          color:miTema.primaryColor,
          borderRadius:BorderRadius.circular(15),
        ),
        margin: EdgeInsets.only(left: 15,right: 15,top: 10),
        child: Column(
        children: <Widget>[
          CarouselSlider.builder(
            itemCount: ofertas.length, 
            itemBuilder: (ctx, index) {
              return Stack(
                children: <Widget>[
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Image.network(ofertas[index].urlImagen, fit: BoxFit.cover, width: _responsive.ip(19),)
                  ),
                  Positioned(
                    top: _responsive.ip(2),
                    left: _responsive.ip(2),
                    child: Container(
                      width: _responsive.wp(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[                        
                          Text("Producto",
                            style: TextStyle(
                              color:Colors.white,fontFamily:'Quicksand',fontWeight:FontWeight.w900,
                              fontSize:_responsive.ip(2)
                            ),
                          ),
                          SizedBox(height:_responsive.ip(1)),
                          Text(ofertas[index].descripcion,
                            textWidthBasis: TextWidthBasis.longestLine,
                            style: TextStyle(
                              color:Colors.white,fontFamily:'Quicksand',fontWeight:FontWeight.w300,
                              fontSize:_responsive.ip(2)
                            ),
                          ),
                          SizedBox(height:_responsive.ip(1)),
                          Container(
                            width: _responsive.ip(13),
                            child: _button(_responsive)
                          ),
                          //_button()
                        ],
                      ),
                    )),
                ], 
              );
              }, 
            options: CarouselOptions(
            height: _responsive.ip(20),
            onPageChanged: (index, reason) {
            setState(() {
              current = index;
              print("cambiando");
            });},
            viewportFraction: 1.0,
             
            enlargeCenterPage: true,
            autoPlay: true,
          ),),
          Row( //indicadores
            mainAxisAlignment: MainAxisAlignment.center,
            children: ofertas.map((p) {
              int index = ofertas.indexOf(p);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: current == index
                    ? Color.fromRGBO(255, 255,255, 0.9)
                    : Color.fromRGBO(255, 255, 255, 0.4),
                ),
              );
            }).toList()),
        ],
        ),
      );
  }

  _button(Responsive _responsive){
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
      padding: EdgeInsets.symmetric(horizontal:_responsive.ip(1.5),vertical:_responsive.ip(1.3)),
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
          Text("COMPRAR",
            style: TextStyle(
              fontFamily: 'Quiksand',
              color:Colors.white,letterSpacing: 1,
              fontSize: _responsive.ip(1.5)),),
          SizedBox(width:5),
          //Icon(LineIcons.check,color:Colors.white,size: _responsive.ip(2),)
        ],
      ),
      ),
      onPressed:  ()=>print("Comprar"));
  }
}