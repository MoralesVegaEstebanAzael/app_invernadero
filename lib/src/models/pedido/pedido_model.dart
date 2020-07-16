// To parse this JSON data, do
//
//     final pedidoModel = pedidoModelFromJson(jsonString);
import 'dart:convert';

import 'package:app_invernadero/src/models/pedido/pedido.dart';

import 'detalle.dart';

import 'package:app_invernadero/app_config.dart';
import 'package:hive/hive.dart';
part 'pedido_model.g.dart';


@HiveType(
  typeId: AppConfig.hive_type_17 ,adapterName: AppConfig.hive_adapter_17)

class PedidoModel {
  @HiveField(0)
    Map<String, Pedido> pedidos;

    PedidoModel({
        this.pedidos,
    });

    factory PedidoModel.fromJson(Map<String, dynamic> json) => PedidoModel(
        pedidos: Map.from(json["pedidos"]).map((k, v) => MapEntry<String, Pedido>(k, Pedido.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "pedidos": Map.from(pedidos).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };

    PedidoModel pedidoModelFromJson(String str) => PedidoModel.fromJson(json.decode(str));

    String pedidoModelToJson(PedidoModel data) => json.encode(data.toJson());
}



// class PedidoModel {
//   @HiveField(0)
//   Pedido pedido;
//   @HiveField(1)
//   Map<String, Detalle> detalles;
  
//   PedidoModel({
//         this.pedido,
//         this.detalles,
//     });

    

//     factory PedidoModel.fromJson(Map<String, dynamic> json) => PedidoModel(
//         pedido: Pedido.fromJson(json["pedido"]),
//         detalles: Map.from(json["detalles"]).map((k, v) => MapEntry<String, Detalle>(k, Detalle.fromJson(v))),
//     );

//     Map<String, dynamic> toJson() => {
//         "pedido": pedido.toJson(),
//         "detalles": Map.from(detalles).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
//     };


//   PedidoModel pedidoModelFromJson(String str) => PedidoModel.fromJson(json.decode(str));
//   String pedidoModelToJson(PedidoModel data) => json.encode(data.toJson());
// }

