class User{
  String _phone;
  String _registered;
  String _password;
  String _name;

  User({String phone,String registered,String password,String name}){
    _phone = phone;
    _registered = registered;
    _password = password;
    _name = name;
  }

  set phone(String phone){
    this._phone = phone;
  }
  set registered(String registered){
    this._registered = registered;
  }
    set password(String password){
    this._password = password;
  }

  set name(String name){
    this._name = name;}

  
  String get phone{
    return this._phone;
  }

  String get registered{
    return this._registered;
  }
  
  String get password{
    return this._password;
  }

  String get name{
    return this._name;
  }
}