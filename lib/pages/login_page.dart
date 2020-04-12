import 'package:app_invernadero/animation/fade_animation.dart';
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
      body:  Stack(
          children:<Widget>[
            _background(context),
            _widget(context),

          ]
        ),
      );
  }

  Widget _background(BuildContext context){
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height*0.50,
      child: Stack(
        children:<Widget>[
         
          Positioned(
            top: -50,
            height: height*0.494,
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
            height: height*0.45,
            width: width+20,
            child:FadeAnimation(
              1.5, 
              Container(
              decoration: BoxDecoration(
                image:DecorationImage(
                  image: AssetImage('assets/images/background2.png'),
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
     final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SafeArea(
            child: Container(
              height: 0.0,
            ) 
        ),
        Container(
          width: size.width*0.85,
            padding: EdgeInsets.symmetric(vertical:50.0),
            margin: EdgeInsets.symmetric(vertical:30.0),
            decoration: BoxDecoration(
              color : Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color:Colors.black26,
                  blurRadius: 3.0,
                  offset : Offset(0.0,5.0),
                  spreadRadius: 3.0
                )
          ]),
         child:Column(
              children: <Widget>[
                Text('Login',style: TextStyle(fontSize:20.0),),  
                SizedBox(height:60.0),
                _createUserName(),
                SizedBox(height:30.0),
                _createPassword(),
                SizedBox(height:30.0),
                _createButton()
              ],
            ),
        )
          ],
        ),
    );
  }

  Widget _createUserName() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal:20.0),
        child: TextField(
          keyboardType : TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: Icon(Icons.account_circle,color:Colors.green),
            hintText: 'ejemplo@correo.com',
            labelText: 'Usuario',
          ),
        ),
      );
  }

  Widget _createPassword() {
    return Container(
          padding: EdgeInsets.symmetric(horizontal:20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock,color:Colors.green),
              labelText: 'Contraseña',
            ),
          
          ),
        );
  }

  Widget _createButton() {
    return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal:80.0,vertical:15.0),
            child: Text('Ingresar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation:0.0 ,
          color: Colors.green,
          textColor: Colors.white,
          onPressed: (){}
    );
  }

    
  Widget _widget(BuildContext context){
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
          
          padding: EdgeInsets.symmetric(horizontal:40,vertical:0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  SafeArea(
                    child: Container(
                      height: 320.0,
                    ) 
                  ),
                  
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
                        Container(
                          padding: EdgeInsets.all(10),  
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(
                              color: Colors.grey[200]
                            ))
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Usuario",
                              hintStyle: TextStyle(color:Colors.grey)
                            )
                          ),
                        ),
                        GestureDetector(
                          onTap: (){},
                            child: Container(
                            padding: EdgeInsets.all(10),  
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Contraseña",
                                hintStyle: TextStyle(color:Colors.grey)
                              )
                            ),
                          ),
                        ),
                        
                      ]
                    ),
                  ),
                  ),
                  
                  SizedBox(height:height*.03),
                  FadeAnimation(
                    1.7, 
                    Center(child: Text("Olvide mi contraseña",style: TextStyle( color: Color.fromRGBO(41, 154, 101, 1),),)),
                  ),
                  
                   SizedBox(height:height*0.02),
                  FadeAnimation(
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
                  ),
                   SizedBox(height:height*0.02),
                  FadeAnimation(
                    2, 
                    Center(child: Text("Crear una cuenta",style: TextStyle(color: Color.fromRGBO(41, 154, 101, 1)))),
                  ),
                ]
              ),  

            
    );
  }

}