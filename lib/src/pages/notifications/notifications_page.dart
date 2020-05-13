import 'package:app_invernadero/src/widgets/place_holder.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key}) : super(key: key);
  
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:PlaceHolder(
        img: 'assets/images/empty_states/empty_notifications.svg',
        title: 'No tienes notificaciones',
      ),
    );
  }
}