import 'dart:core';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/blocs/shopping_cart_bloc.dart';
import 'package:app_invernadero/src/models/item_shopping_cart_model.dart';
import 'package:app_invernadero/src/pages/paypal/paypalServices.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart'; 
import 'package:webview_flutter/webview_flutter.dart'; 

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  final List<dynamic> list;
  final String totalAmount;
  final String subTotalAmount;
  final String shippingCost;
  final  int shippingDiscountCost;
  final  String userFirstName;
  final  String userLastName;
  final  String addressCity;
  final  String addressStreet;
  final  String addressZipCode;
  final  String addressCountry;
  final  String addressState;
  final  String addressPhoneNumber;
  final  int tipoEnvio;
  final String tipoEntrega;
  final List<ItemShoppingCartModel> itemFinal;

  PaypalPayment({this.onFinish, this.totalAmount, this.subTotalAmount, this.shippingCost, this.shippingDiscountCost, this.userFirstName, this.userLastName, this.addressCity, this.addressStreet, this.addressZipCode, this.addressCountry, this.addressState, this.addressPhoneNumber, this.list, this.tipoEntrega, this.itemFinal, this.tipoEnvio});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  PaypalServices services = PaypalServices();
  ShoppingCartBloc _shoppingCartBloc;
 // puedes cambiar la moneda predeterminada según tus necesidades
  Map<dynamic,dynamic> defaultCurrency = {"symbol": "MXN ", "decimalDigits": 2, "symbolBeforeTheNumber": true, "currency": "MXN"};

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL= 'cancel.example.com';


  @override
  void initState() {
    super.initState();

    ShoppingCartBloc shoppingCartBloc = new ShoppingCartBloc();
    shoppingCartBloc.onChangeItemsPayPal(widget.itemFinal);
    shoppingCartBloc.onChangeTipoEntrega(widget.tipoEntrega);
    shoppingCartBloc.onChangeTipoEnvioPayPal(widget.tipoEnvio);
    
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
     
      }catch (e) {
        print('exception: '+ e.toString() );
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _shoppingCartBloc = Provider.shoppingCartBloc(context);
  }
  // nombre del artículo, precio y cantidad
  String itemName = 'iPhone X';
  String itemPrice = '600.00';
  int quantity = 1;

  Map<String, dynamic> getOrderParams() {
    // List items = [
    //   {
    //     "name": "jitomate",
    //     "quantity": quantity,
    //     "price": itemPrice,
    //     "currency": defaultCurrency["currency"]
    //   }
    // ];

    List items = this.widget.list;
    // checkout invoice details
    // checkout invoice details
    String totalAmount = this.widget.totalAmount;//'2.99';
    String subTotalAmount =this.widget.subTotalAmount;// '2.99';
    String shippingCost = this.widget.shippingCost;// '0';
    int shippingDiscountCost = this.widget.shippingDiscountCost;//0;
    String userFirstName = this.widget.userFirstName;
    String userLastName =this.widget.userLastName;
    String addressCity =this.widget.addressCity;
    String addressStreet = this.widget.addressStreet;
    String addressZipCode = this.widget.addressZipCode;
    String addressCountry =this.widget.addressCountry;
    String addressState = this.widget.addressState;
    String addressPhoneNumber = this.widget.addressPhoneNumber;

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount":
                  ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping &&
                isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName +
                    " " +
                    userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {
        "return_url": returnURL,
        "cancel_url": cancelURL
      }
    };
    
    return temp;
  }
  GlobalKey _scaffold = GlobalKey();
  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);

    final nav = Navigator.of(context);
    if (checkoutUrl != null) {
      return Scaffold(
        key: _scaffold,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                services
                  .executePayment(executeUrl, payerID, accessToken)
                  .then((id) {
                  
                  widget.onFinish(id);
                  //  Navigator.of(context).pop();
                  
                });
              } else {
                Navigator.of(context).pop();
              }
              Navigator.of(context).pop();
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}
