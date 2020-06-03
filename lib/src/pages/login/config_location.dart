


import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:permission_handler/permission_handler.dart';

class ConfigLocation extends StatefulWidget {
  @override
  _ConfigLocationState createState() => _ConfigLocationState();
}
  
class _ConfigLocationState extends State<ConfigLocation> {
  
  SecureStorage _prefs = SecureStorage();
  
  final  map = new MapController();
  Position _position;
  PermissionStatus _status= PermissionStatus.undetermined;
  
  
  @override
  void initState() { 
    super.initState();
     _prefs.route = 'config_location';
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:FutureBuilder(
        future: Geolocator().checkGeolocationPermissionStatus(),
        builder:
          (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
          print("Estadooo");
          print(snapshot.data);
          if(snapshot.data==GeolocationStatus.granted){
            return FutureBuilder(
              future: Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                print("Location");
                print(snapshot.data);
                return _createFlutterMap(snapshot.data);
              },
            );
          }
          return FutureBuilder(
            future: Permission.location.request(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Container();
            },
          );
        },
      ),
      );
  }

  _createFlutterMap(Position position) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: new LatLng(position.latitude,position.longitude),
        zoom: 15
      ),
      layers: [
        _createMap(),
        _createMarkers(position),
      ],
    );
  }
  
  _createMap() {
     return TileLayerOptions(
      urlTemplate:  'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
      additionalOptions: {
        'accessToken':  AppConfig.mapbox_api_token, 
        'id': 'mapbox/streets-v11' 
        //streets, dark, light, outdoors, satellite
      }
    );

  }

  _createMarkers(Position position) {
    
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point:  new LatLng(position.latitude,position.longitude),
          // point: (_position.latitude!=0 && _position.longitude!=0)
          //     ? new LatLng(_position.latitude,_position.longitude)
          //     : new  LatLng(0,0),
          builder: (context)=>Container(
            child:Icon(
              Icons.location_on,
              size:45.0,
              color:Theme.of(context).primaryColor
              )
          )
        ),
      ]
    );
  }

  
}