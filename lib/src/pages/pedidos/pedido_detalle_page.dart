import 'package:app_invernadero/src/blocs/pedido_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/pedido/detalle.dart'; 
import 'package:app_invernadero/src/models/pedido/pedido_model.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:app_invernadero/src/widgets/my_appbar.dart';
import 'package:line_icons/line_icons.dart'; 
import 'package:timeline_tile/timeline_tile.dart';

class PedidoDetalle extends StatefulWidget {
  PedidoDetalle({Key key}) : super(key: key);

  @override
  _PedidoDetalleState createState() => _PedidoDetalleState();
}

class _PedidoDetalleState extends State<PedidoDetalle> {
  Responsive _responsive;
  PedidoModel _pedido;
  PedidosBloc _pedidosBloc;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _responsive = Responsive.of(context);
    _pedidosBloc = Provider.pedidoBloc(context);

    PedidoModel pedidoAux = ModalRoute.of(context).settings.arguments;
    if(pedidoAux != null){
      _pedido = pedidoAux;
    }
    
    _pedidosBloc.cargarDetalles(_pedido.pedido.id);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Detalle pedido"),
      body: _pedidoDetalle()
    );
  }

  Widget _pedidoDetalle(){
  TextStyle _styleTitle = TextStyle(color: MyColors.BlackAccent,fontFamily: 'Quicksand',fontWeight: FontWeight.w700,fontSize: _responsive.ip(2));
     return Container(
      padding: EdgeInsets.all(4),
     // margin: EdgeInsets.only(top:8),
      width:  double.infinity,
      height: double.infinity,
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           Container( 
             decoration: BoxDecoration( 
             border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(228, 228, 228, 1)),)
              ),
             width:  double.infinity,
             padding: EdgeInsets.all(10),
             child: Row( 
               children: <Widget>[
                 Text('Order # ${_pedido.pedido.id}', style: _styleTitle,)
               ],
             ),
           ),
          
          Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Productos', style: _styleTitle,),
                _listaProductos(),
              ],
            ),
          ),

         /* SizedBox(height: 10),
          Text("Productos", style: _styleTitle ),

          Expanded(child: StreamBuilder(
            stream: _pedidosBloc.deatlleStream , 
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData && snapshot.data!=null){ 
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    Detalle det = snapshot.data[i];
                    print("%%%%%%%%%%%%%%%%5");
                    print(det);
                    return _itemView(det);
                  }
                ); 
              }else {
                return  Container();
              } 
            },
          ),
          ),*/
           
          Container( 
            padding: EdgeInsets.only(top: 15, left: 10),
            width:  double.infinity,
            decoration: BoxDecoration( 
             border: Border(top: BorderSide(width: 1, color: Color.fromRGBO(228, 228, 228, 1)),)
              ),
            child: Row(
              children: <Widget>[
                Text('Estado del pedido', style: _styleTitle,),  

              ],
            )
          ),
          SingleChildScrollView(
            child: _linea(),
          ), 
         ],
       ),
    );
  } 

  Widget _listaProductos(){
    return Container(
      height: _responsive.ip(25),
      child: StreamBuilder(
        stream: _pedidosBloc.deatlleStream , 
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData && snapshot.data!=null){ 
            return  ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  Detalle det = snapshot.data[i]; 
                  return _itemView(det);
                } 
            ); 
         }else {
            return  Container();
         } 
        },
      ),
    );
  }
 

  Widget _itemView(Detalle detalle){
     return  Stack(
       children: <Widget>[
         Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal:4),
        width: _responsive.widht,
        height: _responsive.ip(6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:<Widget>[
            Container( 
              width: _responsive.wp(20),
              child: Text(
                '${detalle.nombreProducto}',
                style: TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.5)),
                )),
            Container(
              width: _responsive.wp(20),
              child: Text( "${detalle.unidadM}: ${detalle.cantidadPedido}",
              style: TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.5)))),
             Container(
                width: _responsive.wp(20),
                child: Text("\$ ${detalle.cantidadPedido * detalle.precioUnitario} MX",textAlign: TextAlign.right,
                style: TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.5))
                )),     
          ]
        ), 
     )
      ],
     );
  }

   

