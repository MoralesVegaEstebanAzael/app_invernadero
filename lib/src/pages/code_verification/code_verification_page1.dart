import 'package:after_layout/after_layout.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/input_text.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';


class CodeVerificationPage1 extends StatefulWidget  {
  @override
  _CodeVerificationPage1State createState() => _CodeVerificationPage1State();
}

class _CodeVerificationPage1State extends State<CodeVerificationPage1> with AfterLayoutMixin {

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
                            child:  SvgPicture.asset('assets/images/verify_screen/verify_number.svg',
                              height: contraints.maxHeight*.4,
                              width: contraints.maxWidth,
                            ),
                          );
                        }
                      )
                    )   ,
                    SizedBox(height: responsive.ip(2),),
                    Text("Verifica tu número",style: TextStyle(fontSize:30.0,fontWeight:FontWeight.bold),),
                    SizedBox(height: responsive.ip(2),),
                    Text("Ingresa tu numéro de celular\n para verificar tu cuenta",
                      style: TextStyle(color:Color(0xffbbbbbb),),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsive.ip(4),),
                    Container(
                      //margin: EdgeInsets.symmetric(horizontal:10),
                      padding: EdgeInsets.symmetric(horizontal:40),
                      child: InputText(
                        placeholder: "Numéro de celular",
                        inputType: TextInputType.phone,
                        icon: LineIcons.mobile_phone,
                      ),
                    ),         
                    SizedBox(height: responsive.ip(5),),      
                    RoundedButton(label: "Enviar", 
                      onPressed: ()=>Navigator.pushReplacementNamed(context, 'code_verification_2'),)
                ],),
              ),
            )
        ),
      )
    ); 
  }
}