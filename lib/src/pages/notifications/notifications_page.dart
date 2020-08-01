import 'dart:convert';

import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/blocs/shopping_cart_bloc.dart';
import 'package:app_invernadero/src/services/local_services.dart';
import 'package:app_invernadero/src/services/notifications_service.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/badge_icon.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:app_invernadero/src/widgets/place_holder.dart';
import 'package:app_invernadero/src/widgets/search_appbar.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart'; 
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
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


  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }
  
  
  @override
  void didChangeDependencies(){ 
    responsive = Responsive.of(context); 
    _shoppingCartBloc = Provider.shoppingCartBloc(context);
    _notificationBloc = Provider.notificacionBloc(context) ; 
    _notificationBloc.cargarNotificaciones(); //notificaciones locales
    super.didChangeDependencies();
  } 

  @override
  void dispose() {
    super.dispose();
    _notificationBloc.markAsReadNotifications(); 
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: Colors.white,
      appBar: _appBar(), 
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child:
        _notificationBloc.isEmpty()
        ? 
        PlaceHolder(
            img: 'assets/images/empty_states/empty_notifications.svg',
            title: 'No tienes notificaciones',
          )
        :
        _notifications()
        )
    );
  }   
  
  _appBar(){
    return  SearchAppBar(
        title: "Notificaciones", 
        actions: <Widget>[
          
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
                onTap:() =>_func(), 
                );
              }
              return Container();
            },
          ),

        ],
        onChanged: (f)=>_notificationBloc.filter(f));
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
                  return _crearListTitle(noti);
             }
          ); 
        }else {
          return  Container();
        }
      },
    );
  }

  Widget _crearListTitle(NotificacionModel notificacion){ 
  bool flag = _notificationBloc.unreadNotificationsList.contains(notificacion); 

  DateTime myDatetime = DateTime.parse(notificacion.createdAt);  
  
  print("id: ${notificacion.id} notifi read: ${notificacion.readAt}");
    return Container(   
        decoration: BoxDecoration(
          color:  (flag) ? Colors.green[50] : Colors.white,
          border: Border(
          bottom: BorderSide(width: 1, color: Color.fromRGBO(228, 228, 228, 1)),
        ),),
        child:Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListTile( 
              leading: _leading(notificacion.data['tipo']),
              // title: Text('${notificacion.data['tipo']}', style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w700, fontSize: 16.0,color: Colors.black45)),
              subtitle: Text('${notificacion.data['mensaje']}', style: TextStyle(fontFamily:'Quicksand', fontWeight: FontWeight.w600)),           
              //trailing: Text(timeago.format(myDatetime, locale: 'es'), style: TextStyle(fontFamily:'Quicksand',fontStyle: FontStyle.italic ,fontWeight: FontWeight.w900, fontSize: 9.0, color: Colors.grey)),
              // trailing: Column(
              //   children:<Widget>[
              //     Text(new DateFormat.EEEE('es').add_MMMMd().format(myDatetime),style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w900, fontSize: responsive.ip(1.2), color: Colors.grey)),
              //     Text("a las: "+new DateFormat.jm().format(myDatetime),style: TextStyle(fontFamily:'Quicksand' ,fontWeight: FontWeight.w900, fontSize: responsive.ip(1.2), color: Colors.grey))
              //   ]
              // ),
              trailing: IconButton(icon: Icon(LineIcons.ellipsis_v), onPressed: ()=>_settingModalBottomSheet(context,notificacion)),
              onTap: (){},                
            ),

            Text(new DateFormat.EEEE('es').add_MMMMd().format(myDatetime) + " a las: "+new DateFormat.jm().format(myDatetime),style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w900, fontSize: responsive.ip(1.2), color: Colors.grey))
          ],
        ), 
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

  _leading(String tipo){
    if(AppConfig.type_notifications.contains(tipo)){
      return Container(
      child:  Stack(       
        alignment: Alignment.center,           
        children: <Widget>[
          Icon(Icons.brightness_1,color:Colors.green[100],size: 50,),
          SvgPicture.asset('assets/icon/$tipo.svg',
            height: 35,
            width: 35,
          ),
        ],
      ),
    );
    }
    return Container(  
      height: 50,
      width: 50,
      child: Icon(LineIcons.leaf, color: Theme.of(context).primaryColor,size: 40.0,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100), 
        color: Colors.green[100],
      ), 
    );   
  }


  void _settingModalBottomSheet(context,notification){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
          return Container(
            child: new Wrap(
            children: <Widget>[
            new ListTile(
            leading: new Icon(LineIcons.trash),
            title: new Text('Eliminar',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
            onTap: () => 
              _notificationBloc.deleteNotification(notification)
                     
          ),
          
            ],
          ),
          );
      }
    );
}
}