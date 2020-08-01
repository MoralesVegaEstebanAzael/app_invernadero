import 'package:http/http.dart' as http; 
import 'dart:convert' as convert;
import 'package:http_auth/http_auth.dart';

class PaypalServices {

  String domain = "https://api.sandbox.paypal.com"; // para el modo sandbox
//  String domain = "https://api.paypal.com"; // para el modo de producción

   // cambia clientId y secret con el tuyo, proporcionado por paypal
  String clientId = 'Aa17bclvjigT1BuNE1swI5kbDeJ9WTReQmYblCmDO0et1yB17tP9PdwhvKjQPQometJoGEfyufBx3mui';
  String secret = 'EMFYzQCgUUuS5YhP36W49t1ufVpFn4cMDThNTTYojwqOvg-ZofzXmxk-wSPamhHCm62Sd7lwS4NDi5Vo';

  // para obtener el token de acceso de Paypal
  Future<String> getAccessToken() async {
    try {
      var client = BasicAuthClient(clientId, secret);
      var response = await client.post('$domain/v1/oauth2/token?grant_type=client_credentials');
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // para crear la solicitud de pago con Paypal
  Future<Map<String, String>> createPaypalPayment(
      transactions, accessToken) async {
    try {
      var response = await http.post("$domain/v1/payments/payment",
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  // para ejecutar la transacción de pago
  Future<String> executePayment(url, payerId, accessToken) async {
    try {
      var response = await http.post(url,
          body: convert.jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return body["id"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}