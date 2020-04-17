
import 'package:after_layout/after_layout.dart';
import 'package:app_invernadero/src/animation/fade_animation.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
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
  bool _obscureText=true;
  // @override
  // void initState(){
  //   super.initState();
  //   // SystemChrome.setSystemUIOverlayStyle(
  //   //   SystemUiOverlayStyle.dark
  //   // );

  //   SystemChrome.setPreferredOrientations([
  //       DeviceOrientation.portraitDown,
  //       DeviceOrientation.portraitUp,
  //   ]);
  // }

  // @override
  // dispose(){
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeRight,
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  //   super.dispose();
  // }



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

  Widget _loginForm(){
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
            // TODO: contraseña
            InputPassword(obscureText: _obscureText),
            
            
            Container(
              alignment: Alignment.bottomRight,
              child: CupertinoButton(
                padding: EdgeInsets.symmetric(vertical:15),
                child: Text("Olvide mi contraseña",style: TextStyle(color:miTema.accentColor),), 
                onPressed: (){}),
            ),
            
            RoundedButton(
              label: "Ingresar",
              onPressed: (){},
            ),
            SizedBox(height:responsive.ip(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                Text("¿No tienes cuenta?",),
                CupertinoButton(
                  child: Text("Crear",style: TextStyle(fontWeight: FontWeight.bold,color:miTema.accentColor),), 
                  onPressed: ()=>Navigator.pushReplacementNamed(context, 'create_account'),)
              ]
            ),
           
          ]
        ) ,
      ),
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

class InputPassword extends StatefulWidget {
  const InputPassword({
    Key key,
    @required bool obscureText,
  }) : _obscureText = obscureText, super(key: key);

  final bool _obscureText;

  @override
  _InputPasswordState createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool show;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    show = widget._obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      padding: EdgeInsets.symmetric(vertical:5,horizontal:10),
      prefix: Container(
        width: 40,
        height: 30,
        child: Icon(LineIcons.key,color: Color(0xFFCCCCCC),),
      ),
      placeholder: "Contraseña",
      obscureText: show,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width:1,
            color: Color(0xffdddddd)
          )),
      ),
      suffix: IconButton(
        icon: Icon(
          // Based on passwordVisible state choose the icon
          show
          ? LineIcons.eye
          : LineIcons.eye_slash,
          color: Color(0xffdddddd),
          ),
          onPressed: _toggle
        ),
          );
  }

  void _toggle() {
    setState(() {
      show = !show;
    });
  }
}
