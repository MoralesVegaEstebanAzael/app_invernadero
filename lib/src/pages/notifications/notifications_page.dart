import 'dart:convert';

import 'package:app_invernadero/src/blocs/shopping_cart_bloc.dart';
import 'package:app_invernadero/src/services/local_services.dart';
import 'package:app_invernadero/src/services/notifications_service.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/badge_icon.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:app_invernadero/src/widgets/place_holder.dart'; 
import 'package:flutter/material.dart'; 
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:app_invernadero/src/blocs/notification_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';  
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:app_invernadero/src/models/notification_model.dart';   
import 'package:timeago/timeago.dart' as timeago; 
import 'package:provider/provider.dart' as provider;

import '../shopping_cart_page.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key}) : super(key: key);
  
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
} 

class _NotificationsPageState extends State<NotificationsPage> {
  Responsive responsive;
  NotificacionesBloc _notificationBloc;
  ShoppingCartBloc _shoppingCartBloc;
  Box _notificationsBox;  
  Map notiMap = Map<String, NotificacionModel>();

  @override
  void initState() {
    // TODO: implement initState
   
    super.initState();
  }


  @override
  void didChangeDependencies() async{ 
    responsive = Responsive.of(context); 

    _shoppingCartBloc = Provider.shoppingCartBloc(context);
    _notificationBloc = Provider.notificacionBloc(context) ; 
  
   

   // await _notificationBloc.markAsReadNotifications();
    await _notificationBloc.cargarNotificaciones(); //notificaciones locales
    //_notificationBloc.cargarNotificaciones(); 

    //_notificationsBox = _notificationBloc.box(); 
      
    

    


   // _notificationBloc.markAsReadNotifications();
    super.didChangeDependencies();
  } 