Widget _linea(){
   return  Container(
     padding: const EdgeInsets.all(10),
     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
     child: Column( 
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              
              TimelineTile(
                alignment: TimelineAlign.left,
                isFirst: true,
                topLineStyle: LineStyle(
                  color: MyColors.GreenAccent
                ),
                indicatorStyle: const IndicatorStyle(
                  width: 20,
                  color: MyColors.GreenAccent,
                  indicatorY: 0.2, 
                ), 
                rightChild:  Container(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                      children: [
                        Container(
                        child:  Stack(       
                          alignment: Alignment.center,           
                          children: <Widget>[
                            Icon(Icons.brightness_1,color:Colors.green[100],size: 50,), 
                            Icon(LineIcons.check, color: Colors.white70,)
                          ],
                        ),
                      ),  
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                             Text(
                          "Pedido confirmado",
                          style: TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.8), 
                          ),
                        ), 
                        Text(
                          "20-Dec-2029",
                           style: TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.5),)
                        ), 
                          ],
                        )
                       

                      ],  
                  ),
                ),
              ), 
             TimelineTile(
                alignment: TimelineAlign.left, 
                topLineStyle: LineStyle(
                  //color: MyColors.GreenAccent
                ),
                indicatorStyle: const IndicatorStyle(
                  width: 20,
                  //color: MyColors.GreenAccent,
                  indicatorY: 0.3,  
                ), 
                rightChild:  Container(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                      children: [
                        Container(
                        child:  Stack(       
                          alignment: Alignment.center,           
                          children: <Widget>[
                            Icon(Icons.brightness_1,color:Colors.grey,size: 50,), 
                            Icon(LineIcons.clipboard, color: Colors.white70,)
                          ],
                        ),
                      ),  
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                             Text(
                          "Preparando pedido",
                          style: TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.8), 
                          ),
                        ), 
                        Text(
                          "20-Dec-2029",
                           style: TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.5),)
                        ), 
                          ],
                        )
                       

                      ],  
                  ),
                ),
              ), 
               TimelineTile(
                alignment: TimelineAlign.left, 
                topLineStyle: LineStyle(
                  //color: MyColors.GreenAccent
                ),
                indicatorStyle: const IndicatorStyle(
                  width: 20,
                  //color: MyColors.GreenAccent,
                  indicatorY: 0.3,  
                ), 
                rightChild:  Container(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                      children: [
                        Container(
                        child:  Stack(       
                          alignment: Alignment.center,           
                          children: <Widget>[
                            Icon(Icons.brightness_1,color:Colors.grey,size: 50,), 
                            Icon(LineIcons.truck, color: Colors.white70,)
                          ],
                        ),
                      ),  
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                             Text(
                          "Pedido en camino",
                          style: TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.8), 
                          ),
                        ), 
                        Text(
                          "20-Dec-2029",
                           style: TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.5),)
                        ), 
                          ],
                        )
                       

                      ],  
                  ),
                ),
              ), 
               
             TimelineTile(
                alignment: TimelineAlign.left, 
                isLast: true,
                indicatorStyle: const IndicatorStyle(
                  width: 20,
                  //color: MyColors.GreenAccent,
                  indicatorY: 0.4,  
                ), 
                rightChild:  Container(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                      children: [
                        Container(
                        child:  Stack(       
                          alignment: Alignment.center,           
                          children: <Widget>[
                            Icon(Icons.brightness_1,color:Colors.grey,size: 50,), 
                            Icon(LineIcons.home, color: Colors.white70,)
                          ],
                        ),
                      ),  
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                             Text(
                          "Pedido entregado",
                          style: TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.8), 
                          ),
                        ), 
                        Text(
                          "20-Dec-2029",
                           style: TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.5),)
                        ), 
                          ],
                        )
                       

                      ],  
                  ),
                ),
              ), 
             
            ], 
        ),
   );
  }
   
}
