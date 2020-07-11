import 'package:app_invernadero/app_config.dart';
import 'package:hive/hive.dart';
part 'detalle.g.dart';


@HiveType(
  typeId: AppConfig.hive_type_16,adapterName: AppConfig.hive_adapter_16)


class Detalle {
    @HiveField(0)
    int idPedido;
    @HiveField(1)
    String nombreProducto;
    @HiveField(2)
    double cantidadPedido;
    @HiveField(3)  
    int cantidadSurtida;
    @HiveField(4)
    int idProducto;
    @HiveField(5)
    String unidadM;
    @HiveField(6)
    double precioUnitario;
    @HiveField(7)
    double subtotal;
    
    Detalle({
        this.idPedido,
        this.nombreProducto,
        this.cantidadPedido,
        this.cantidadSurtida,
        this.idProducto,
        this.unidadM,
        this.precioUnitario,
        this.subtotal,
    });

    

    factory Detalle.fromJson(Map<String, dynamic> json) => Detalle(
        idPedido: json["idPedido"],
        nombreProducto: json["nombreProducto"],
        cantidadPedido: json["cantidadPedido"].toDouble(),
        cantidadSurtida: json["cantidadSurtida"],
        idProducto: json["idProducto"],
        unidadM: json["unidadM"],
        precioUnitario: json["precioUnitario"].toDouble(),
        subtotal: json["subtotal"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "idPedido": idPedido,
        "nombreProducto": nombreProducto,
        "cantidadPedido": cantidadPedido,
        "cantidadSurtida": cantidadSurtida,
        "idProducto": idProducto,
        "unidadM": unidadM,
        "precioUnitario": precioUnitario,
        "subtotal": subtotal,
    };
}