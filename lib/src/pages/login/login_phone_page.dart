import 'package:after_layout/after_layout.dart';
import 'package:app_invernadero/src/models/user_model.dart';
import 'package:app_invernadero/src/providers/nexmo_sms_verify_provider.dart';
import 'package:app_invernadero/src/providers/twilio_provider.dart';
import 'package:app_invernadero/src/providers/user_provider.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/widgets/mask_text_input_formatter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/blocs/login_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/input_text.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:line_icons/line_icons.dart';

class LoginPhonePage extends StatefulWidget  {
  @override
  _LoginPhonePageState createState() => _LoginPhonePageState();
}

class _LoginPhonePageState extends State<LoginPhonePage> with AfterLayoutMixin {
  UserProvider userProvider = UserProvider();
  
  LoginBloc bloc;
  SecureStorage _prefs = SecureStorage();
  var textEditingController = TextEditingController();
  var maskTextInputFormatter = MaskTextInputFormatter(mask: "(###) ###-##-##", 
  filter: { "#": RegExp(r'[0-9]') });
  User _user; 
  bool _isLoading=false;
  TwilioProvider twilioProvider;
  
 


  @override
  void initState() {
    super.initState();
    _prefs.route = 'login_phone'; //save route
    twilioProvider = TwilioProvider();
   // _nexmoSmsVerifyProvider.initNexmo(AppConfig.nexmo_api_key, AppConfig.nexmo_secret_key);
    _user = User();
   
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
  
  @override
  void afterFirstLayout(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide>=600;
    if(!isTablet){
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  
  @override
  Widget build(BuildContext context) {
    bloc = Provider.of(context);
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
          child: 
             SingleChildScrollView(
              child: Container( 
                height: responsive.height,
                child: Stack(
                  children:<Widget>[
                    Positioned(
                      child: Column(
                
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    _image(),
                    SizedBox(height: responsive.ip(2),),
                    Text("¿Cuál es tu número de teléfono?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize:30.0,
                        fontWeight:FontWeight.bold),
                    ),
                    SizedBox(height: responsive.ip(2),),
                   
                    Text("Ingresa tu numéro de teléfono",
                      style: TextStyle(color:Color(0xffbbbbbb),),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: responsive.ip(4),),
                    _inputText(bloc),


                    
      
                    SizedBox(height: responsive.ip(5),),      
                    _createButon(bloc)
                    ],),),
                     
                    _isLoading? Positioned.fill(child:  Container(
                    color:Colors.black45,
                    child: Center(
                      child:SpinKitCircle(color: miTema.accentColor),
                    ),
                  ),):Container()
                  ]
                )
              ),
            )
        ),
      )
    ); 
  }



  Widget _createButon(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.telefonoStream,
      builder: (BuildContext context,AsyncSnapshot snapshot){
        return RoundedButton(
          label: "Siguiente", 
          onPressed: snapshot.hasData?()=>_submit(context, bloc):null
        );
      }
    );
  }


  _submit(BuildContext context,LoginBloc bloc)async {
    if(_isLoading)return;
    
    if (bloc.telefono.isNotEmpty) {
      setState(() {
        _isLoading=true;
      });

      //SOLICITUD A APIREST
      Map info = await userProvider.buscarUsuario(
         celular:AppConfig.nexmo_country_code+ bloc.telefono);

      setState(() {
        _isLoading=false;
      }); 

      if(info['ok']){ //RESPUESTA API REST USUARIO ENCONTRADO
        String telefono = AppConfig.nexmo_country_code + bloc.telefono;
        
        _user.initUser(
          phone:telefono, 
          registered: '1',
          password: info['password'],
          name:info['nombre'],
          direccion: info['direccion']
        );

        _prefs.user= _user; //save user

        
        if(info['psw']=='0')
          Navigator.pushReplacementNamed(context, 'pin_code');
       /* else if(info['direccion']=='0')
          Navigator.pushReplacementNamed(context, 'newRoute');*/
           //Registrado con datos completos
        else Navigator.pushReplacementNamed(context, 'login_password');

      }else{ //USUARIO NO ENCONTRADO ->registrar
        sendCode(bloc);
      }
    }
  } 


  sendCode(LoginBloc bloc)async{
    final telefono = "52" + bloc.telefono;

    Map info = await twilioProvider.sendCode(
        celular:telefono);
    
    if(info['ok']){ //mensaje enviado
      print("MENSAJE ENVIADO ");
        String telefono = AppConfig.nexmo_country_code + bloc.telefono;

        _user.initUser(
          phone:telefono,
          registered: '0',
          password: '0',
          name: '0',
          direccion: '0'
        );
        //User user =  User(phone:telefono,registered: '0',password: '0',name: '0');
        _prefs.user= _user; //save user
        Navigator.pushNamed(context, 'pin_code');
    }else{
     /// print("ERRROR AL ENVIAR EL MENSAJE: " + info['message']);
      
      Flushbar(
        backgroundColor: Colors.black45,
        icon: Icon(
        Icons.close,
        size: 28.0,
        color: Colors.red,
        ),
        margin: EdgeInsets.all(4),
        borderRadius: 5,
        message:   "Parece que algo ha ido mal",
        duration:  Duration(seconds:1),              
      )..show(context);

    }
    
  }

  Widget _inputText(LoginBloc bloc) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:40),
      child: StreamBuilder(
        
        stream: bloc.telefonoStream,
        builder: (BuildContext context,AsyncSnapshot snapshot){
        return InputText(
          placeholder: 'Teléfono',
          validator: (String text){
          },
          inputType: TextInputType.phone,
          icon: LineIcons.mobile_phone,
          onChange: bloc.changeTelefono,
          errorText: snapshot.error,
          inputFormatters: [maskTextInputFormatter], 
                        autocorrect: false, 
        );
      }),
    );
  }

  
  
  Widget _image() {
    return AspectRatio(
      aspectRatio: 16/8,
      child: LayoutBuilder(
        builder:(_,contraints){
          return Container(
            child:  SvgPicture.asset('assets/images/verify_screen/verify_number.svg',
              height: contraints.maxHeight*.4,
              width: contraints.maxWidth,
            ),
          );
        }
      )
    );
  }
}