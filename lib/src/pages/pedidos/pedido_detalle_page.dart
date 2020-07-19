import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/blocs/pedido_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/pedido/detalle.dart';
import 'package:app_invernadero/src/models/pedido/pedido.dart'; 
import 'package:app_invernadero/src/models/pedido/pedido_model.dart';
import 'package:app_invernadero/src/models/pedido/status.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:app_invernadero/src/widgets/my_appbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart'; 
import 'package:timeline_tile/timeline_tile.dart';

class PedidoDetalle extends StatefulWidget {
  PedidoDetalle({Key key}) : super(key: key);

  @override
  _PedidoDetalleState createState() => _PedidoDetalleState();
}

class _PedidoDetalleState extends State<PedidoDetalle> {
  Responsive _responsive;
  Pedido _pedido;
  PedidosBloc _pedidosBloc;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _responsive = Responsive.of(context);
    _pedidosBloc = Provider.pedidoBloc(context);

    Pedido pedidoAux = ModalRoute.of(context).settings.arguments;
    if(pedidoAux != null){
      _pedido = pedidoAux;
    }
    
    _pedidosBloc.cargarDetalles(_pedido.id);
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
                 Text('Pedido # ${_pedido.id}', style: _styleTitle,)
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
          // _timeLine()
          SingleChildScrollView(
            child: Stack(
              children:<Widget>[
                _linea(),
                Positioned.fill(child: _linea2(),)
              ]
            ),
          ), 
         ],
       ),
    );
  } 

  Widget _listaProductos(){
    return Container(
      height: _responsive.ip(25),
      child: StreamBuilder(
        stream: _pedidosBloc.detalleStream , 
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
                  color: Colors.grey
                ),
                indicatorStyle: const IndicatorStyle(
                  width: 20,
                  color: Colors.grey,
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
                            Icon(Icons.brightness_1,color:Colors.grey,size: 50,), 
                            Icon(LineIcons.check, color: Colors.white,)
                            
                          
                          ],
                        ),
                      ),  
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                             Text(
                          "pedido nuevo",
                          style: TextStyle(color:Colors.white ,fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.8), 
                          ),
                        ), 
                        Text(
                          "2020-07-18 17:18:58.000",
                           style: TextStyle(color:Colors.white,fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.5),)
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
                color: Colors.grey
                ),
                indicatorStyle: const IndicatorStyle(
                  width: 20,
                  color: Colors.grey,
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
                            Icon(Icons.brightness_1,color:Colors.grey,size: 50,), 
                            Icon(LineIcons.clipboard, color: Colors.white,)
                          ],
                        ),
                      ),  
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                             Text(
                          "pedido aceptado",
                          style: TextStyle(color: Colors.white, fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.8), 
                          ),
                        ), 
                        Text(
                          "2020-07-18 17:18:58.000",
                           style: TextStyle(color:Colors.white,fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.5),)
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
                  color: Colors.grey,
                  indicatorY: 0.2,  
                ), 
                topLineStyle: LineStyle(
                color: Colors.grey
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
                            Icon(LineIcons.home, color: Colors.white,)
                          ],
                        ),
                      ),  
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                             Text(
                          "pedido entregado",
                          style: TextStyle(color: Colors.white,fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.8), 
                          ),
                        ), 
                        Text(
                          "2020-07-18 17:18:58.000",
                           style: TextStyle(color:Colors.white, fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.5),)
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
   

  _timeLine(){
    return  Container(
      padding: const EdgeInsets.all(10),
      height: 400,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: ListView.builder(
        itemCount: _pedido.status.length,
        itemBuilder: (BuildContext context,int index){
          Status status = _pedido.status[index];
          return Expanded(child: _element(status));
        }
        ),
    );
   }


  _element(Status status){
    return TimelineTile(
      alignment: TimelineAlign.left,
      isFirst: status.estatus==AppConfig.pedidoStatusNuevo? true:false,
      isLast: status.estatus==AppConfig.pedidoStatusEntregado?true:false,
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
                  Icon(Icons.brightness_1,color:Colors.green[400],size: 50,), 
                  Icon(_iconStatus(status.estatus), color: Colors.white70,)
                ],
              ),
            ),  
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Text(
                "pedido ${status.estatus.toLowerCase()}",
                style: TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w100,fontSize: _responsive.ip(1.8), 
                ),
              ), 
              Text(
                status.createdAt.toString(),
                  style: TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w900,fontSize: _responsive.ip(1.5),)
              ), 
                ],
              )
              

            ],  
        ),
      ),
    );
  }

  _iconStatus(String status){
    switch(status){
      case AppConfig.pedidoStatusNuevo:
        return LineIcons.check;
      case AppConfig.pedidoStatusAceptado:
        return  LineIcons.clipboard;
      case AppConfig.pedidoStatusRechazado:
        return  LineIcons.close;
      case AppConfig.pedidoStatusEntregado:
        return  LineIcons.home;
    }
  }


  Widget _linea2(){
  
    return Container(
        padding: const EdgeInsets.all(10),
     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: new Column(
  mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        // new Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //     child: new TextField(
        //       decoration: new InputDecoration(
        //           hintText: "Type in here!"
        //       ),
        //     )
        // ),
        new Expanded(child: ListView.builder(
        
        itemCount: _pedido.status.length,
        itemBuilder: (BuildContext context,int index){
          Status status = _pedido.status[index];
          return _element(status);
        }
        ))
      ],
   ),
    );
  }
   
}
