import 'dart:async';

import 'package:app_invernadero/src/models/oferta_model.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class MySlider extends StatefulWidget {
  final List<Oferta> ofertas;

  const MySlider({Key key, this.ofertas}) : super(key: key);

  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
 int _currentPage = 0;

 Responsive _responsive;

PageController _pageController = PageController(
  initialPage: 0,
);

@override
void initState() {
  super.initState();


  Timer.periodic(Duration(seconds: 5), (Timer timer) {
    if (_currentPage < widget.ofertas.length-1) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }

    _pageController.animateToPage(
      _currentPage,
      duration: Duration(milliseconds: 350),
      curve: Curves.easeIn,
    );

  
  });

  
  
  // });
}

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  _responsive =  Responsive.of(context);
}

@override
Widget build(BuildContext context) {
  return Container(
    width: double.infinity,
    height: 150,
    child: Column(
      children: <Widget>[
        Container(
          height: 80,
          width: double.infinity,
          child: PageView.builder(
          
            controller: _pageController,
            itemBuilder: (BuildContext context, int itemIndex) {
                  return _create(widget.ofertas[itemIndex]);
                },),
        ),

               Container(
                 color: Colors.red,
                 height: 25,
                 width: double.infinity,
                 child: Row( //indicadores
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.ofertas.map((p) {
              int index = widget.ofertas.indexOf(p);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                    ? Color.fromRGBO(255, 255,255, 0.9)
                    : Color.fromRGBO(255, 255, 255, 0.4),
                ),
              );
            }).toList()),
               ),
      ],
    ),
  );

  
}

_create(Oferta oferta){
  return Container(
    
    child: Text(oferta.descripcion),
  );
}
//  _createItems(List<Oferta> ofertas,Responsive _responsive){
//     return Container(
//         decoration: BoxDecoration(
//           color:miTema.primaryColor,
//           borderRadius:BorderRadius.circular(15),
//         ),
//         margin: EdgeInsets.only(left: 15,right: 15,top: 10),
//         child: Column(
//         children: <Widget>[
//           CarouselSlider.builder(
//             itemCount: ofertas.length, 
//             itemBuilder: (ctx, index) {
//               return Stack(
//                 children: <Widget>[
//                   Positioned(
//                     right: 0,
//                     bottom: 0,
//                     child: Image.network(ofertas[index].urlImagen, fit: BoxFit.cover, width: _responsive.ip(19),)
//                   ),
//                   Positioned(
//                     top: _responsive.ip(2),
//                     left: _responsive.ip(2),
//                     child: Container(
//                       width: _responsive.wp(30),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[                        
//                           Text("Producto",
//                             style: TextStyle(
//                               color:Colors.white,fontFamily:'Quicksand',fontWeight:FontWeight.w900,
//                               fontSize:_responsive.ip(2)
//                             ),
//                           ),
//                           SizedBox(height:_responsive.ip(1)),
//                           Text(ofertas[index].descripcion,
//                             textWidthBasis: TextWidthBasis.longestLine,
//                             style: TextStyle(
//                               color:Colors.white,fontFamily:'Quicksand',fontWeight:FontWeight.w300,
//                               fontSize:_responsive.ip(2)
//                             ),
//                           ),
//                           SizedBox(height:_responsive.ip(1)),
//                           Container(
//                             width: _responsive.ip(13),
//                             child: _button(_responsive)
//                           ),
//                           //_button()
//                         ],
//                       ),
//                     )),
//                 ], 
//               );
//               }, 
//             options: CarouselOptions(
//             height: _responsive.ip(20),
//            // aspectRatio: 16/9,
//             // onPageChanged: (index, reason) {
//             // setState(() {
//             //   _current = index;
//             // });},
//             viewportFraction: 1.0,
             
//             enlargeCenterPage: true,
//             autoPlay: true,
//           ),),
//           Row( //indicadores
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: ofertas.map((p) {
//               int index = ofertas.indexOf(p);
//               return Container(
//                 width: 8.0,
//                 height: 8.0,
//                 margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: current == index
//                     ? Color.fromRGBO(255, 255,255, 0.9)
//                     : Color.fromRGBO(255, 255, 255, 0.4),
//                 ),
//               );
//             }).toList()),
//         ],
//         ),
//       );
//   }

//   _button(Responsive _responsive){
//     return CupertinoButton(
//       padding: EdgeInsets.zero,
//       child: Container(
//       padding: EdgeInsets.symmetric(horizontal:_responsive.ip(1.5),vertical:_responsive.ip(1.3)),
//       decoration: BoxDecoration(
//         color: miTema.accentColor,
//         borderRadius: BorderRadius.circular(30),
//         boxShadow: [BoxShadow(
//                 color:Colors.black26,
//                 blurRadius: 5
//         )]
//       ),
//       child: Row(
//         children: <Widget>[
//           Text("COMPRAR",
//             style: TextStyle(
//               fontFamily: 'Quiksand',
//               color:Colors.white,letterSpacing: 1,
//               fontSize: _responsive.ip(1.5)),),
//           SizedBox(width:5),
//           //Icon(LineIcons.check,color:Colors.white,size: _responsive.ip(2),)
//         ],
//       ),
//       ),
//       onPressed:  ()=>print("Comprar"));
//   }
// }
}