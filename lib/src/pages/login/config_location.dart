


import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/blocs/client_bloc.dart';
import 'package:app_invernadero/src/blocs/feature_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/feature_model.dart';
import 'package:app_invernadero/src/models/user_model.dart';
import 'package:app_invernadero/src/providers/user_provider.dart';
import 'package:app_invernadero/src/search/mapbox_search.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:app_invernadero/src/widgets/place_holder.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:flushbar/flushbar.dart';
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
  ClientBloc _clientBloc;
  FeatureBloc _featureBloc;
  SecureStorage _prefs = SecureStorage();
  Responsive _responsive;
  MapController  map;
  Feature feature;
  UserProvider userProvider = UserProvider();
  String ubicacionName;
 String _route;

  @override
  void initState() { 
    super.initState();
    _prefs.route = 'config_location';
     map = new MapController();
    
  } 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_featureBloc == null) { 
      _featureBloc = Provider.featureBloc(context);
      _clientBloc = Provider.clientBloc(context);
    }
    _route =  ModalRoute.of(context).settings.arguments;
    if(_route==null)
      _route='';
    _responsive = Responsive.of(context);
  }
  
  @override
  void dispose() {
    //_featureBloc.dispose();
    //_clientBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //appBar: _appBar(),
      body:SafeArea(
        child: _permission(),
      ),
      );
  }
  
  _permission(){
     //pedir permisos de ubicación
    return FutureBuilder(
      future: Permission.location.request(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print("pidiendo permisos de ubicacion");
        print(snapshot.data);
        if(snapshot.data == PermissionStatus.granted){
          return _position();
        }
        return _screen();
      },
    );
  }
  _position(){
    //verificar el stream
    return StreamBuilder(
      stream: _featureBloc.positionStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData){//stream DATA
          Position position=snapshot.data;
          return _content(position);
        }else{ //si no hay datos en el stream ocupar posicion actual
        print("datos de ubicacion");
          return FutureBuilder( //obtener position actual
            future: Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData){
                
                Position position = snapshot.data;
                _featureBloc.addPosition(position);

                return _content(position);
              }
              return _screen();
            },
          );
        } 
      },
    );
  }

  _searchBar(){
    return Container(
      
      width: _responsive.widht,
      height: _responsive.ip(5),
      decoration: BoxDecoration(
        
        color:Colors.white,
        borderRadius:BorderRadius.circular(15)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
             child: Padding(
              padding: const EdgeInsets.only(left:20),
              child: Text("Buscar",
               overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily:'Quicksand',
                  fontWeight:FontWeight.w900,
                  fontSize:_responsive.ip(1.5)
                ),
              ),
            ),
          ),
          IconAction(icon:Icons.search,onPressed:()=>showSearch(
           context: context, delegate: PlacesSearch())),
        ],

      ),
    );
  }
  _content(Position position){
    //geolocalizacion inversa
    _featureBloc.getFeature(position.longitude, position.latitude);

    return Container(
      width:_responsive.widht,
      height: _responsive.height,

      child: Stack(
        children:<Widget>[
         
          _createFlutterMap(position),

          Positioned(
            top: _responsive.ip(2),
            left: 5,
            right: 5,
            child: _searchBar()),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              height:_responsive.ip(16),
             width:_responsive.widht,
             color: Colors.white,

            child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget>[
                    Text("Ubicación",style: TextStyle(
                      fontFamily:'Quicksand',
                      fontWeight:FontWeight.w900,
                      fontSize:_responsive.ip(1.7),
                      color:Colors.green
                    ),),
                        
                    Expanded(
                                          child: Row(
            children: <Widget>[
                      Icon(Icons.location_on,color: Colors.grey,),


                      StreamBuilder(
                        stream: _featureBloc.featureStream ,
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          if(snapshot.hasData){
                            
                            feature = snapshot.data;
                            ubicacionName = feature.placeName;
                            Feature f =feature;
                            return  Container(
                              width: _responsive.wp(80),
                              child: Text(feature.placeName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: _responsive.ip(1.3),
                                color:Colors.grey,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w800
                              ),  
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                      // FutureBuilder(
                      //   future: Geolocator().placemarkFromCoordinates(position.latitude, position.longitude),
                        
                      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                          
                      //     if(snapshot.hasData){
                      //       List<Placemark> p = snapshot.data;
                      //       Placemark place = p[0];
                      //       print("IDD: ${place.name}");
                      //       locationID = place.name;
                            
                      //       // print("JSONNN ${place.toJson()}");
                            
                      //       _addressModel = AddressModel.fromJson(place.toJson());

                      //       address = "${place.isoCountryCode}, ${place.country},  ${place.administrativeArea},"
                      //       " ${place.subAdministrativeArea},  ${place.locality}, ${place.subLocality},"
                      //       " ${place.thoroughfare}, "
                      //       "${place.subThoroughfare}.";
                            


                      //       return  Container(
                      //         width: _responsive.wp(80),
                      //         child: Text(address,
                      //         overflow: TextOverflow.ellipsis,
                      //         style: TextStyle(
                      //           fontSize: _responsive.ip(1.3),
                      //           color:Colors.grey,
                      //           fontFamily: 'Quicksand',
                      //           fontWeight: FontWeight.w800
                      //         ),  
                      //         ),
                      //       );
                      //     }
                      //     return  Container();
                      //   },
                      // ),
            ],
                      ),
                    ) ,

                    SizedBox(height: _responsive.ip(1),),

                    GestureDetector(
                      onTap: ()=>_onTap(position),
                        child: Container(
                        
                        width:_responsive.widht,
                        height:_responsive.ip(5),
                        decoration: BoxDecoration(
            color:miTema.accentColor,
            borderRadius: BorderRadius.circular(10),
            
                        ),
                        child: Center(
            child:Text("Usar esta ubicación",
              style: TextStyle(
                color:Colors.white,
                fontFamily:'Quicksand',
                fontSize:_responsive.ip(2),
                fontWeight: FontWeight.w900
              ), 
            )
                        ),
                      ),
                    )
                   ]
                 ),
            )
          )
        ]
      ),
    );
  }

  
  _createFlutterMap(Position position) {
      
    var mapa =   FlutterMap(
      mapController: map,
      options: MapOptions(
        
        center: new LatLng(position.latitude,position.longitude),
        zoom: 15,
       
      ),
      
      layers: [
        _createMap(),
        _createMarkers(position),
      ],
    );

      if (map.ready) {
    map.move(LatLng(position.latitude,position.longitude) , 15);
    }
    

    return mapa;
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

  
  _onTap(Position position)async{
    if(_featureBloc.positionStream!=null){
      
      final resp = await userProvider.updateAddress(
        ubicacionName,
        position.latitude.toString(),
        position.longitude.toString()
      );
      if(resp){
        _clientBloc.updateAddres(feature);  
        _featureBloc.insertFeature(feature);
        
        Flushbar(
        message:  "Información actualizada",
        duration:  Duration(seconds: 2),              
        )..show(context);

        if(_route=='home') //from home page
          Navigator.pop(context);
        else
          Navigator.pushReplacementNamed(context, 'home');
      }else{
        Flushbar(
          message:  "ALgo ha salido mal",
          duration:  Duration(seconds: 2),              
        )..show(context);
      }
    }
  }
  
  _screen(){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body:Container(
        width: _responsive.widht,
        height: _responsive.height,
        child: Column(
          children: <Widget>[
            PlaceHolder(
              img: 'assets/images/empty_states/empty_location.svg',
              title: 'No se han otorgado permisos de ubicación',
            ),
            RoundedButton(label: "Reintentar", onPressed: (){
              setState(() {
                
              });
            })
          ],
        ),
      ),
    );
  }
}
