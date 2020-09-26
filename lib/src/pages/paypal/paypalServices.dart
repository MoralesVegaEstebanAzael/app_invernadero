import 'package:app_invernadero/src/blocs/shopping_cart_bloc.dart';
import 'package:app_invernadero/src/providers/pedido_provider.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert' as convert;
import 'package:http_auth/http_auth.dart';

class PaypalServices {
  ShoppingCartBloc shoppingCartBloc = new ShoppingCartBloc();
  String domain = "https://api.sandbox.paypal.com"; // para el modo sandbox
//  String domain = "https://api.paypal.com"; // para el modo de producción

   // cambia clientId y secret con el tuyo, proporcionado por paypal
  String clientId = 'AVsqxAnwQEjLVzx2m3LQMjQakMAHRcCVko4ZJVoHoMGNC7hd1rfQCFuunmAPwWYdpYdXVlYC4AFRe867';
  String secret = 'EKCWBlxqAiIs41MxHC67vpoDsVa_HmytcpRJFMBCH9B0sz0-PLFxAzxM7tQpfdEuoSayHwyrMXhk7CNh';

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
        print("****Todo ha salido bien enviar pedido al sistema*******");
        
        sendPedido().then((v){
            
        });

        return body["id"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }


  Future<void> sendPedido()async{
    print("*******ENVIANDO PEDIDODO");
    PedidoProvider pp = PedidoProvider();
      bool f = await pp.pedido(
        shoppingCartBloc.listItemPaypalValue,
        shoppingCartBloc.tipoEnvioValue,
        shoppingCartBloc.tipoEntregaValue
        );
    if(f)shoppingCartBloc.onChangeIsLoading(true);
    else shoppingCartBloc.onChangeIsLoading(false);

    print("******end pedido");
  }
 
}