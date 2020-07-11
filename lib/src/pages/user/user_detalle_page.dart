import 'dart:io';
import 'package:app_invernadero/src/blocs/client_bloc.dart'; 
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/client_model.dart'; 
import 'package:app_invernadero/src/theme/theme.dart'; 
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/my_appbar.dart'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';  

class UserDetallePage extends StatefulWidget { 
  @override
  _UserDetallePageState createState() => _UserDetallePageState();
}

class _UserDetallePageState extends State<UserDetallePage> {
  
  final TextStyle _style =  TextStyle(color:Colors.grey,fontSize:16,fontFamily: 'Quicksand',fontWeight: FontWeight.w500);
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>(); 
 
  ClientModel user;
  File foto;

  ClientBloc clientBloc;
  Responsive responsive;
 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies(); 

    clientBloc = Provider.clientBloc(context);
    responsive = Responsive.of(context); 

    //user = ModalRoute.of(context).settings.arguments;  
  }

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Editar datos"),  
      body: Container(   
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child:  StreamBuilder(
        stream: clientBloc.userStream,
        builder: (BuildContext context, AsyncSnapshot<ClientModel> snapshot){
           if (snapshot.hasData) {
            user = snapshot.data;

            return Column(
              children: <Widget>[ 
                 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Datos personales", style:TextStyle(fontFamily: 'Quicksand',fontSize:responsive.ip(2),color:Color(0xFF545D68))),
                    Text("* Campos obligatorios", style:TextStyle(fontFamily: 'Quicksand',fontSize:responsive.ip(1.5),color:Colors.grey)),
                  ],
                ),
                SizedBox(height:5),
                SizedBox(height:responsive.ip(1)),
                Expanded(
                  child: _myListView(context),
                ),
                
            ],
          );
          }else { 
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    ),
    );
  }

  Widget _myListView(BuildContext context) {
    TextStyle _styleTitle = TextStyle(fontSize:18,fontFamily: 'Quicksand',fontWeight: FontWeight.w600);
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,      
        children: ListTile.divideTiles(
        context: context, 
        tiles: [
            ListTile(
              title: Text('Nombre', style: _styleTitle ),
              subtitle: Text('${user.nombre}',style: _style),
              trailing: Icon(LineIcons.angle_right,color:Colors.grey),
              onTap: ()=> Navigator.pushNamed(context, 'detalleDatosUpdate', arguments: ['nombre',user]),
            ),
            ListTile(
              title: Text('Apellido Paterno',style: _styleTitle),
              subtitle: Text('${user.ap}',style: _style),
              trailing: Icon(LineIcons.angle_right,color:Colors.grey),
              onTap: ()=> Navigator.pushNamed(context, 'detalleDatosUpdate', arguments: ['ap',user]),
            ),
            ListTile(
              title: Text('Apellido Materno',style: _styleTitle),
              subtitle: Text('${user.am}',style: _style),
              trailing: Icon(LineIcons.angle_right,color:Colors.grey),
              onTap: ()=> Navigator.pushNamed(context, 'detalleDatosUpdate', arguments: ['am',user]),
            ),
             ListTile(
              title: Text('RFC',style: _styleTitle),
              subtitle: Text('${user.rfc}',style: _style),
              trailing: Icon(LineIcons.angle_right,color:Colors.grey),
              onTap: ()=> Navigator.pushNamed(context, 'detalleDatosUpdate', arguments: ['rfc',user]),
            ),
          ],
        ).toList(),
      );
    }
}