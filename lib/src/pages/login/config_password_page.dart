import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/input_password.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';


class ConfigPasswordPage extends StatefulWidget {
  @override
  _ConfigPasswordPageState createState() => _ConfigPasswordPageState();
}

class _ConfigPasswordPageState extends State<ConfigPasswordPage> {
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
        Text("Configurar contraseña",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400
        ),),
        SizedBox(height:responsive.ip(5)),
        Text("Configura tu contraseña",
            style: TextStyle(
              color: Colors.grey,
            ),
        ),
        SizedBox(height:responsive.ip(5)),
        Text("Contraseña",style:_style),

        StreamBuilder(
            stream: bloc.passwordStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return InputPassword(
                onChange: bloc.changePassword,
              );
            },
          ),

        SizedBox(height:responsive.ip(4)),
        StreamBuilder(
          stream: bloc.passwordStream,
          builder:(BuildContext context,AsyncSnapshot snapshot){
            return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Debes incluir al menos 2 numeros, letras o signos.",
                style: TextStyle(color:Colors.grey),
              ),
              
              (bloc.password==null|| snapshot.error!=null)?
               Icon(Icons.close,size: 15,color:Colors.red,)
              :
              Icon(LineIcons.check,size: 15,color:Colors.green,),
            ],
            );
          }
        ),
        SizedBox(height:responsive.ip(1)),
        StreamBuilder(
          stream: bloc.passwordStream,
          builder:(BuildContext context,AsyncSnapshot snapshot){
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                
              Text("Tu contraseña debe tener entre 8 y 16 caracteres.",
                style: TextStyle(color:Colors.grey),
              ),
              (bloc.password==null|| bloc.password.length>16||bloc.password.length<8)?
              Icon(Icons.close,size: 15,color:Colors.red,)
              :
              Icon(LineIcons.check,size: 15,color:Colors.green,),
              ],
            );
        }),
        SizedBox(height:responsive.ip(2)),
        Expanded(
          child: StreamBuilder(
            stream: bloc.passwordStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return  Center(
              child: RoundedButton(
                label: "Siguiente", 
                onPressed: snapshot.hasData?()=>_submit() : null)
              );
            },
          ),
            
        )
      ],);
  }
  
  _submit(){
    Navigator.pushReplacementNamed(context, 'config_account');
  }
}