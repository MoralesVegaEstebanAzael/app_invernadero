import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage{  

  static final SecureStorage _instance = new SecureStorage._internal();

  factory SecureStorage(){
    return _instance;
  }
  SecureStorage._internal();

  FlutterSecureStorage _storage;
  SharedPreferences _prefs;

  initPrefs()async{
    this._storage = FlutterSecureStorage();
     this._prefs = await SharedPreferences.getInstance();
  }
  
  Future write(String _key,String _value) async {
    _storage.write(key: _key, value: _value);
  }

  Future read(String _key) async {
    String value = await _storage.read(key: _key);
    if(value!=null)
    return value;

    return '';
  }

  Future delete(String _key) async {
    await _storage.delete(key: _key);
  }



  //GET SET TOKEN
  get sesion{
    return _prefs.getString('sesion')?? '';
  }
  
  set token(bool value){
    _prefs.setBool('sesion', value);
  }
}