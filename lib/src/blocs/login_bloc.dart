import 'dart:async';
import 'dart:io';

import 'package:app_invernadero/src/blocs/validators.dart';
import 'package:app_invernadero/src/models/userModel.dart';
import 'package:app_invernadero/src/providers/user_provider.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{
  final _emailController = BehaviorSubject<String>();


  final _telefonoController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nombreController = BehaviorSubject<String>();

  final _userControler = BehaviorSubject<UserModel>();
  final _cargandoController =BehaviorSubject<bool>();
  final _userProvider = new UserProvider();

  Stream<UserModel> get userStream => _userControler.stream;
  Stream<bool> get cargando => _cargandoController.stream;

  void cargarUsuario()async{
    final user = await _userProvider.cargarUsuario();
    _userControler.sink.add(user);
  }

  Future<String> subirFoto(File foto) async{
    _cargandoController.sink.add(true);
    final fotoUrl = await _userProvider.subirImagenCloudinary(foto);
    _cargandoController.sink.add(false);

    return fotoUrl;
  }

  void editarUser(UserModel user) async{
    _cargandoController.sink.add(true);
    await _userProvider.updateDatosUser(user);
    _cargandoController.sink.add(false);
  }
  
  //recuperar salida del stream
  Stream<String> get emailStream=> _emailController.stream.transform(validarEmail);
  
  Stream<String> get telefonoStream=> _telefonoController.stream.transform(validarTelefono);  
  Stream<String> get passwordStream=> _passwordController.stream.transform(validarPassword);
  
  Stream<String> get nombreStream=> _nombreController.stream.transform(validarNombre);
  //validate formulario
  Stream<bool> get formValidStream => 
    CombineLatestStream.combine2(telefonoStream, passwordStream, (t, p) => true);

  //insertar valores al stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changeTelefono => _telefonoController.sink.add;  
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeNombre => _nombreController.sink.add;


  String get email =>_emailController.value;
  String get telefono =>_telefonoController.value.replaceAll(RegExp('[^0-9]'),'');
  String get password => _passwordController.value;
  String get name=>_nombreController.value;
  void dispose(){
    _emailController?.close();
    _passwordController?.close();
    _telefonoController?.close();
    _nombreController?.close();
    _userControler?.close();
    _cargandoController?.close();
  }

}