  @override
  void dispose() {
    // TODO: implement dispose
    
   // _notificationBloc.unreadNotificationsList.clear();
    super.dispose();
    _notificationBloc.markAsReadNotifications(); 
   // marcarComoLeida(); 
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: _appBar(), 
      body: _notifications(),
      // body: ValueListenableBuilder(
      // valueListenable: _notificationsBox.listenable(),
      // builder:(BuildContext context,value,_){
      //   if(value.length>0){ 
      //     return ListView.builder(
      //        itemCount: value.length,
      //        itemBuilder: (context, i) {
      //          NotificacionModel noti = value.getAt(i);   
      //             return _crearListTitle(noti);
      //        }
      //     ); 
      //   }else {
      //     return  PlaceHolder(
      //       img: 'assets/images/empty_states/empty_notifications.svg',
      //       title: 'No tienes notificaciones',
      //     );
      //   }
      // }
    //), 
    );
  } 

  _appBar(){
    return AppBar(
      brightness :Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      title: Text("Notificaciones",
        style:TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w900,
          fontSize:responsive.ip(2.5),color:Color(0xFF545D68)
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

  _notifications(){
    return StreamBuilder(
      stream: _notificationBloc.notificacionesStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
       if(snapshot.hasData && snapshot.data!=null){ 
          return ListView.builder(
             itemCount: snapshot.data.length,
             itemBuilder: (context, i) {
               NotificacionModel noti = snapshot.data[i];   
                  return Dismissible(
                     key: Key(noti.id),
                     onDismissed: (direction) {
                        setState(() {
                         _notificationBloc.deleteNotification(noti);
                        });
                      },
                    child: _crearListTitle(noti));
             }
          ); 
        }else {
          return  PlaceHolder(
            img: 'assets/images/empty_states/empty_notifications.svg',
            title: 'No tienes notificaciones',
          );
        }
      },
    );
  }

  Widget _crearListTitle(NotificacionModel notificacion){ 
  bool flag = _notificationBloc.unreadNotificationsList.contains(notificacion); 
  
  print(notificacion.data);
  
  

  //Map valueMap = notificacion.map();
  DateTime myDatetime = DateTime.parse(notificacion.createdAt);  
    return Container(   
        decoration: BoxDecoration(
          color:  (flag) ? Colors.blueGrey[50] : Colors.white,
          border: Border(
          bottom: BorderSide(width: 1, color: Color.fromRGBO(228, 228, 228, 1)),
        ),),
        child:ListTile( 
              leading: Container(  
                height: 50,
                width: 50,
                child: Icon(LineIcons.leaf, color: Theme.of(context).primaryColor,size: 40.0,),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100), 
                  color: Colors.green[100],
                ), 
              ), 
             title: Text('${notificacion.createdAt}', style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w700, fontSize: 16.0)),
              subtitle: Text('${notificacion.data['mensaje']}', style: TextStyle(fontFamily:'Quicksand', fontWeight: FontWeight.w600)),           
              trailing: Text(timeago.format(myDatetime, locale: 'es'), style: TextStyle(fontFamily:'Quicksand',fontStyle: FontStyle.italic ,fontWeight: FontWeight.w900, fontSize: 9.0, color: Colors.grey)),
              onTap: (){},                
        ), 
       );
  } 


  // void marcarComoLeida(){  
  //   Map mapa = _notificationsBox.toMap(); 

  //   mapa.forEach((k,v){
  //     NotificacionModel item = v;
      
  //     if(item.readAt == null || item.readAt == ""){
  //       item.readAt = DateTime. now().toString(); 
  //       notiMap.putIfAbsent(k, ()=>item);  
  //     } 
  //   }); 
  //  // _notificationBloc.insertar(notiMap);
  // }

  // Widget _crearItemSlider(NotificacionModel notificacion, int index){
  //   return Slidable(
  //     actionPane: SlidableDrawerActionPane(),
  //     actionExtentRatio: 0.25,
  //     //dismissal: SlidableDismissal(child: SlidableDrawerDismissal()),      
  //     child: _crearListTitle(notificacion), 
  //     secondaryActions: <Widget>[
  //        IconSlideAction(
  //         caption: 'Visto',
  //         color: Colors.green[500],
  //         icon: LineIcons.eye,          
  //         //closeOnTap: true,
         
  //       ),
  //       IconSlideAction( 
  //         caption: 'Eliminar', 
  //         color: Colors.red[400],
  //         icon: LineIcons.eye_slash,
  //         closeOnTap: true,
  //         onTap: (){
  //           print('se elimina y se  vuelve a cargar');
  //           setState(() {
  //            // notificaciones.removeAt(index);
  //           });
  //         },
  //       ), 
  //     ], 
  //   );
  // } 

   _func(){
     Navigator.of(context).push(
              new MaterialPageRoute(
                  builder:(BuildContext context) =>
                  new ShoppingCartPage()
              )
          );
  }

}


/**
 * {"notifications":{"cdc1e332-bf9d-482f-99b6-8fdca8bb0ddd":{"id":"cdc1e332-bf9d-482f-99b6-8fdca8bb0ddd","type":"App\\Notifications\\ClientNotification","notifiable_type":"App\\Cliente","notifiable_id":"31c372e5-d1ba-4ce2-b4d6-6520fe6fa58f","data":"{\"titulo\":\"Pedido\",\"tipo\":1,\"mensaje\":\"se ha enviado tu pedido \"}","read_at":"2020-06-25 19:32:42","created_at":"2020-06-11 23:49:33","updated_at":"2020-06-25 19:32:42"}}}
I/flutter (19946): **********guardando en hive


 {"notificaciones":{"cdc1e332-bf9d-482f-99b6-8fdca8bb0ddd":{"id":"cdc1e332-bf9d-482f-99b6-8fdca8bb0ddd","type":"App\\Notifications\\ClientNotification","notifiable_type":"App\\Cliente","notifiable_id":"31c372e5-d1ba-4ce2-b4d6-6520fe6fa58f","data":{"titulo":"Pedido","tipo":1,"mensaje":"se ha enviado tu pedido "},"read_at":null,"created_at":"2020-06-11 23:49:33","updated_at":"2020-06-25 19:32:42"}}}
 * 
 * 
 */