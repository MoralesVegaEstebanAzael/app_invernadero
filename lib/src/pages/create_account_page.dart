import 'package:after_layout/after_layout.dart';
import 'package:app_invernadero/src/animation/fade_animation.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:app_invernadero/src/widgets/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}


class _CreateAccountPageState extends State<CreateAccountPage> with AfterLayoutMixin {
  
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
            _portrait(responsive)
            :
            _landscape(responsive)
        ),
      )
    );
  }
  Widget _landscape(Responsive responsive){
    return Row(
      children: <Widget>[
        Expanded(child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child:Container(
            padding: EdgeInsets.only(left:20),
            height:responsive.height,
            child: Center(
              child: _welcome(),
              )
          )
        )),
        Expanded(child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left:20),
            height: responsive.height,
            child: Center(child:_registerForm()),
          ),
        ))
      ],
    );
  }

  Widget _portrait(Responsive responsive) {
    return SingleChildScrollView(
      child: Container(
        height: responsive.height,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _welcome(),
          _registerForm()
        ],),
      ),
    );
  }

  Widget _welcome(){
    return Welcome(
      title:'Crear cuenta',
      imgPath: 'assets/images/create_account.svg',
       widthPercent: 0.30,
      heightPercent: 0.68,
      topPercent:0.19
    );
  }
  
  Widget _registerForm(){
    final Responsive responsive = Responsive.of(context);
    return SafeArea(
        top: false,
        child: Container(
        width: 330,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children:<Widget>[
             CupertinoTextField(
              padding: EdgeInsets.symmetric(vertical:5,horizontal:10),
              prefix: Container(
                width: 40,
                height: 30,
                child: Icon(LineIcons.user,color: Color(0xFFCCCCCC),),
              ),
              placeholder: "Nombre",
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width:1,
                    color: Color(0xffdddddd)
                  )),
              ),
            ),
            SizedBox(height:responsive.ip(2)),
            CupertinoTextField(
              padding: EdgeInsets.symmetric(vertical:5,horizontal:10),
              prefix: Container(
                width: 40,
                height: 30,
                child: Icon(LineIcons.mobile,color: Color(0xFFCCCCCC),),
              ),
              placeholder: "Teléfono",
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width:1,
                    color: Color(0xffdddddd)
                  )),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly]
            ),
            SizedBox(height:responsive.ip(2)),
           
            CupertinoTextField(
              padding: EdgeInsets.symmetric(vertical:5,horizontal:10),
              prefix: Container(
                width: 40,
                height: 30,
                child: Icon(LineIcons.key,color: Color(0xFFCCCCCC),),
              ),
              placeholder: "Contraseña",
              obscureText: true,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width:1,
                    color: Color(0xffdddddd)
                  )),
              ),
            ),

            SizedBox(height:responsive.ip(2)),
             CupertinoTextField(
              padding: EdgeInsets.symmetric(vertical:5,horizontal:10),
              prefix: Container(
                width: 40,
                height: 30,
                child: Icon(LineIcons.key,color: Color(0xFFCCCCCC),),
              ),
              placeholder: "Contraseña(repetir)",
              obscureText: true,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width:1,
                    color: Color(0xffdddddd)
                  )),
              ),
            ),
             SizedBox(height:responsive.ip(5)),
            
            RoundedButton(
              label: "Registrar",
              onPressed: (){},
            ),
            SizedBox(height:responsive.ip(5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                Text("¿Ya tienes una cuenta?",),
                CupertinoButton(
                  child: Text("Iniciar",style: TextStyle(fontWeight: FontWeight.bold,color:miTema.accentColor),), 
                  onPressed: ()=>Navigator.pushReplacementNamed(context, 'login'),)
              ]
            ),
           
          ]
        ) ,
      ),
    );
  }  
}