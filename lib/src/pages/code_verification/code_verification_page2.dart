
import 'package:after_layout/after_layout.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


class CodeVerificationPage2 extends StatefulWidget {
  @override
  _CodeVerificationPageState createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage2> with AfterLayoutMixin{
  String currentText = "";

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
                    Text("Ingresa el código enviado a ",
                      style: TextStyle(color:Color(0xffbbbbbb),),
                      textAlign: TextAlign.center,
                    ),
                    
                    Padding(
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
                          currentText = value;
                          print("Value: " + value);
                        });
                        },
                      ),
                    ),
                    SizedBox(height: responsive.ip(2),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget>[
                        Text("¿No recibiste el código?",),
                        CupertinoButton(
                          child: Text("REENVIAR",style: TextStyle(fontWeight: FontWeight.bold,color:miTema.accentColor),), 
                          onPressed: ()=>Navigator.pushReplacementNamed(context, 'code_verification_1'),)
                      ]
                    ),
                    SizedBox(height: responsive.ip(2),),  
                    RoundedButton(label: "Verificar", onPressed: (){})
                ],),
              ),
            )
        ),
      )
    ); 
  }
}