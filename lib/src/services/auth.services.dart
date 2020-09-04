import 'package:app_invernadero/src/pages/login/config_password_page.dart';
import 'package:app_invernadero/src/pages/login/login_phone_page.dart';
import 'package:app_invernadero/src/pages/login/pin_code_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService{

  handleAuth(){
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          return ConfigPasswordPage();
        }
        return LoginPhonePage();
      },
    );
  }
}