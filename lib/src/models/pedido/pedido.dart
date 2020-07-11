import 'package:app_invernadero/app_config.dart';
import 'package:hive/hive.dart';
part 'pedido.g.dart';


@HiveType(
  typeId: AppConfig.hive_type_15,adapterName: AppConfig.hive_adapter_15)

class Pedido {
  @HiveField(0)
  int id;
  @HiveField(1)
  int idCliente;
  @HiveField(2)
  DateTime fechaSolicitud;
  @HiveField(3)
  String estatus;
  @HiveField(4)
  int total;
  @HiveField(5)
  DateTime createdAt;
  @HiveField(6)
  DateTime updatedAt;
  @HiveField(7)
  int idVenta;
  @HiveField(8)
  int totalPagado;


    Pedido({
        this.id,
        this.idCliente,
        this.fechaSolicitud,
        this.estatus,
        this.total,
        this.createdAt,
        this.updatedAt,
        this.idVenta,
        this.totalPagado,
    });
    

    factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
        id: json["id"],
        idCliente: json["id_cliente"],
        fechaSolicitud: DateTime.parse(json["fechaSolicitud"]),
        estatus: json["estatus"],
        total: json["total"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        idVenta: json["idVenta"],
        totalPagado: json["totalPagado"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_cliente": idCliente,
        "fechaSolicitud": "${fechaSolicitud.year.toString().padLeft(4, '0')}-${fechaSolicitud.month.toString().padLeft(2, '0')}-${fechaSolicitud.day.toString().padLeft(2, '0')}",
        "estatus": estatus,
        "total": total,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "idVenta": idVenta,
        "totalPagado": totalPagado,
    };
}