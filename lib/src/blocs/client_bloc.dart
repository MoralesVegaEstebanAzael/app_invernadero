import 'dart:async'; 
import 'dart:io';

import 'package:app_invernadero/src/blocs/validators.dart';
import 'package:app_invernadero/src/models/client_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/user_provider.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';


class ClientBloc with Validators{
  final _storage = SecureStorage();  
  DBProvider _dbProvider = DBProvider();
  static final ClientBloc _singleton = ClientBloc._internal();

  factory ClientBloc() {
    return _singleton;
  }
  
  ClientBloc._internal();
  
  final StreamController<ClientModel> _clientController = 
  StreamController<ClientModel>.broadcast();

  
  Stream<ClientModel> get clientStream =>_clientController.stream;

  final StreamController<String> _addressController =
  StreamController<String>.broadcast();

  Stream<String> get addressStream => _addressController.stream;


  final _userControler = BehaviorSubject<ClientModel>();
  final _cargandoController = BehaviorSubject<bool>();
  final _userProvider = new UserProvider();
  Stream<ClientModel> get userStream =>_userControler.stream;
  Stream<bool> get cargando => _cargandoController.stream;

  final _nombreController = BehaviorSubject<String>();
  final _apellidoPController = BehaviorSubject<String>();
  final _apellidoMController = BehaviorSubject<String>();
  final _rfcController = BehaviorSubject<String>();

  //recuperar los datos del stream
  Stream<String> get nombreStream => _nombreController.stream.transform(validarNombre);
  Stream<String> get apellidoPStream => _apellidoPController.stream.transform(validarNombre);
  Stream<String> get apellidoMStream => _apellidoMController.stream.transform(validarNombre);
  Stream<String> get rfcStream => _rfcController.stream.transform(validarRFC);
  
  Stream<bool> get formValidStream => 
    CombineLatestStream.combine2(nombreStream, rfcStream, (t, p) => true);

  //insertat valores al stream
  Function(String) get changeNombre => _nombreController.sink.add;
  Function(String) get changeApellidoP => _apellidoPController.sink.add;
  Function(String) get chanfeApellidoM => _apellidoMController.sink.add;
  Function(String) get changeRFC => _rfcController.sink.add;


  void updateAddres(Position position,String addres){
    ClientModel client =  _dbProvider.getClient(_storage.idClient);
    client.lat = position.latitude;
    client.lng = position.longitude;
    client.direccion = addres;
    updateClient(client);
  }
  void updateClient(ClientModel client)async{
    await _dbProvider.updateClient(client);
  } 
  
  void addresClient(){
    ClientModel client =  _dbProvider.getClient(_storage.idClient);
    //print("Clienteeeeeeeeeeeee: ${client.direccion}");
    
    _addressController.sink.add(client.direccion);
  }
  void getClient(){
    ClientModel client =  _dbProvider.getClient(_storage.idClient); 
    //print("///////////////////////////////////////////");
    //print(client);
    //print("Clienteeeeeeeeeeeee: ${client.urlImagen}");
    _userControler.sink.add(client);
  }

  void updateImagen(String url)async{
    _cargandoController.sink.add(true);
    ClientModel client =  _dbProvider.getClient(_storage.idClient);
    client.urlImagen = url;
    await _dbProvider.updateClient(client); 
    _cargandoController.sink.add(false);
  }

  void updateDatos(String nombre, String ap, String am, String rfc) async{
    _cargandoController.sink.add(true);
    ClientModel client =  _dbProvider.getClient(_storage.idClient);
    client.nombre = nombre;
    client.ap = ap;
    client.am = am;
    client.rfc = rfc; 
     updateClient(client);
    _cargandoController.sink.add(false);
  }

  Future<String> subirFoto(File foto) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await _userProvider.subirImagenCloudinary(foto);
    _cargandoController.sink.add(false);

    return fotoUrl;
  }

  dispose() {
    _clientController.close();
    //_addressController.close();
    _userControler.close();
    _cargandoController.close();
    _nombreController.close();
    _apellidoPController.close();
    _apellidoMController.close();
    _rfcController.close();
  }


  
}
