
import 'package:after_layout/after_layout.dart';
import 'package:app_invernadero/src/animation/fade_animation.dart';
import 'package:app_invernadero/src/blocs/login_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/providers/user_provider.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/input_password.dart';
import 'package:app_invernadero/src/widgets/input_text.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:app_invernadero/src/widgets/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with AfterLayoutMixin{
  final _authAPI = UserProvider();
  final _formKey = GlobalKey<FormState>();
  // @override
  // void initState(){
  //   super.initState();
  //   // SystemChrome.setSystemUIOverlayStyle(
  //   //   SystemUiOverlayStyle.dark
  //   // );




  @override
  void afterFirstLayout(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide>=600;
    if(!isTablet){
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
  
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
          child: MediaQuery.of(context).orientation == Orientation.portrait ?
             SingleChildScrollView(
                  child: Container(
                    height: responsive.height,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _welcome(),
                      _loginForm(),
                    ],),
                  ),
                )
                :
                Row(
                  children: <Widget>[
                    Expanded(child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child:Container(
                        padding: EdgeInsets.only(left:20),
                        height:responsive.height,
                        child: _welcome(),)
                      )
                    ),
                    Expanded(child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(left:20),
                        height: responsive.height,
                        child: Center(child: _loginForm()),
                      ),
                    ))
                  ],
                )
        ),
      )
    );
  }
  
   _login(BuildContext context,LoginBloc bloc){
      print('Teléfono:${bloc.telefono}');
      print('Password:${bloc.password}'); 

     
    // final isOk = await _authAPI
    // .login(context, telefono: bloc.telefono, password: bloc.password);

    // if(isOk) print("Login correcto");

    //Navigator.pushReplacementNamed(context, 'home');


   // _formKey.currentState.validate();
  }

  _noLogin()=>print("campos incorrectos");



  Widget _loginForm(){
    final bloc = Provider.of(context);
    final Responsive responsive = Responsive.of(context);
    return Container(
    width: 330,
    child: Form(
        key: _formKey,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children:<Widget>[
          StreamBuilder(
            stream: bloc.telefonoStream,
            builder: (BuildContext context,AsyncSnapshot snapshot){
            return InputText(
              placeholder: 'Teléfono',
              validator: (String text){
                
              },
              inputType: TextInputType.phone,
              icon: LineIcons.mobile_phone,
              onChange: bloc.changeTelefono,
              counterText: snapshot.data,
              errorText: snapshot.error,
            );
          }),
          SizedBox(height:responsive.ip(2)),
          // TODO: contraseña
          StreamBuilder(
            stream: bloc.passwordStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return InputPassword(
                placeholder: "Contraseña",
                
                onChange: bloc.changePassword,
                counterText: snapshot.data,
                errorText: snapshot.error,
              );
            },
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: CupertinoButton(
              padding: EdgeInsets.symmetric(vertical:15),
              child: Text("Olvide mi contraseña",style: TextStyle(color:miTema.accentColor),), 
              onPressed: (){}),
          ),
          
          StreamBuilder(
            stream: bloc.formValidStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return RoundedButton(
                label: "Ingresar",
                onPressed:snapshot.hasData?()=>_login(context,bloc):()=>_noLogin,
              );
            },
          ),
          SizedBox(height:responsive.ip(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Text("¿No tienes una cuenta?",),
              CupertinoButton(
                child: Text("Crear",style: TextStyle(fontWeight: FontWeight.bold,color:miTema.accentColor),), 
                onPressed: ()=>Navigator.pushReplacementNamed(context, 'create_account'),)
            ]
          ),
        ]
      ),
    ) ,
      );
  }



  Widget _welcome() {
    return  Welcome(
      title:'Invernadero Sebastián Atoyaquillo',
      imgPath: 'assets/images/farms.svg',
      widthPercent: 0.30,
      heightPercent: 0.68,
      topPercent:0.21
    );
  }


}