import 'package:app_invernadero/app_config.dart';
import 'package:hive/hive.dart';
part 'status.g.dart';


@HiveType(
  typeId: AppConfig.hive_type_19,adapterName: AppConfig.hive_adapter_19)

class Status {
    @HiveField(0)
    int idPedido;
    @HiveField(1)
    String estatus;
    @HiveField(2)
    DateTime createdAt;
    @HiveField(3)
    DateTime updatedAt;
    
    Status({
        this.idPedido,
        this.estatus,
        this.createdAt,
        this.updatedAt,
    });

    factory Status.fromJson(Map<String, dynamic> json) => Status(
        idPedido: json["id_pedido"],
        estatus: json["estatus"],
        createdAt: json["created_at"]!=null? DateTime.parse(json["created_at"]):null,
        updatedAt: json["updated_at"]!=null? DateTime.parse(json["updated_at"]):null,
    );

    Map<String, dynamic> toJson() => {
        "id_pedido": idPedido,
        "estatus": estatus,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}