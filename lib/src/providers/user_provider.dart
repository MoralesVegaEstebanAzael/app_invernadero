import 'dart:convert';
import 'dart:io';
import 'package:app_invernadero/src/models/client_model.dart';
import 'package:app_invernadero/src/models/notification_model.dart'; 
import 'package:app_invernadero/src/models/userModel.dart'; 
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/pedido_provider.dart';
import 'package:app_invernadero/src/providers/push_notifications_provider.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class UserProvider{

  static final UserProvider _userProvider = UserProvider._internal();

  factory UserProvider() {
    return _userProvider;
  }

  UserProvider._internal();


  final _storage = SecureStorage();  
  DBProvider _dbProvider = DBProvider();
  final fcm = PushNotificationsProvider();
  PedidoProvider pedidoProvider = PedidoProvider();

  Future<Map<String,dynamic>> buscarUsuario({@required String celular})async{
      await _storage.write('celular', celular);
      final url = "${AppConfig.base_url}/api/client/search";
     
      
      final response = await http.post(url,body: {"celular":celular});
    
      
      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      print(decodedResp);
      
      if(decodedResp.containsKey('celular')){ 
        return {
          'ok':true, 
          'nombre' : decodedResp['nombre'],
          'password':decodedResp['password'],
          'direccion':decodedResp['direccion']          
        };
      }else{
        return {'ok':false, 'mensaje' : decodedResp['error']};
      }
  }
  

  Future<Map<String,dynamic>> login({@required String celular,@required  String password})async{
      Map<String, String> headers = {"Accept": "application/json"};
      final url = "${AppConfig.base_url}/api/client/login";
      
      final response = await http.post(
        url,headers:headers ,
        body: {
          "grant_type" : "refresh_token" ,
          "customer_id" : "client-id" ,
          "client_secret" : "client-secret" ,
          "refresh_token" : "refresh-token" ,
          "provider" : AppConfig.provider_api ,
          "celular":celular,
          "password":password}
        );
      
      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      print("CLIENTEEEEEEEEE");
      print(response.body);
      if(decodedResp.containsKey('access_token')){ //access_token,token_type,expires_at
        // TODO: salvar e token preferences
        await _storage.write('token',decodedResp['access_token']);
        //var decodeData = jsonDecode(response.body)['client'] ;
        //print("DEcode resp");
        ClientModel client = ClientModel.fromJson(jsonDecode(response.body)['client']);
        _dbProvider.insertClient(client);
        
        _storage.idClient = client.id;
        _storage.sesion = true;
        

        //create new firebase cloud messaging token local
        //await fcm.refreshToken();   
        
        await fcm.subscribeToTopic(celular);
        await fcm.subscribeToTopic(AppConfig.all_topic);
        // save new fcm token
        //await this.fcmToken(fcmToken: fcmToken);
        
        //obtener pedidos de la bd remota
        final res = await pedidoProvider.getPedidos();
        res?print("todo bien"):print("Hubo un problema al recuperar los pedidos");
       //  return {'ok':false};
      return {'ok':true, 'celular' : decodedResp};
      }else{
        return {'ok':false, 'mensaje' : decodedResp['message']};
      }
  }

  
  Future<Map<String,dynamic>> changePassword({@required String celular,@required  String password})async{
    
    final url = "${AppConfig.base_url}/api/client/update_password";
    final token = await _storage.read('token');
    

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.post(
      url,
      headers:headers,
      body: {"celular":celular,"password":password});
    
    Map<String,dynamic> decodedResp = jsonDecode(response.body);
    print("${   response.body}");
    
    print(decodedResp); 
    if(decodedResp.containsKey('result')){ 
      return {'ok':true, 'message' : decodedResp['message']};
    }else{
      return {'ok':false, 'message' : decodedResp['message']};
    }
  }


  Future<Map<String,dynamic>> changeInf({@required String telefono,@required  String name,String email})async{
    
    final url = "${AppConfig.base_url}/api/auth/change_inf";
    final token = await _storage.read('token');

    
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.post(
      url,
      headers:headers,
      body: {
        "telefono":telefono,
        "name":name,
        "email":email==null?'no_email':email,
        });
    
    Map<String,dynamic> decodedResp = jsonDecode(response.body);

    print("API CHANGE INFORMATION");
    print(decodedResp); 
    if(decodedResp.containsKey('result')){ 

      return {'ok':true, 'message' : decodedResp['message']};
    }else{
      return {'ok':false, 'message' : decodedResp['message']};
    }
  }


  Future<Map<String,dynamic>> logout()async{
    try{
      final url = "${AppConfig.base_url}/api/client/logout";
      final token = await _storage.read('token');
        Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};

      final response = await http.get(
        url, 
        headers: headers,);
      
      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      
      print("CODE LOGOUT response: $response.statusCode");
      print("***RESPUESTA****");
      print(decodedResp); 
      
      
      if(decodedResp.containsKey('message')){ 
        // TODO: remove  token 
       
        
        //delete fcm token

        fcm.deleteToken();
        //set state ->> fcm token 
        //final fcmT = await fcm.getFCMToken();
        
        // await()
        //await this.deleteFcmToken(fcmToken: fcmT);
        
        
        _dbProvider.deleteAllBox();


        await _storage.delete('token'); 
        _storage.sesion = false;

        return {'ok':true, 'celular' : decodedResp};
      }else{
        return {'ok':false, 'mensaje' : decodedResp['message']};
      }
    }on PlatformException catch(e){
      print("Error ${e.code}:${e.message}");  
      return {'ok':false, 'mensaje' : 'error'};
    }
      
  }
 
  Future<UserModel> cargarUsuario()async{
      final telefono = _storage.user.phone;
      final url = "${AppConfig.base_url}/api/client/buscarUser";
      final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
     

      final response = await http.post(url, headers: headers, body: {"telefono":telefono}); 
      
      var decodeData = jsonDecode(response.body);
      print(decodeData);
      if(decodeData == null) return null; 
      
      return  UserModel.fromJson(decodeData); 
      
  }

  Future<bool> updateDatosUser(ClientModel user) async{
    final url = "${AppConfig.base_url}/api/client/add_info"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 
    
    final response = await http.post(
      url, 
      headers: headers,
      body: {
        "celular":user.celular,
        "nombre":user.nombre, 
        "ap":user.ap, 
        "am":user.am,
        "rfc":user.rfc,
      });

    final decodeData = json.decode(response.body);
    print(decodeData);
    return true;
  }

   Future<bool> updatePhoto(ClientModel user) async{ 
    final url = "${AppConfig.base_url}/api/client/update_photo"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 
    
    final response = await http.post(
      url, 
      headers: headers,
      body: {
        "celular":user.celular,
        "url_imagen":user.urlImagen,  
      });

    final decodeData = json.decode(response.body);
    print(decodeData);
    return true;
  }

   Future<String> subirImagenCloudinary(File imagen) async{
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dtev8lpem/image/upload?upload_preset=f9k9os9d');
    final mimeType = mime(imagen.path).split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest( //peticion para subir el archivo
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath( //se carga el archivo
      'file', 
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    );

    imageUploadRequest.files.add(file);
    
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
        print('Algo salio mal');
        print(resp.body);
        return null;
    }

    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url'];
  } 

   Future<List<NotificacionModel>> cargarNotificaciones()async{
    final url = "${AppConfig.base_url}/api/client/notificationsAll"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(url, headers: headers,);

    print("NOTIFICACIONES RESPUESTA----------------");
    print(response.body);
    
    if(response.body.contains('message')){
      return [];
    } 

    final Map<dynamic,dynamic> decodeData = json.decode(response.body)['notificaciones'];  
    final List<NotificacionModel> notificaciones = List();


    Map notiMap = Map<String, NotificacionModel>();


    decodeData.forEach((id,notification){
       
      NotificacionModel notiTemp = NotificacionModel.fromJson(notification);  
      print(notiTemp); 
      notificaciones.add(notiTemp);
         
      notiMap.putIfAbsent(id, ()=>notiTemp); 

    }); 

    _dbProvider.insertNotification(notiMap); 
     
    if(decodeData==null) return [];
    return notificaciones; 
  }

   Future<List<NotificacionModel>> unReadNotifications()async{
    final url = "${AppConfig.base_url}/api/client/notifications"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);

    print(response.body); 
    
    if(response.body.contains('error')){
      return [];
    } 

    
     print("***********NOTIFICACIONES NO LEIDAS RESPUESTA-**************");
   
     if(response.body.contains("notificaciones") && response.body.contains("id")){
       final Map<dynamic,dynamic> decodeData = json.decode(response.body)['notificaciones'];
      final List<NotificacionModel> notifications = List();


      Map notifiMap = Map<String, NotificacionModel>();

    
      decodeData.forEach((id,notification){
        NotificacionModel notiTemp = NotificacionModel.fromJson(notification);
        notifications.add(notiTemp);
        notifiMap.putIfAbsent(id, ()=>notiTemp);
      });

      _dbProvider.insertNotification(notifiMap);
      if(decodeData==null) return [];
      return notifications; 
     }
    return [];
  }

   Future<List<NotificacionModel>> markAsReadNotifications(List<String> list) async{ 
    final url = "${AppConfig.base_url}/api/client/notifications_mark_as_read"; 
    final token = await _storage.read('token');
    
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Content-Type" : "application/json",
      "Accept": "application/json",}; 
    
    final response = await http.post(
      url, 
      headers: headers,
      body: json.encode( 
        {
        "notifications" :list ,
        }
        )
    );
    print("MARK AS READ****");
    print(response.body);

    if(response.body.contains("message")){
      return [];
    }

    if(response.body.contains("notifications") && response.body.contains("id")){
      final Map<dynamic,dynamic> decodeData = json.decode(response.body)['notifications'];
      final List<NotificacionModel> notifications = List();


      Map notifiMap = Map<String, NotificacionModel>();


      decodeData.forEach((id,notification){
        NotificacionModel notiTemp = NotificacionModel.fromJson(notification);
        notifications.add(notiTemp);
        //notifiMap.putIfAbsent(id, ()=>notiTemp);

        _dbProvider.markAsRead(notiTemp);
      });

      

      //_dbProvider.insertNotification(notifiMap);

      if(notifications.isNotEmpty)
      return notifications;
      else 
      return [];
    }
    return [];
  }



  //create fcm token
  Future<bool> fcmToken({@required  String fcmToken})async{
    print(">>>>>>>>>>>>> CREATE FCM TOKEN>>>>>>>>>>>>>>>>");
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};

    final url = "${AppConfig.base_url}/api/client/fcm_token";
    
    final response = await http.post(
      url,headers:headers ,
      body: {
        "fcm_token" : fcmToken ,}
      );
    
    Map<String,dynamic> decodedResp = jsonDecode(response.body);
    
    print("status ${response.statusCode}");
    print(response.body);
    if(decodedResp.containsKey('result')){ 
      return true;
    }else{
      return false;
    }
  }

  //delete_fcm_token
  Future<bool> deleteFcmToken({@required  String fcmToken})async{
    print(">>>>>>>>>>>>> DELETE FCM TOKEN>>>>>>>>>>>>>>>>");

    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};

    final url = "${AppConfig.base_url}/api/client/delete_fcm_token";
    
    final response = await http.post(
      url,headers:headers ,
      body: {
        "fcm_token" : fcmToken ,}
      );
    
    Map<String,dynamic> decodedResp = jsonDecode(response.body);
    
    print("STATUS: ${response.statusCode}");
    print(response.body);
    if(decodedResp.containsKey('result')){ 
    return true;
    }else{
      return false;
    }
  }
  

  Future<bool> updateName(ClientModel cliente) async{
    final url = "${AppConfig.base_url}/api/client/updateName"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 
    
    final response = await http.post(
      url, 
      headers: headers,
      body: {
        "celular":cliente.celular,
        "nombre":cliente.nombre,  
      });

    final decodeData = json.decode(response.body);
    print(decodeData);
    return true;
  }

  Future<bool> updateApaterno(ClientModel cliente) async{
    final url = "${AppConfig.base_url}/api/client/updatePaterno"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 
    
    final response = await http.post(
      url, 
      headers: headers,
      body: {
        "celular":cliente.celular,
        "ap":cliente.ap,  
      });

    final decodeData = json.decode(response.body);
    print(decodeData);
    return true;
  }

  Future<bool> updateAmaterno(ClientModel cliente) async{
    final url = "${AppConfig.base_url}/api/client/updateMaterno"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 
    
    final response = await http.post(
      url, 
      headers: headers,
      body: {
        "celular":cliente.celular,
        "am":cliente.am,  
      });

    final decodeData = json.decode(response.body);
    print(decodeData);
    return true;
  }

  Future<bool> updateRFC(ClientModel cliente) async{
    final url = "${AppConfig.base_url}/api/client/updateRfc"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 
    
    final response = await http.post(
      url, 
      headers: headers,
      body: {
        "celular":cliente.celular,
        "rfc":cliente.rfc,  
      });

    final decodeData = json.decode(response.body);
    print(decodeData);
    return true;
  }

   Future<bool> updateEmail(ClientModel cliente) async{
    final url = "${AppConfig.base_url}/api/client/updateEmail"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 
    
    final response = await http.post(
      url, 
      headers: headers,
      body: { 
        "email":cliente.correo,  
      });

    final decodeData = json.decode(response.body);
    print(decodeData);
    return true;
  }

  Future<bool> updateAddress(String direccion,String lat,String lng)async{
    final url = "${AppConfig.base_url}/api/client/direction"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 
    
    final response = await http.post(
      url, 
      headers: headers,
      body: { 
        "direccion":direccion,
        "lat" : lat,
        "lng" : lng  
      });

    final decodeData = json.decode(response.body);
    print(decodeData);
    return true;
  }

  
}