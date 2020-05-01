import 'package:after_layout/after_layout.dart';
import 'package:app_invernadero/src/blocs/login_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/user_model.dart';
import 'package:app_invernadero/src/providers/user_provider.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ConfigAccountPage extends StatefulWidget {
  @override
  _ConfigAccountPageState createState() => _ConfigAccountPageState();
}



class _ConfigAccountPageState extends State<ConfigAccountPage>  with AfterLayoutMixin{
  UserProvider userProvider = UserProvider();
  SecureStorage _prefs = SecureStorage();
  final TextStyle _style =  TextStyle(color:Colors.grey,fontSize:18);
  bool _isLoading=false;
  User _user;

   final snackBar = SnackBar(
    content: Text('Algo ha salido mal'),
    backgroundColor: Colors.redAccent,);

  @override
  void initState() {
    super.initState();
    _prefs.route = 'config_account';
    _user = _prefs.user;
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
               
                height: responsive.height,
                child: SafeArea(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                      child: Container(
                         padding: EdgeInsets.symmetric(horizontal:20,vertical:20),
                        child: _content(responsive)
                      ),),

                      _isLoading? Positioned.fill(
                        child:  Container(
                        color:Colors.black45,
                        child: Center(
                          child:SpinKitCircle(color: miTema.accentColor),
                        ),),) :Container(),
                    ],
                  ),
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
                onPressed: snapshot.hasData?()=>_submit(bloc) : null),
              ),
            );
          },
        ),
        
      ],);
  }

  _submit(LoginBloc bloc)async{
    if(_isLoading)return;

    if(bloc.name.isNotEmpty){
       setState(() {
        _isLoading=true;
      });
      //API
      Map info = await userProvider.changeInf(
        telefono: _user.phone , name: bloc.name,email: bloc.email);

      setState(() {
        _isLoading=false;
      });

      if(info['ok']){
        Navigator.pushReplacementNamed(context, 'config_account');
      }else{
        print("ocurrio un error durante la peticion");
        Scaffold.of(context).showSnackBar(snackBar);
      }
    }
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


