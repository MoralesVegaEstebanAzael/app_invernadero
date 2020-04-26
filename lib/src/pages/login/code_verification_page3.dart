import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CodeVerificationPage3 extends StatelessWidget {
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
                            child:  SvgPicture.asset('assets/images/verify_screen/verify_succes.svg',
                              height: contraints.maxHeight*.4,
                              width: contraints.maxWidth,
                            ),
                          );
                        }
                      )
                    )   ,
                        
                    SizedBox(height: responsive.ip(5),),      
                     Text("Tu numéro de celular ha\n sido verificado correctamente",
                      style: TextStyle(color:Color(0xffbbbbbb),),
                      textAlign: TextAlign.center,
                    ),
                     SizedBox(height: responsive.ip(5),),   
                    RoundedButton(label: "Ok", 
                      onPressed: ()=>Navigator.pushReplacementNamed(context, 'code_verification_1'),)
                ],),
              ),
            )
        ),
      )
    ); 
  }
}