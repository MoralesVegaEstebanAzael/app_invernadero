import 'package:app_invernadero/src/blocs/client_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/client_model.dart';
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
  ClientBloc clienteBloc;
  ClientModel _user;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _responsive = Responsive.of(context);
    clienteBloc = Provider.clientBloc(context);
    clienteBloc.getClient(); 
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
        child: StreamBuilder(
        stream: clienteBloc.userStream,
        builder: (BuildContext context, AsyncSnapshot<ClientModel> snapshot){
           if (snapshot.hasData) {
            _user = snapshot.data;

            return Column(
              children: <Widget>[  
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Datos personales", style:TextStyle(fontFamily: 'Quicksand',fontSize:_responsive.ip(2),color:Color(0xFF545D68))),
                    Text("* Campos obligatorios", style:TextStyle(fontFamily: 'Quicksand',fontSize:_responsive.ip(1.5),color:Colors.grey)),
                  ],
                ),
                SizedBox(height:5), 
                Expanded(
                  child: _myListView2(context),
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

  Widget _mylistView(BuildContext context){
    return Column(
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
            ListTile(
              title:  Text("Editar datos",
                        style: TextStyle(
                          color: MyColors.BlackAccent,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: _responsive.ip(2)
              ),), 
              trailing: Icon(LineIcons.angle_right,size: 20,),
              onTap: () => Navigator.pushNamed(context, 'user_detalle'),
            ),
          ]
        );
  }

   Widget _myListView2(BuildContext context) {
    TextStyle _styleTitle = TextStyle(color: MyColors.BlackAccent,fontFamily: 'Quicksand',fontWeight: FontWeight.w700,fontSize: _responsive.ip(2));
    TextStyle _styleSubTitle = TextStyle(fontFamily: 'Quicksand',color: Colors.grey,fontSize: _responsive.ip(1.9));
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,      
        children: ListTile.divideTiles(
        context: context, 
        tiles: [
            ListTile(
              title: Text('Nombre', style: _styleTitle ),
              subtitle: Text('${_user.nombre}',style: _styleSubTitle),
              trailing: Icon(LineIcons.angle_right,color:Colors.grey),
              onTap: ()=> Navigator.pushNamed(context, 'detalleDatosUpdate', arguments: ['nombre',_user]),
            ),
            ListTile(
              title: Text('Apellido Paterno',style: _styleTitle),
              subtitle: Text('${_user.ap}',style: _styleSubTitle),
              trailing: Icon(LineIcons.angle_right,color:Colors.grey),
              onTap: ()=> Navigator.pushNamed(context, 'detalleDatosUpdate', arguments: ['ap',_user]),
            ),
            ListTile(
              title: Text('Apellido Materno',style: _styleTitle),
              subtitle: Text('${_user.am}',style: _styleSubTitle),
              trailing: Icon(LineIcons.angle_right,color:Colors.grey),
              onTap: ()=> Navigator.pushNamed(context, 'detalleDatosUpdate', arguments: ['am',_user]),
            ),
             ListTile(
              title: Text('RFC',style: _styleTitle),
              subtitle: Text('${_user.rfc}',style: _styleSubTitle),
              trailing: Icon(LineIcons.angle_right,color:Colors.grey),
              onTap: ()=> Navigator.pushNamed(context, 'detalleDatosUpdate', arguments: ['rfc',_user]),
            ),
            ListTile(
              title: Text('Correo electrónico',style: _styleTitle),
              subtitle: Text('${_user.correo}',style: _styleSubTitle),
              trailing: Icon(LineIcons.angle_right,color:Colors.grey),
              onTap: ()=> Navigator.pushNamed(context, 'detalleDatosUpdate', arguments: ['email',_user]),
            ),
            ListTile(
              title:  Text("Contraseña", style: _styleTitle),
              subtitle: Text("**********",style: _styleSubTitle,),
              trailing: Icon(LineIcons.angle_right,size: 20,),
            ),
          ],
        ).toList(),
      );
    }
}