
import 'package:after_layout/after_layout.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/countdown_base.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexmo_verify/basemodel.dart';
import 'package:nexmo_verify/model/nexmo_response.dart';
import 'package:nexmo_verify/nexmo_sms_verify.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../app_config.dart';


class PinCodePage extends StatefulWidget {
  //String mobileNumber;
  
  PinCodePage();//this.mobileNumber);
  @override
  _PinCodePageState createState() => _PinCodePageState();//this.mobileNumber);
}
  
class _PinCodePageState extends State<PinCodePage> with AfterLayoutMixin{
  String _pinCode = "";
  bool _isLoading = false;
  bool _isResendEnable = false;
  bool _cancel=false;

  String otpWaitTimeLabel = "";
  bool _isMobileNumberEnter = false;
  String mobileNumber;  

  
  NexmoSmsVerificationUtil _nexmoSmsVerificationUtil;

  _PinCodePageState();//this.mobileNumber);

  @override
  void initState() {
    super.initState();

    startTimer();

    _nexmoSmsVerificationUtil = NexmoSmsVerificationUtil();
    _nexmoSmsVerificationUtil.initNexmo(AppConfig.nexmo_api_key,AppConfig.nexmo_secret_key);
  }

  bool isVerified = false;


   @override
  void dispose() {
    super.dispose();
    _cancel=true;
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
    final String mobileNumber = ModalRoute.of(context).settings.arguments;
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
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    AspectRatio(
                      aspectRatio: 16/8,
                      child: LayoutBuilder(
                        builder:(_,contraints){
                          return Container(
                            
                            child:  SvgPicture.asset('assets/images/verify_screen/enter_code.svg',
                              height: contraints.maxHeight*.4,
                              width: contraints.maxWidth,
                            ),
                          );
                        }
                      )
                    )   ,
                    SizedBox(height: responsive.ip(3),),
                    Text("Código de verificación",style: TextStyle(fontSize:30.0,fontWeight:FontWeight.bold),),
                    SizedBox(height: responsive.ip(2),),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal:10.0),
                      child: Text("El código de verificación se ha enviado al: $mobileNumber",
                        textWidthBasis: TextWidthBasis.longestLine, 
                       style: TextStyle(color:Color(0xffbbbbbb),),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height:responsive.ip(1)),
                    _inputBox(),
                    SizedBox(height: responsive.ip(1),),

                    //timer label
                    Text(
                        otpWaitTimeLabel,
                        style: TextStyle( fontWeight: FontWeight.w700),
                    ),


                    SizedBox(height: responsive.ip(1),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget>[
                        Text("¿No recibiste el código?",),
                        CupertinoButton(
                          child: Text("REENVIAR",style: TextStyle(fontWeight: FontWeight.bold, 
                          color: _isResendEnable? miTema.accentColor:Color(0xffbbbbbb)),), 
                          onPressed: _isResendEnable?_resendOtp:null,)
                      ]
                    ),
                    SizedBox(height: responsive.ip(2),),  
                    RoundedButton(
                      label: "Siguiente", 
                      onPressed:
                      (_pinCode.length<4 || _isResendEnable)
                      ? null
                      :_submit)
                ],),
              ),
            )
        ),
      )
    ); 
  }

  
  
  _submit(){
    //enviar codigo de verificación para validar
    /*if(_pinCode.length==4){
      print("current: " + _pinCode);
       showLoader();
      _nexmoSmsVerificationUtil
          .verifyOtp(_pinCode)
          .then((dynamic res) {
            
          NexmoResponse nr = (res as BaseModel).nexmoResponse;
          print("Estado de respuesta al enviar codigo: " + nr.status);
            
          if(nr.status=='0'){
              //  
            closeLoader();
            isVerified = true;
            _cancel=true;
            print("*********************cancelando timer**********");
            Navigator.pushReplacementNamed(context, 'code_verification_3');
           }
          
          });
    }else{
     print("codigo incompleto");
    }  */ 
    
    print("submit");

  }




  //solicitar nuevo codigo de verificación
  void _resendOtp() {
    if (_isResendEnable) {
     //_nexmoSmsVerificationUtil.resentOtp();
     
     restarTimer();
     print("enviando codigo de verificacion");
    }else{
      print("aun no se puede solicitar un nuevo codigo");
    }
  }

  //**timer **/
  void startTimer() {
     print("|start timer....");
    setState(() {
      _isResendEnable = false;
    });

    var sub = CountDown(new Duration(minutes: 5)).stream.listen(null);
   
    sub.onData((Duration d) {
      if(!_cancel){
              setState(() {
        int sec = d.inSeconds % 60;
        otpWaitTimeLabel = d.inMinutes.toString() + ":" + sec.toString();
        print("timer ejecutandose....");
      });
      }else{
        sub.cancel();

      }

    });


    sub.onDone(() {
      setState(() {
        _isResendEnable = true;
      });
    });
  }

  void restarTimer(){
    if(_isResendEnable){

      startTimer();
      _isResendEnable=false;
    }
  }
 
  Widget _inputBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:40),
      child: PinCodeTextField( 
        length: 4,
        obsecureText: false,
        animationType: AnimationType.fade,
        shape: PinCodeFieldShape.underline,
        animationDuration: Duration(milliseconds: 300),
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        selectedColor: miTema.accentColor,
        inactiveColor: Colors.grey,
        onChanged: (value) {
        setState(() {
          _pinCode = value; 
        });
        },
        
      ),
    );
  }
}