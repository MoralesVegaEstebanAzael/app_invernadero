import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/input_password.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class LoginPasswordPage extends StatefulWidget {
  @override
  _LoginPasswordPageState createState() => _LoginPasswordPageState();
}


class _LoginPasswordPageState extends State<LoginPasswordPage> {
  final TextStyle _style =  TextStyle(color:Colors.grey,fontSize:18);
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
                padding: EdgeInsets.symmetric(horizontal:20,vertical:20),
                height: responsive.height,
                child: SafeArea(
                  child: _content(responsive),
                ),
              ),
            )     
        ),
      )
    );
  }

  Widget _content(Responsive responsive){
    final bloc = Provider.of(context);
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
                onPressed: snapshot.hasData?()=>_submit() : null)
              );
            },
          ),
            
        )
      ],);
  }

  _forgotPassword(){
     Navigator.pushReplacementNamed(context, 'pin_code');
  }
  _submit(){

  }
}