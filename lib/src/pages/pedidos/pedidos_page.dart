import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/blocs/pedido_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/blocs/shopping_cart_bloc.dart';
import 'package:app_invernadero/src/models/pedido/pedido.dart';
import 'package:app_invernadero/src/models/pedido/pedido_model.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/badge_icon.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:app_invernadero/src/widgets/place_holder.dart'; 
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import '../shopping_cart_page.dart';

class PedidosPage extends StatefulWidget {
  PedidosPage({Key key}) : super(key: key);

  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  Responsive _responsive;
  ShoppingCartBloc _shoppingCartBloc; 
  PedidosBloc _pedidosBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting();
  }
  @override
  void didChangeDependencies() {
     _responsive = Responsive.of(context);
     _pedidosBloc = Provider.pedidoBloc(context);
     _pedidosBloc.cargarPedidos();

     _shoppingCartBloc = Provider.shoppingCartBloc(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    _shoppingCartBloc.countItems();
    return Scaffold( 
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: _pedidosBloc.isEmpty()
        ?
        PlaceHolder( 
        img: 'assets/images/empty_states/empty_order.svg',
        title: 'No haz realizado pedidos',)
        :
        _pedidos()//Container(),
      )
      
     /* PlaceHolder( 
        img: 'assets/images/empty_states/empty_order.svg',
        title: 'No haz realizado pedidos',)//Container(),*/
    );
  }

  _appBar(){
    return AppBar(
      brightness :Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      title: Text("Mis pedidos",
        style:TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w900,
          fontSize:_responsive.ip(2.5),color:Color(0xFF545D68)
        ) ,
      ),
     
      actions: <Widget>[
        IconAction(
          icon:LineIcons.search,
          onPressed:null
        ),
         StreamBuilder(
          stream: _shoppingCartBloc.count ,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              int number = snapshot.data;
              return BadgeIcon(
                iconButton:  new IconButton(icon: new Icon(LineIcons.shopping_cart,
                color: MyColors.BlackAccent,),
                  onPressed: null,
              ),
              number: number,
              onTap:() =>_func()
         
        , 
              );
            }
            return Container();
          },
        ),
      ],
    );
  }

   _func(){
     Navigator.of(context).push(
              new MaterialPageRoute(
                  builder:(BuildContext context) =>
                  new ShoppingCartPage()
              )
          );
  }

  _pedidos(){  
     return StreamBuilder(
      stream: _pedidosBloc.pedidoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
       if(snapshot.hasData && snapshot.data!=null){ 
          return ListView.builder(
             itemCount: snapshot.data.length,
             itemBuilder: (context, i) {
               Pedido noti = snapshot.data[i];   
                  return _itemView(noti);
             }
          ); 
        }else {
          return  Container();
        }
      },
    );
  }

  _item(){
    TextStyle _styleTitle = TextStyle(color: MyColors.BlackAccent,fontFamily: 'Quicksand',fontWeight: FontWeight.w700,fontSize: _responsive.ip(2));
    TextStyle _styleSubTitle = TextStyle(fontFamily: 'Quicksand',color: Colors.grey,fontSize: _responsive.ip(1.5));
    TextStyle _style = TextStyle(color: Colors.green,  fontFamily: 'Quicksand',fontSize: _responsive.ip(1.5));
   
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:5,horizontal: 1),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Color.fromRGBO(228, 228, 228, 1)),
          )
        ), 
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: <Widget>[ 
              Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Pedido #999999', style: _styleTitle),
                  SizedBox(height: 5,),
                  Text('12/Ene/2020  03:00 PM', style: _styleSubTitle,), 
                  SizedBox(height: _responsive.ip(2)),
                  Text('Delivery on 21 Fec', style: _style,)
                ],
              ), 
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container( 
                width: _responsive.ip(10),
                child: FadeInImage( image: NetworkImage('https://img2.freepng.es/20181109/gaw/kisspng-portable-network-graphics-kiwifruit-clip-art-image-free-png-images-kiwi-png-toppng-5be592a60ab165.3081310515417719420438.jpg'),
                placeholder:  AssetImage('assets/placeholder.png'),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


 Widget _itemView(Pedido pedido){
  
    TextStyle _styleTitle = TextStyle(color: MyColors.BlackAccent,fontFamily: 'Quicksand',fontWeight: FontWeight.w700,fontSize: _responsive.ip(2));
    TextStyle _styleSubTitle = TextStyle(fontFamily: 'Quicksand',color: Colors.grey,fontSize: _responsive.ip(1.5));
    TextStyle _style = TextStyle(color: Colors.green,  fontFamily: 'Quicksand',fontSize: _responsive.ip(1.5));
   
     return GestureDetector(
       onTap: ()=> Navigator.pushNamed(context, 'pedidoDetalle', arguments: pedido),
       child:  Container(
      // margin: EdgeInsets.all(10.0),
        padding: const EdgeInsets.symmetric(vertical:8,horizontal: 15), 
        decoration: BoxDecoration( 
          border: Border(
              bottom: BorderSide(width: 1, color: Color.fromRGBO(228, 228, 228, 1)),
            )
        ),
        child: Row( 
          children: <Widget>[ 

/*            Container( 
          child:  ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              height: _responsive.ip(8),
              width:_responsive.ip(8),
              child: FadeInImage(
              image: NetworkImage('https://estaticos.miarevista.es/media/cache/1140x_thumb/uploads/images/article/5ea80b695bafe8c012fd5bac/lavarfrutayverdura-ppal.jpg'),
              placeholder: AssetImage('assets/jar-loading.gif'), 
              fit: BoxFit.fill,
             ),
            ),
                  )
            ), 
            SizedBox(width: 15),*/
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Pedido # ${pedido.id}', style: _styleTitle),
                  SizedBox(height: 5,),
                 // Text('${pedido.createdAt}', style: _styleSubTitle,), 
                 Text(new DateFormat.EEEE('es').add_MMMMd().format(pedido.createdAt) + " a las: "+new DateFormat.jm().format(pedido.createdAt),style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w900, fontSize: _responsive.ip(1.6), color: Colors.grey)),
                 SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(Icons.timelapse, color: _statusColor(pedido.estatus)),
                      Expanded(child: Text('Estatus: ${pedido.estatus}', 
                      style: TextStyle(fontFamily:'Quicksand',color:_statusColor(pedido.estatus)))),
                     // Icon(LineIcons.heart_o,color: Colors.grey)
                    ],
                  ),
                  
                ],
              )
            ),
            Column( 
              children: <Widget>[
                Text('Total:', style: _styleTitle,),
                Text('\$ ${pedido.total}', style: _styleSubTitle,)
              ],
            )  
          ],
        ),
        ),
       );
     
    
  }

  Color _statusColor(String status){
    Color _color;
    switch(status){
      case AppConfig.pedidoStatusNuevo:
        _color = Colors.green[400]; 
        break;
      case AppConfig.pedidoStatusRechazado:
        _color = Colors.redAccent;
        break;
      case AppConfig.pedidoStatusAceptado:
        _color = Colors.orange[800];
        break;
      case AppConfig.pedidoStatusEntregado:
        _color = Colors.green;
        break;
      default:
        _color = Colors.grey;
      break;
    }
    // TextStyle _style = TextStyle(fontFamily: 'Quicksand',color:_color);
    // return _style;
    return _color;
  }
 
}