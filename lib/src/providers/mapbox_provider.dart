import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/models/feature_model.dart';

class MapBoxProvider{
  

  Future<List<Feature>> searchPlace(String query)async{
    final url = "${AppConfig.mapbox_base_url}/$query.json?access_token=${AppConfig.mapbox_api_token}";   
    
    //final url = "https://api.mapbox.com/geocoding/v5/mapbox.places/Los%20Angeles.json?access_token=pk.eyJ1IjoiYXphZWxtb3JhbGVzcyIsImEiOiJjazhqNmU2aWMwNmMxM2VwODR6OXpsd3J6In0.FHZUGTjbl0Cz7Prqu2tb7Q";
    final response = await http.get(
      url);
    

    if(response.statusCode==200){
      print("Respuesta 200");
      var decodeData = jsonDecode(response.body)['features'] as List;
      if(decodeData!=null){
        print("Data succes");
        List<Feature> places = 
        decodeData.map((places) => Feature.fromJson(places)).toList();
        if(decodeData==null) return [];
        
        return places;
      }else{
        print("data null");
      }
  
      
    }else{
      return [];
    }
  }
  Future<Feature> getFeature(double long,double lat)async{
    final url = "${AppConfig.mapbox_base_url}/$long,$lat.json?access_token=${AppConfig.mapbox_api_token}";
    final response = await http.get(
      url);
    

    if(response.statusCode==200){
      print("RESPUESTA 200 ");
      print("Puntos $long $lat");
      print(response.body);
       var decodeData = jsonDecode(response.body)['features'] as List;

     // Feature feature = decodeData.first.toString();
      Feature feature = Feature.fromJson(jsonDecode(response.body)['features'][0]);

      if(feature!=null){
        print("Lugar Obtenido correctamente");
        return feature;
      }else{
        print("Ocurrio un erro al recuperar");
        return null;
      } 
    }else{
      return null;
    }
  }
}