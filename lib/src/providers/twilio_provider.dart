
import 'dart:convert';

import 'package:app_invernadero/src/models/client_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/push_notifications_provider.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../../app_config.dart';


class TwilioProvider{
  String apiKey;
  String apiSecret;
  String requestId;
  String number;

  final _storage = SecureStorage();  

  static TwilioProvider _instance =
      TwilioProvider.internal();

  TwilioProvider.internal();

  factory TwilioProvider() => _instance;

  // initNexmo(String apiKey, String apiSecret) {
  //   this.apiKey = apiKey;
  //   this.apiSecret = apiSecret;
  // }
 DBProvider _dbProvider = DBProvider();
  final fcm = PushNotificationsProvider();

  Future<Map<String,dynamic>> sendCode({@required String celular})async{
      Map<String, String> headers = {"Accept": "application/json"};
      final url = "${AppConfig.base_url}/api/client/send_code";
      final response = await http.post(
        url,
        headers: headers,
        body: {
          "number":celular,
          });
       print("reponse send code>>> ${response.body}");
      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      print("RESPUESTA DE VERIFICACION $decodedResp");
      if(decodedResp.containsKey('response') && decodedResp.containsKey('number')){ 
        //inicializar Request ID & number 
        
        ///this.requestId = decodedResp['request_id'];
        this.number = decodedResp['number'];
        
        //print("ASIGNANDO VALORES A REQUEST ID & NUMBER ${this.requestId} ${this.number}");
        return {'ok':true, 'request_id' : decodedResp['request_id']};
      }else{
        return {'ok':false, 'message' : decodedResp['message']};
      }
  }


  Future<Map<String,dynamic>> verify({@required String code})async{
      Map<String, String> headers = {"Accept": "application/json"};
      final url = "${AppConfig.base_url}/api/client/verify_code";
      final response = await http.post(
        url,
        headers: headers,
        body: {
          "verification_code" : code,
          "number":this.number,
          });
       print("reponse verify_>>> ${response.body}");
      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      
      
      if(decodedResp.containsKey('access_token')){ 
        //save token 
         ClientModel client = ClientModel.fromJson(jsonDecode(response.body)['client']);
        _dbProvider.insertClient(client);
        _storage.idClient = client.id;
        _storage.sesion = true;
        await fcm.subscribeToTopic(this.number);

        await fcm.subscribeToTopic(AppConfig.all_topic);

        
        await _storage.write('token',decodedResp['access_token']);
        return {'ok':true, 'access_token' : decodedResp['access_token']};
      }else{
        return {'ok':false, 'message' : decodedResp['message']};
      }
  }

  
  //RESEND CODE
  Future<Map<String,dynamic>> resend({@required String code})async{
      Map<String, String> headers = {"Accept": "application/json"};
      final url = "${AppConfig.base_url}/api/auth/verifyCode";
      final response = await http.post(
        url,
        headers: headers,
        body: {
          "apiKey":this.apiKey,
          "apiSecret" :this.apiSecret,
          "request_id":this.requestId,
          "code" : code
          });

      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      print(decodedResp);
      
      if(decodedResp.containsKey('access_token')){ 
        //save token 
        await _storage.write('token',decodedResp['access_token']);
        return {'ok':true, 'access_token' : decodedResp['access_token']};
      }else{
        return {'ok':false, 'message' : decodedResp['message']};
      }
  }
}

