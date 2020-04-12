
import 'package:app_invernadero/src/animation/fade_animation.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _background(context),
            _loginForm(context),  
          ]
        ),
      ),
    );
  }


  Widget _background(BuildContext context){
    final width = MediaQuery.of(context).size.width;
    return Container(
     
      height:245,
      child: Stack(
        children:<Widget>[
          Positioned(
            top: -50,
            height: 290.0,
            width: width,
            child:FadeAnimation(
              1.3,
              Container(
                decoration: BoxDecoration(
                  image:DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill
                  )
                ),
              ),
            )
          ),
          Positioned(
            
            height:240,
            width: width+20,
            child:FadeAnimation(
              1.5, 
              Container(
                decoration: BoxDecoration(
                  image:DecorationImage(
                    image: AssetImage('assets/images/back.png'),
                    fit: BoxFit.fill
                  )
                ),
              )
            ),
          ),
        ]
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return  Container(
      
      padding: EdgeInsets.symmetric(horizontal:40,vertical:0),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            FadeAnimation(1.6, Text("Invernadero Santiago Atoyaquillo",style:TextStyle(color: Color.fromRGBO(49, 39, 79, 1),fontWeight: FontWeight.bold,fontSize: 30))),
            SizedBox(height:30),
            FadeAnimation(
              1.7,
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(41, 154, 101, .3),
                      blurRadius: 20,
                      offset: Offset(0,10)
                    )
                  ]
                ),
                child: Column(
                  children: <Widget>[
                    _inputUsername(),
                    _inputPassword(),
                    
                  ]
                ),
              ),
            ),
            SizedBox(height:height*.03),
            _rememberPassword(),
            SizedBox(height:height*0.02),
            _button(),
            SizedBox(height:height*0.02),
            _createAccount(),
          ]
        ),  

      );
  }
  
  Widget _inputUsername() {
    return  Container(
      padding: EdgeInsets.all(10),  
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(
          color: Colors.grey[200]
        ))
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Username",
          hintStyle: TextStyle(color:Colors.grey)
        )
      ),
    );
  }

  Widget _inputPassword() {
    return Container(
      padding: EdgeInsets.all(10),  
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Contraseña",
          hintStyle: TextStyle(color:Colors.grey)
        )
      ),
    );
  }

  Widget _button(){
    return FadeAnimation(
      1.9, 
      Container(
        height:50,
        margin: EdgeInsets.symmetric(horizontal:60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color.fromRGBO(41, 154, 101, 1)
        ),
        child: Center(
          child: Text("Ingresar",style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }

  Widget _rememberPassword() {
    return FadeAnimation(
      1.7, 
      Center(child: Text("Olvide mi contraseña",style: TextStyle( color: Color.fromRGBO(41, 154, 101, 1),),)),
    );
  }

  Widget _createAccount() {
    return FadeAnimation(
      2, 
      Center(child: Text("Crear una cuenta",style: TextStyle(color: Color.fromRGBO(41, 154, 101, 1)))),
    );
  }
    


}
