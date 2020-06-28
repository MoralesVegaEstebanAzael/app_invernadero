import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  Responsive _responsive;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _responsive = Responsive.of(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Configuración"),
      body: Container(
        margin: EdgeInsets.all(20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children:<Widget>[
            ListTile(
              title:  Text("Contraseña",
                        style: TextStyle(
                          color: MyColors.BlackAccent,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: _responsive.ip(2)
              ),),
              subtitle: Text("**********",
                          style:TextStyle(
                            fontFamily: 'Quicksand',color: Colors.grey,
                            fontSize: _responsive.ip(1.9)
                            ),),
              trailing: Icon(LineIcons.angle_right,size: 20,),
            ),
          ]
        ),
      ),
    );
  }
}