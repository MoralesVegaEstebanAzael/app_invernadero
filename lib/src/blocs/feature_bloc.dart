import 'dart:async';

import 'package:geolocator/geolocator.dart';


class FeatureBloc{
  //providers
  //final _coordinatesController = new BehaviorSubject<List<double>>();
  
  static final FeatureBloc _singleton = FeatureBloc._internal();

  factory FeatureBloc() {
    return _singleton;
  }
  
  FeatureBloc._internal();
  
  final StreamController<List<double>>  _coordinatesController =
      StreamController<List<double>>.broadcast();

  final StreamController<Position> _positionController = 
  StreamController<Position>.broadcast();

  final StreamController<String> _addresController = 
  StreamController<String>.broadcast();

  Stream<List<double>> get coordinatesStream =>_coordinatesController.stream;
  Stream<Position> get postionStream => _positionController.stream;
  Stream<String> get addresStream=>_addresController.stream;

  dispose(){
    _positionController.close();
    _coordinatesController.close();
    _addresController.close();
  }

  void addCoordinate(List<double> coordenadas){
    coordenadas!=null?
    _coordinatesController.sink.add(coordenadas)
    :
    print("nulo")
    ;
  }

  void addPosition(Position position){
    print("Position Bloc $position");
    _positionController.sink.add(position);
  }

  void addAddres(String addres){
    _addresController.sink.add(addres);
  }

  
}