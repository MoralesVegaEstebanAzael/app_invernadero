import 'dart:io';

import 'package:app_invernadero/src/blocs/client_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/client_model.dart';
import 'package:app_invernadero/src/providers/menu_provider.dart';
import 'package:app_invernadero/src/providers/user_provider.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/icon_string_util.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}



class _ProfilePageState extends State<ProfilePage> {
  ClientBloc clientBloc;
  Responsive _responsive;
  UserProvider userProvider = UserProvider();
  
  bool _blockCheck=true;
  bool _isLoading=false;
  IconData _switch = LineIcons.toggle_on;
  Future<List<dynamic>> options;
  File foto;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _responsive = Responsive.of(context);
    clientBloc = Provider.clientBloc(context);
    clientBloc.getClient(); 
    options =  menuProvider.loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          SafeArea(
          child: Container(
            margin: EdgeInsets.only(left:10,right:10),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
                      child: Column(
              children:<Widget>[
                _header(),
                SizedBox(height:_responsive.ip(2)),
                Container(
                  margin: EdgeInsets.only(left:40,right:40),
                  height:_responsive.ip(0.1),
                  color:Colors.grey[300]
                ),
                SizedBox(height:_responsive.ip(2)),
                _options()
               ]
             ),
          )
        ),
      ),
       _isLoading ? Positioned.fill(child:  Container(
                    color:Colors.black45,
                    child: Center(
                      child:SpinKitCircle(color: miTema.accentColor),
                    ),
                  ),):Container()
        ],
      )
    );
  }

  

  _header(){
    return Container( 
     // margin: EdgeInsets.only(top:15),
      // decoration: BoxDecoration(
      //   color: miTema.accentColor,
      //   borderRadius: BorderRadius.circular(5.0)
      // ),
      child: StreamBuilder(
        stream: clientBloc.userStream,
        builder: (BuildContext context, AsyncSnapshot<ClientModel> snapshot){
           if (snapshot.hasData) {
            final user = snapshot.data; 
            return  _datosUser( user);
          }else { 
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  
  Widget _datosUser(ClientModel user){
    return Container(
      margin: EdgeInsets.only(top:_responsive.ip(2)),
      width: double.infinity,
      child: ListTile(
        title:Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children:<Widget>[
            Column(
              children: <Widget>[
                _mostrarFoto(user),
                (user.nombre!=null && user.ap!=null)
                  ?
                  Text("${user.nombre} ${user.ap}", style: TextStyle( fontFamily:'Quicksand',fontWeight: FontWeight.w900),)
                  :
                  Container(),
                SizedBox(
                  height: _responsive.ip(1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[
                  Icon(Icons.location_on,color:Colors.grey,size: _responsive.ip(2),),
                  SizedBox(width:_responsive.ip(1)),
                  (user.direccion!=null)
                  ?
                  Container(
                    width: _responsive.ip(22),
                    child: Text("${user.direccion}",overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: _responsive.ip(1.2), fontFamily:'Quicksand',fontWeight: FontWeight.w900,color: Colors.grey),),
                  )
                  :
                  Container()
                  ]
                )
              ],
            ),
          ]
        ), 
        trailing: IconButton(
          icon:Icon(LineIcons.ellipsis_v,size: _responsive.ip(3),color: Colors.black,) , 
          onPressed: ()=> _settingModalBottomSheet(context,user)),
      ),
    );

    
  }  


  _mostrarFoto(ClientModel user){
   if(user.urlImagen == null || user.urlImagen == ""){      
      return  SvgPicture.asset('assets/icon/user.svg',                  
          height: _responsive.ip(10));
    }else {   
    return Container( 
          child:  ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              height: _responsive.ip(10),
              width:_responsive.ip(10),
              child: FadeInImage(
              image: NetworkImage(user.urlImagen),
              placeholder: AssetImage('assets/jar-loading.gif'), 
              fit: BoxFit.fill,
             ),
            ),
          )
     );
    }
 } 
  Widget _options() {
    return FutureBuilder(
      future:options,
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      return Column(
        children: _listItems(snapshot.data),
      );
      },
    );

    
  }

  List<Widget> _listItems(List<dynamic> data){
    final List<Widget> opciones=[];
    data.forEach((opt){
      final widgetTemp = 
      Container(
        
        padding: EdgeInsets.symmetric(horizontal:5),    
        child:  ListTile(
        title:  Text(opt['texto'],
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                    fontSize: _responsive.ip(1.8)
                  ),
                  ),
        subtitle: Text(opt['subtitulo'],
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                    fontSize: _responsive.ip(1.3)
        ),),
        leading: getIcon(opt['icon'],_responsive),
        trailing:opt['texto']=='Notificaciones'? 
            Icon(_switch, size: 40,color:miTema.primaryColor) 
            : Icon(LineIcons.angle_right,color:Colors.grey),
        onTap: (){
          _opciones(opt['ruta']);
        },
      )
      );

      opciones..add(widgetTemp)..add(Container(
      padding: EdgeInsets.symmetric(horizontal:5),  
                      height: 2,
                      color: Color(0xFFEEEEEE),
                    ),);//..add(Divider());
    });
    return opciones;
  } 

  _notifications(){


    setState(() {
          _blockCheck=!_blockCheck;
          _blockCheck?
        _switch = LineIcons.toggle_on
        :
        _disableNotification();
        });
  }

  _disableNotification(){
    _showDialog();
  }

  _logOut()async{
    if(_isLoading)return;
    setState(() {
        _isLoading=true;
        //_statusBar();
    });

    Map info = await userProvider.logout();
    setState(() {
      _isLoading=false;
    });

    if(info['ok']){
      //inicio de sesión
      Navigator.pushReplacementNamed(context, 'login_phone');
     //Navigator.pop(context);
    }else{
      print("ERROR LOGOUT");
    }
  } 
  _opciones(String route){
    switch (route) {
        case 'notificaciones':  
          _notifications();
        break;
        case 'logout':
          _logOut();
        break;
        default:
        Navigator.pushNamed(context, route);
    }
  }

  void _settingModalBottomSheet(context,user){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: new Wrap(
          children: <Widget>[
            new ListTile(
              leading: new Icon(LineIcons.edit),
              title: new Text('Editar',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
              onTap: () { 
                 _procesarImagen(user);  
                Navigator.pop(context);
              },
            ),
            ],
           ),
        );
      }
    );
  } 

  _procesarImagen(ClientModel user) async{
    ImageSource origen = ImageSource.gallery;
    foto = await ImagePicker.pickImage(
      source: origen
    ); 
    if(foto != null){ 
      user.urlImagen = null; //limpieza para redibujar la nueva foto
    }  
    setState(() {
     _guardarImagen(user);  
    }); 
  }

  _guardarImagen(ClientModel user) async{ 

    if (foto != null) {
      
      setState(() {
        _isLoading=true;
      });

      user.urlImagen = await clientBloc.subirFoto(foto);
      print("++++++++++++++++++++++++++++");
      print(user.urlImagen);
      clientBloc.updateImagen(user.urlImagen);
      print("------------------------");
      clientBloc.updatePhoto(user);  

       setState(() {
        _isLoading=false;
      });
       
    }
    
  }

   void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Notificaciones",
            style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w900),),
          content: new Text("¿Estas seguro de desactivar las notificaciones?",
            style: TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w500),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Aceptar",style: TextStyle(color:miTema.accentColor),),
              onPressed: () {
                 _switch = LineIcons.toggle_off;
                 
                Navigator.of(context).pop();

                setState(() {
                  
                });
              },
            ),

            new FlatButton(
              child: new Text("Cancelar",style: TextStyle(color:miTema.accentColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
 
}