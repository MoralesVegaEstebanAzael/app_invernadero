import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:app_invernadero/src/widgets/place_holder.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:app_invernadero/src/blocs/notification_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/providers/user_provider.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:app_invernadero/src/models/notification_model.dart';  
import 'package:app_invernadero/src/widgets/place_holder.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:line_icons/line_icons.dart'; 
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key}) : super(key: key);
  
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Responsive responsive;
  NotificacionesBloc _notificationBloc;

  Box _notificationsBox;

  @override
  void didChangeDependencies() { 
    _notificationBloc = Provider.notificacionBloc(context) ; 
    _notificationsBox = _notificationBloc.box();

    responsive = Responsive.of(context); 
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
     
  
    return Scaffold( 
      appBar: _appBar(), 
      body: _crearListado(),
      /*PlaceHolder(
        img: 'assets/images/empty_states/empty_notifications.svg',
        title: 'No tienes notificaciones',
      ), */   
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
        IconAction(
          icon:LineIcons.shopping_cart,
          onPressed:()=> Navigator.pushNamed(context, 'shopping_cart')
        )
      ],
    );
  }
 
  Widget _crearListado(){
    return WatchBoxBuilder(
      box: _notificationsBox, 
      builder: (BuildContext context, Box box){
        if(box.length>0){
          return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index){   
                NotificacionModel noti = box.getAt(index);
                return _crearItemSlider(noti, index);
              },
            ) ;
        }
      }
    );
    
    
  /* StreamBuilder(
      stream: notificacionesBloc.notificacionesStream , 
      builder: (BuildContext context, AsyncSnapshot<List<NotificacionModel>> snapshot){
        if(snapshot.hasData){ 
          final notificaciones = snapshot.data;
          
          return ListView.builder(
             itemCount: notificaciones.length,
             itemBuilder: (context, i) => _crearItemSlider(notificaciones[i], i, notificaciones),

          );           
        }else{
          return  PlaceHolder(
            img: 'assets/images/empty_states/empty_notifications.svg',
            title: 'No tienes notificaciones',
          );
        }
      },
    ); */
  }

  Widget _crearListTitle(NotificacionModel notificacion){  
  DateTime myDatetime = DateTime.parse(notificacion.createdAt); 
    return ListTile(
     // hace 15 minutos
          leading: Container( 
            height: 50,
            width: 50,
            child: Icon(LineIcons.leaf, color: Theme.of(context).primaryColor,size: 40.0,),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100), 
              color: Colors.green[300],
            ), 
          ),
          title: Text('${notificacion.data['titulo']}', style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w700, fontSize: 16.0)),
          subtitle: Text('${notificacion.data['mensaje']}', style: TextStyle(fontFamily:'Quicksand', fontWeight: FontWeight.w600)),           
          trailing: Text(timeago.format(myDatetime, locale: 'es'), style: TextStyle(fontFamily:'Quicksand',fontStyle: FontStyle.italic ,fontWeight: FontWeight.w900, fontSize: 9.0, color: Colors.grey)),
           onTap: (){}  //=> notificationBloc.markAsReadNotifications(), 
          
    );
  }

  Widget _crearItemSlider(NotificacionModel notificacion, int index){
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      //dismissal: SlidableDismissal(child: SlidableDrawerDismissal()),      
      child: _crearListTitle(notificacion), 
      secondaryActions: <Widget>[
         IconSlideAction(
          caption: 'Visto',
          color: Colors.green[500],
          icon: LineIcons.eye,          
          //closeOnTap: true,
         
        ),
        IconSlideAction( 
          caption: 'Eliminar', 
          color: Colors.red[400],
          icon: LineIcons.eye_slash,
          closeOnTap: true,
          onTap: (){
            print('se elimina y se  vuelve a cargar');
            setState(() {
             // notificaciones.removeAt(index);
            });
          },
        ), 
      ], 
    );
  }
 

}