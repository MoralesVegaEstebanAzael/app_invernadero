
import 'package:hive/hive.dart';

import '../../../app_config.dart';
part 'geometry_model.g.dart';
@HiveType(
  typeId: AppConfig.hive_type_11,adapterName: AppConfig.hive_adapter_11)
class Geometry {
    Geometry({
        this.type,
        this.coordinates,
    });
    @HiveField(0)
    String type;
    @HiveField(1)
    List<double> coordinates;

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    };
}