import 'package:after_layout/after_layout.dart';
import 'package:app_invernadero/src/providers/user_provider.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/widgets/mask_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nexmo_verify/basemodel.dart';
import 'package:nexmo_verify/model/nexmo_response.dart';
import 'package:nexmo_verify/nexmo_sms_verify.dart';
import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/blocs/login_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/input_text.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';

class LoginPhonePage extends StatefulWidget  {
  @override
  _LoginPhonePageState createState() => _LoginPhonePageState();
}

class _LoginPhonePageState extends State<LoginPhonePage> with AfterLayoutMixin {
  UserProvider userProvider = UserProvider();
  String _telefono='';
  var textEditingController = TextEditingController();
  var maskTextInputFormatter = MaskTextInputFormatter(mask: "(###) ###-##-##", 
  filter: { "#": RegExp(r'[0-9]') });
  NexmoSmsVerificationUtil _nexmoSmsVerificationUtil;
  bool _isLoading=false;

  @override
  void initState() {
    super.initState();
    _nexmoSmsVerificationUtil = NexmoSmsVerificationUtil();
    _nexmoSmsVerificationUtil.initNexmo(AppConfig.nexmo_api_key, AppConfig.nexmo_secret_key);
    
  }

  @override
  void dispose() {
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
    final bloc = Provider.of(context);
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
    /** BUSCAR TELEFONO ATRAVES DE LA API 
     * SI EXISTE 
     *  LANZAR LOGIN_PASSWORD_PAGE
     *  ->OLVIDE MI CONTRASEÑA
     *    -> ENVIAR CODIGO DE VERIFICACIÓN 
     *    ->CONFIGURAR CONTRASEÑA
     * ->HOME
     * SI NO EXISTE
     * LANZAR PIN_CODE_PAGE PARA VERIFICAR NUMERO
     *  ->CONFIGURAR CONTRASEÑA
     *  ->CONFIGURAR DATOS DE USUARIO
     *  ->HOME
     * **/
    if(_isLoading)return;

    if (bloc.telefono.isNotEmpty) {
      setState(() {
        _isLoading=true;
      });

      Map info = await userProvider.buscarUsuario( telefono:AppConfig.nexmo_country_code+ bloc.telefono);
      setState(() {
        _isLoading=false;
      });

      if(info['ok']){
        //inicio de sesión
        Navigator.pushReplacementNamed(context, 'login_password',arguments:AppConfig.nexmo_country_code+ bloc.telefono);
        print("usuario encontrado");
      }else{
        //Navigator.pushNamed(context, 'pin_code',arguments: AppConfig.nexmo_country_code+_telefono);
        print("registrar usuario");  
        //registrarse
        // _telefono=bloc.telefono;
        // _nexmoSmsVerificationUtil
        //   .sendOtp(AppConfig.nexmo_country_code + bloc.telefono, AppConfig.nexmo_business_name)
        //   .then((dynamic res) {
        //     NexmoResponse nr = (res as BaseModel).nexmoResponse;
        //     print("Estado al enviar codigo :"+nr.status);

        //     if(nr.status=='10'){
        //       print("Concurrent verifications to the same number are not allowed");
        //     }else if(nr.status=='0'){
        //       nexmoSuccess( (res as BaseModel).nexmoResponse);
        //     }
        // });
      }

      
    }else{
      print("ingresa tu telefono");
    }

  }
  
  @override
  void nexmoSuccess(NexmoResponse nexmoResponse) {
    Navigator.pushNamed(context, 'pin_code',arguments: AppConfig.nexmo_country_code+_telefono);
    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (BuildContext context) => CodeVerificationPage2(
    //             AppConfig.nexmo_country_code + _telefono)));
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