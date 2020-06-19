import 'dart:async';

import 'package:app_invernadero/src/models/feature_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/mapbox_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';


class FeatureBloc{
  //providers
  //final _coordinatesController = new BehaviorSubject<List<double>>();
  
  static final FeatureBloc _singleton = FeatureBloc._internal();
  DBProvider _dbProvider = DBProvider();
  factory FeatureBloc() {
    return _singleton;
  }
  
  MapBoxProvider mapBoxProvider = MapBoxProvider();
  FeatureBloc._internal();
  
  final StreamController<List<double>>  _coordinatesController =
      StreamController<List<double>>.broadcast();

  final StreamController<Position> _positionController = 
  StreamController<Position>.broadcast();

  final StreamController<String> _addresController = 
  StreamController<String>.broadcast();

  Stream<List<double>> get coordinatesStream =>_coordinatesController.stream;
  Stream<Position> get positionStream => _positionController.stream;
  Stream<String> get addresStream=>_addresController.stream;


  final StreamController<Position> _addressDelController = BehaviorSubject<Position>();
  Stream<Position> get addresDelStream => _addressDelController.stream;


  //features list
  final StreamController<List<Feature>> _featureListController = BehaviorSubject<List<Feature>>();
  Stream<List<Feature>> get featureListStream => _featureListController.stream; 
  //only feature
  final StreamController<Feature> _featureController = BehaviorSubject<Feature>();
  Stream<Feature> get featureStream => _featureController.stream;

  dispose(){
    _positionController.close();
    _coordinatesController.close();
    _addresController.close();
  }

  // void addCoordinate(List<double> coordenadas){
  //   coordenadas!=null?
  //   _coordinatesController.sink.add(coordenadas)
  //   :
  //   print("nulo")
  //   ;
  // }

  void addPosition(Position position){
    print("Position Bloc $position");
    _positionController.sink.add(position);
  }

  void addFeature(Feature feature)async{
    _featureController.sink.add(feature);
  }

  void getFeature(double long,double lat)async{ 
    Feature feature = await mapBoxProvider.getFeature(long, lat);
    if(feature!=null){
      _featureController.sink.add(feature);
    }
  }

  
  
  //lista de direcciones
  void features()async{
    List<Feature> list = await _dbProvider.getFeature();
    _featureListController.sink.add(list);
  }
  
  void insertFeature(Feature feature)async{
    _dbProvider.insertFeature(feature);
  }

  void deleteAddress(Feature feature)async{
    await  _dbProvider.deleteFeature(feature);
  }
}