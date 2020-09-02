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
  

  /**new methods */

  final _nameController = BehaviorSubject<String>();
  final _apController = BehaviorSubject<String>();
  final _amController = BehaviorSubject<String>();
  final _rfController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  
  Stream<String> get nameStream=> _nameController.stream.transform(validarNombre);
  Stream<String> get apStream=> _apController.stream.transform(validarAp);
  Stream<String> get amStream=> _amController.stream.transform(validarAm);
  Stream<String> get rfStream=> _rfController.stream.transform(validarRFC);
   Stream<String> get emailStream => _emailController.stream.transform(validarEmail);


  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeAp => _apController.sink.add;
  Function(String) get changeAm => _amController.sink.add;
  Function(String) get changeR => _rfController.sink.add;
  Function(String) get changEmail => _emailController.sink.add;

  
  String get nombre => _nameController.value;
  String get apellidoP => _apController.value;
  String get apellidoM => _amController.value;
  String get rfc => _rfController.value;
  String get email => _emailController.value;


   //obtener el ultimo vakir 
  /*String get nombre => (_nameController.value == null) ? "" : _nameController.value;
  String get apellidoP => (_apController.value == null) ? "" : _apController.value;
  String get apellidoM => (_amController.value == null) ? "" : _amController.value;
  String get rfc => (_rfController.value == null) ? "" : _rfController.value;*/


 

  //****** */


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
    _userControler.sink.add(client);
    
  } 

  ClientModel cliente(){
    ClientModel client =  _dbProvider.getClient(_storage.idClient);  
    _userControler.sink.add(client);

    return client;
  }
  
  void updateImagen(String url)async{
    _cargandoController.sink.add(true);
    ClientModel client =  _dbProvider.getClient(_storage.idClient);
    client.urlImagen = url;
    await _dbProvider.updateClient(client); 
    print("----url actualizado en la base local");
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

  void updateNameLocal(String nombre) async{
    _cargandoController.sink.add(true);
    ClientModel client =  _dbProvider.getClient(_storage.idClient);
    client.nombre = nombre; 
    await _dbProvider.updateClient(client);
    print("%%%Nombre actualizado en la base local%%%");
    _cargandoController.sink.add(false);
  }

  void updateApaternoLocal(String aPaterno) async{
    _cargandoController.sink.add(true);
    ClientModel client =  _dbProvider.getClient(_storage.idClient);
    client.ap = aPaterno; 
    await _dbProvider.updateClient(client);
    print("%%% Apellido paterno actualizado en la base local%%%");
    _cargandoController.sink.add(false);
  }

  void updateAmaternoLocal(String aMaterno) async{
    _cargandoController.sink.add(true);
    ClientModel client =  _dbProvider.getClient(_storage.idClient);
    client.am = aMaterno; 
    await _dbProvider.updateClient(client);
    print("%%% Apellido materno actualizado en la base local%%%");
    _cargandoController.sink.add(false);
  }

  void updateRFCLocal(String rfc) async{
    _cargandoController.sink.add(true);
    ClientModel client =  _dbProvider.getClient(_storage.idClient);
    client.rfc = rfc; 
    await _dbProvider.updateClient(client);
    print("%%% RFC actualizado en la base local%%%");
    _cargandoController.sink.add(false);
  }

  Future<String> subirFoto(File foto) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await _userProvider.subirImagenCloudinary(foto);
    _cargandoController.sink.add(false);

    return fotoUrl;
  }

  void updateEmailLocal(String email) async {
    _cargandoController.sink.add(true);
    ClientModel client = _dbProvider.getClient(_storage.idClient);
    client.correo = email;
    await _dbProvider.updateClient(client);
    print("%%% Email actualizado en la base local%%%");
    _cargandoController.sink.add(false);
  }

  void updateInfoCliente(ClientModel cliente) async{
    _cargandoController.sink.add(true);
    await _userProvider.updateDatosUser(cliente);
    _cargandoController.sink.add(false);
  }

  void updateNameCliente(ClientModel cliente) async {
    _cargandoController.sink.add(true);
    await _userProvider.updateName(cliente);
    print("+++Nombre actualizado en la base remota+++");
    _cargandoController.sink.add(false);
  }

  void updatePaternoCliente(ClientModel cliente) async {
    _cargandoController.sink.add(true);
    await _userProvider.updateApaterno(cliente);
    print("+++Apellido Paterno actualizado en la base remota+++");
    _cargandoController.sink.add(false);
  }

  void updateMaternoCliente(ClientModel cliente) async {
    _cargandoController.sink.add(true);
    await _userProvider.updateAmaterno(cliente);
    print("+++Apellido Materno actualizado en la base remota+++");
    _cargandoController.sink.add(false);
  }

  void updateRFCliente(ClientModel cliente)async{
    _cargandoController.sink.add(true);
    await _userProvider.updateRFC(cliente);
    print("+++RFC actualizado en la base remota+++");
    _cargandoController.sink.add(false);
  }

  void updatEmailCliente(ClientModel cliente)async{
    _cargandoController.sink.add(true);
    await _userProvider.updateEmail(cliente);
    print("+++ Email actualizado en la base remota+++");
    _cargandoController.sink.add(false);
  }

  void updatePhoto(ClientModel cliente) async{
    _cargandoController.sink.add(true);
    await _userProvider.updatePhoto(cliente);
    print("----url actualizado el la base remota");
    _cargandoController.sink.add(false);
  }

  /*void initialData(ClientModel client){
    _nombreController.sink.add(client.nombre==null?'':client.nombre);
    _apellidoPController.sink.add(client.ap==null?'':client.ap);
    _apellidoMController.sink.add(client.am==null?'':client.am);
    _rfcController.sink.add(client.rfc==null?'':client.rfc);
  }*/

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
    _nameController.close();
    _apController.close();
    _amController.close();
    _rfController.close();
  }

  

  Position latLongClient(){
    int _id = _storage.idClient;
    ClientModel c = _dbProvider.getClient(_id);
    Position position = Position(latitude: c.lat,longitude: c.lng);
    return position;
  }

  bool information(){
    ClientModel client =  _dbProvider.getClient(_storage.idClient); 
    if(client.nombre!=null && client.am!=null&& client.ap!=null&&client.rfc!=null){
      return true;
    }
    return false;
  }

}
    
 
