import 'dart:async';

import 'package:app_invernadero/src/models/client_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:geolocator/geolocator.dart';


class ClientBloc{
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
  
  void getClient(){
    ClientModel client =  _dbProvider.getClient(_storage.idClient);
    _clientController.sink.add(client);
  }

  dispose(){
    _clientController.close();
  }
  
}