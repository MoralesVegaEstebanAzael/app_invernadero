import 'package:app_invernadero/src/blocs/login_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/user_model.dart';
import 'package:app_invernadero/src/providers/user_provider.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/input_password.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class LoginPasswordPage extends StatefulWidget {
  @override
  _LoginPasswordPageState createState() => _LoginPasswordPageState();
}


class _LoginPasswordPageState extends State<LoginPasswordPage> {
  UserProvider userProvider = UserProvider();
  LoginBloc bloc;
  SecureStorage _prefs = SecureStorage();
  final TextStyle _style =  TextStyle(color:Colors.grey,fontSize:18);
  bool _isLoading=false;
  User _user;
  

  @override
  void initState() {
    super.initState();
    _prefs.route = 'login_password';
    _user = _prefs.user;
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    Responsive responsive = Responsive.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Container(
          color: Colors.white,
          width: double.infinity,
          height:double.infinity,
          child:
            SingleChildScrollView( 
              child: Container(
               
                height: responsive.height,
                child: SafeArea(
                  child: Stack(
                    children: <Widget>[
                    Positioned(
                        child:Padding( padding: EdgeInsets.symmetric(horizontal:20,vertical:20),
                         child:  _content(responsive) 
                        )
                    ),  

                    _isLoading? Positioned.fill(child:  Container(
                      color:Colors.black45,
                      child: Center(
                        child:SpinKitCircle(color: miTema.accentColor),
                      ),
                    )):Container(),
                    ],
                  )
                ),
              ),
            )     
        ),
      )
    );
  }

  Widget _content(Responsive responsive){
    bloc = Provider.of(context);
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Ingresa tu contraseña",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400
        ),),

        SizedBox(height:responsive.ip(5)),
        Text("Contraseña",style:_style),
        SizedBox(height:responsive.ip(2)),
        Text("Inicia sesión con tu contraseña de SA invernadero",
          style: TextStyle(color:Colors.grey),),
        SizedBox(height:responsive.ip(5)),
        StreamBuilder(
            stream: bloc.passwordStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return InputPassword(
                onChange: bloc.changePassword,
              );
            },
          ),

        SizedBox(height:responsive.ip(4)),

        Container(
          alignment: Alignment.center,
          child: CupertinoButton(
            padding: EdgeInsets.symmetric(vertical:15),
            child: Text("Olvide mi contraseña",style: TextStyle(color:miTema.accentColor),), 
            onPressed: ()=>_forgotPassword()),
        ),


        Expanded(
          child: StreamBuilder(
            stream: bloc.passwordStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return  Center(
              child: RoundedButton(
                label: "Confirmar", 
                onPressed: snapshot.hasData?()=>_submit(context,bloc) : null)
              );
            },
          ),
            
        )
      ],);
  }

  _forgotPassword(){
     Navigator.pushReplacementNamed(context, 'pin_code',arguments: _user.phone);
  }
  
  _submit(BuildContext context,LoginBloc bloc)async{
    if(_isLoading)return;

    if (bloc.password.isNotEmpty) {
     
      setState(() {
        _isLoading=true;
      });
      
      Map info = await userProvider.login(telefono: _user.phone,password: bloc.password);
      
      setState(() {
        _isLoading=false;
      });   
      
      if(info['ok']){
        if(_user.name==null){
          Navigator.pushReplacementNamed(context, 'config_account');
        }else{
          Navigator.pushReplacementNamed(context, 'home');
        }
      }else{
        //Navigator.pushNamed(context, 'pin_code',arguments: AppConfig.nexmo_country_code+_telefono);
        print("contraseña incorrecta");  
        Flushbar(
        backgroundColor: Colors.black45,
        icon: Icon(
        Icons.close,
        size: 28.0,
        color: Colors.red,
        ),
        margin: EdgeInsets.all(4),
        borderRadius: 5,
        message:   "Contraseña incorrecta",
        duration:  Duration(seconds:1),              
      )..show(context);
      }
    }
  }


}