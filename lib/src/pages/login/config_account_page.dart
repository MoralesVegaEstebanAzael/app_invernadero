import 'package:after_layout/after_layout.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfigAccountPage extends StatefulWidget {
  @override
  _ConfigAccountPageState createState() => _ConfigAccountPageState();
}



class _ConfigAccountPageState extends State<ConfigAccountPage>  with AfterLayoutMixin{
  final TextStyle _style =  TextStyle(color:Colors.grey,fontSize:18);
    
   @override
  void afterFirstLayout(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide>=600;
    if(!isTablet){
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

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
        Text("Mi perfil",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 30
          ),),
        SizedBox(height:responsive.ip(2)),
        Text("Asegurate de que tus datos sean correctos.",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        SizedBox(height:responsive.ip(2)),
        Text("Nombre",
          style:_style),

        
        StreamBuilder(
          stream: bloc.nombreStream ,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            return _inputText(
              TextInputType.text,snapshot.error,bloc.changeNombre);
          },
        ),

        SizedBox(height:responsive.ip(2)),
        Text("Apellido",style:_style),
        _inputText(TextInputType.text,null,null),
        
        SizedBox(height:responsive.ip(2)),
        Text("Correo electrónico (opcional)",style:_style),
        
        StreamBuilder(
          stream: bloc.emailStream ,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            return _inputText(
              TextInputType.emailAddress,
              snapshot.error,
             bloc.changeEmail,
            );
          },
        ),
              
        SizedBox(height:responsive.ip(2)),
        StreamBuilder(
          stream: bloc.nombreStream ,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            return Expanded( 
              child: Center(
                child: RoundedButton(
                label: "Siguiente", 
                onPressed: snapshot.hasData?()=>_submit() : null),
              ),
            );
          },
        ),
        
      ],);
  }

  _submit(){
    
  }



  Widget _inputText(TextInputType textInput, String errorText,Function(String) func){
    return TextField(
      keyboardType: textInput,
      decoration: InputDecoration(
          focusedBorder:  UnderlineInputBorder(      
                          borderSide: BorderSide(color:Color(0xffdddddd))),
          enabledBorder: UnderlineInputBorder(      
                          borderSide: BorderSide(color:Color(0xffdddddd)),),
          hintStyle: TextStyle(color:Colors.grey),
          errorText: errorText,
      ),
      textCapitalization: TextCapitalization.sentences, 
      onChanged: func,
    );
  } 
}


