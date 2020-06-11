


import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/blocs/client_bloc.dart';
import 'package:app_invernadero/src/blocs/feature_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/providers/mapbox_provider.dart';
import 'package:app_invernadero/src/search/mapbox_search.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/icon_action.dart';
import 'package:app_invernadero/src/widgets/place_holder.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:line_icons/line_icons.dart';
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
  String addres="";
   LatLng latLng; 
  
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
                latLng =  LatLng(position.latitude,position.longitude);

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
              child: Text(addres,
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

                      FutureBuilder(
                        future: Geolocator().placemarkFromCoordinates(position.latitude, position.longitude),
                        
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          
                          if(snapshot.hasData){
                            List<Placemark> p = snapshot.data;
                            Placemark place = p[0];
                            addres = "${place.subLocality} ${place.locality} ${place.country}";
                                          return  Text(addres,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: _responsive.ip(1.3),
                              color:Colors.grey,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w800
                            ),  
                            );
                          }
                          return CircularProgressIndicator();
                        },
                      ),
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

  
  _onTap(Position position){
    if(_featureBloc.positionStream!=null){
      _clientBloc.updateAddres(position, addres);
      Navigator.pushReplacementNamed(context, 'home');
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
