import 'dart:async'; 
import 'dart:io';

import 'package:app_invernadero/src/blocs/validators.dart';
import 'package:app_invernadero/src/models/client_model.dart';
import 'package:app_invernadero/src/models/feature_model.dart';
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

  final _direcController = new BehaviorSubject<String>();
  final _infController = new BehaviorSubject<bool>();

  Stream<String> get dirStream => _direcController.stream;
  Stream<bool> get infStream => _infController.stream;

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
  Stream<String> get nombreStream => _nombreController.stream.transform(validarNombre) ;
  Stream<String> get apellidoPStream => _apellidoPController.stream.transform(validarNombre);
  Stream<String> get apellidoMStream => _apellidoMController.stream.transform(validarNombre);
  Stream<String> get rfcStream => _rfcController.stream.transform(validarRFC);
  
  Stream<bool> get formValidStream =>  
    CombineLatestStream.combine4(nombreStream, apellidoPStream, apellidoMStream, rfcStream, (n,p,m,r) => true);

  String get nombre =>_nombreController.value;
  String get apellidoP =>_apellidoPController.value;
  String get apellidoM =>_apellidoMController.value;
  String get rfc =>_rfcController.value;

  //insertat valores al stream
  Function(String) get changeNombre => _nombreController.sink.add;
  Function(String) get changeApellidoP => _apellidoPController.sink.add;
  Function(String) get chanfeApellidoM => _apellidoMController.sink.add;
  Function(String) get changeRFC => _rfcController.sink.add;

  StreamController<Position> _addressPositionController = BehaviorSubject<Position>();

  Stream<Position> get addressPositionStream => _addressPositionController.stream;


  //direcciones
  

  void updateAddres(Feature feature){
    ClientModel client =  _dbProvider.getClient(_storage.idClient);
    client.lat = feature.geometry.coordinates[1];
    client.lng = feature.geometry.coordinates[0];
    client.direccion = feature.placeName;
    _storage.idFeature = feature.id; //direccion default
    updateClient(client);
    // insertAddress(address);
  }

  
  void updateClient(ClientModel client)async{
    await _dbProvider.updateClient(client);
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
    await _dbProvider.updateClient(client);
    _cargandoController.sink.add(false);
  }

  Future<String> subirFoto(File foto) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await _userProvider.subirImagenCloudinary(foto);
    _cargandoController.sink.add(false);

    return fotoUrl;
  }

  void updateInfoCliente(ClientModel cliente) async{
    _cargandoController.sink.add(true);
    await _userProvider.updateDatosUser(cliente);
    _cargandoController.sink.add(false);
  }

  void updatePhoto(String url_imagen) async{
    _cargandoController.sink.add(true);
    await _userProvider.updatePhoto(url_imagen: url_imagen);
    _cargandoController.sink.add(false);
  }

  void initialData(ClientModel client){
    _nombreController.sink.add(client.nombre);
    _apellidoPController.sink.add(client.ap);
    _apellidoMController.sink.add(client.am);
    _rfcController.sink.add(client.rfc);
  }

  void dirClient(){
    ClientModel client = _dbProvider.getClient(_storage.idClient);
    _direcController.sink.add(client.direccion);

    Position position = Position(longitude:client.lng,latitude:client.lat);

    _addressPositionController.sink.add(position);
  }


  void addressDelPosition(Position position){
    _addressPositionController.sink.add(position);
  }

  void infClient(){
    _infController.sink.add(_storage.informacion);
  }

  bool informactionClient(){
    return  _storage.informacion;  
  }

   dispose() {
    _clientController.close();
    _direcController.close();
    _infController.close(); 
    _userControler.close();
    _cargandoController.close();
    _nombreController.close();
    _apellidoPController.close();
    _apellidoMController.close();
    _rfcController.close();
  }

  

  Position latLongClient(){
    String _id = _storage.idClient;
    ClientModel c = _dbProvider.getClient(_id);
    Position position = Position(latitude: c.lat,longitude: c.lng);
    return position;
  }

}
    
 
