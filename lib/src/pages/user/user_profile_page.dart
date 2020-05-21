import 'package:app_invernadero/src/blocs/login_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/userModel.dart';
import 'package:app_invernadero/src/providers/menu_provider.dart';
import 'package:app_invernadero/src/providers/user_provider.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/icon_string_util.dart';
import 'package:app_invernadero/src/utils/responsive.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';


class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  UserProvider userProvider = UserProvider();
  SecureStorage storage = new SecureStorage();
   
  bool _blockCheck=true;
  bool _isLoading=false;
  IconData _switch = LineIcons.toggle_on;
  Future<List<dynamic>> options;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    options =  menuProvider.loadData();

  
  }
  @override
  Widget build(BuildContext context) {
    LoginBloc userBloc = Provider.of(context);
    userBloc.cargarUsuario();

    final responsive = Responsive.of(context);
    return Scaffold(
      backgroundColor: Color(0XFFEEEEEE),
      body: Container( 
        
        height: responsive.height,
        child: Stack(
          children:<Widget>[
            Positioned(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal:10),
                child: Column(
        children: <Widget>[
          SafeArea(
                child: AspectRatio(
                aspectRatio: 16/5,
                child: LayoutBuilder(
                  builder:(_,contraints){
                    return _header(contraints, context, userBloc);
                  }
                )
            ),
          ) ,
          SizedBox(height: responsive.ip(2),),
          Container(
            decoration: BoxDecoration(
                color : Colors.white,
                borderRadius: BorderRadius.circular(2.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color:Colors.black26,
                    blurRadius: 3.0,
                    offset : Offset(0.0,5.0),
                    spreadRadius: 1.0
                  )
                ]
            ),

            
            child: _options(),),

          SizedBox(height: responsive.ip(2),),  
          Expanded(
            child: Container(
                color: Color(0XFFEEEEEE),
                child: Column(
                  children:<Widget>[
                    

                       SvgPicture.asset('assets/images/logo_app.svg',
                     
                        height: 50,
                      ),

                      Text(
                      "Invernadero Sebastián  Atoyaquillo",
                      style: TextStyle(color: Colors.grey)
                      ),
                  ]
                ),  
            )
          )

        ],),
              ),),

        Positioned.fill(
         child: _isLoading? Container(  
          color:Colors.black45,
          child: Center(
            child:SpinKitCircle(color: miTema.accentColor),
          ),
        ):Container()),
          ]
        )
      ),
     
      
    ); 
  }

  Widget _header(BoxConstraints contraints, BuildContext context, LoginBloc userBloc )  {     
    return Container( 
      margin: EdgeInsets.only(top:15),
      decoration: BoxDecoration(
        color: miTema.accentColor,
        borderRadius: BorderRadius.circular(5.0)
      ),
      child: StreamBuilder(
        stream: userBloc.userStream, 
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot){
           if (snapshot.hasData) {
            final user = snapshot.data;            
            return _datosUser(contraints, user);
          }else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _datosUser(BoxConstraints contraints, UserModel user){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        /* SvgPicture.asset('assets/icon/user.svg',                  
          height: contraints.maxHeight*.6,
         ), */        
        _mostrarFoto(user, contraints),

        Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[ 
            Text( (user.name == null || user.name == "") ?  'Nombre de usuario' : user.name, overflow: TextOverflow.ellipsis ,style: TextStyle(fontWeight: FontWeight.w500  , color:Colors.white,fontSize: 18, )),
             Divider(), 
            Text( (user.email == null || user.email == "") ? 'email@noemail' : user.email, overflow: TextOverflow.ellipsis ,style: TextStyle(color:Colors.white)),
 
           ],
        ),  
        
        IconButton(
          icon: Icon(Icons.create, size: 30.0),  
          color: Colors.white,
          onPressed: ()=> Navigator.pushNamed(context, 'user_detalle', arguments: user))
       /* FlatButton(  
          onPressed: () => {
             Navigator.pushNamed(context, 'user_detalle', arguments: user),
          },
          child: Text("Edit" ,style: TextStyle(color:Colors.white)),
        ),*/
      ],
    );
  }  

 _mostrarFoto(UserModel user, BoxConstraints contraints){
   if(user.urlAvatar == null || user.urlAvatar == ""){      
      return  SvgPicture.asset('assets/icon/user.svg',                  
          height: contraints.maxHeight*.6);
    }else {   
    return Container( 
          child:  ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              height: contraints.maxHeight*.6,
              width: contraints.maxHeight*.6,
              child: FadeInImage(
              image: NetworkImage(user.urlAvatar),
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
        title: Text(opt['texto']),
        leading: getIcon(opt['icon']),
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
        _switch = LineIcons.toggle_off;
        });
  }

  _logOut()async{
    if(_isLoading)return;
    setState(() {
        _isLoading=true;
    });

    Map info = await userProvider.logout();
    setState(() {
      _isLoading=false;
    });

    if(info['ok']){
      //inicio de sesión
      Navigator.pushReplacementNamed(context, 'login_phone');
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
}

