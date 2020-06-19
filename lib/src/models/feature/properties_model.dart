
import 'package:hive/hive.dart';

import '../../../app_config.dart';
part 'properties_model.g.dart';
@HiveType(
  typeId: AppConfig.hive_type_14,adapterName: AppConfig.hive_adapter_14)

class Properties {
    Properties({
        this.accuracy,
    });
    
    @HiveField(0)
    String accuracy;

    factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        accuracy: json["accuracy"],
    );

    Map<String, dynamic> toJson() => {
        "accuracy": accuracy,
    };
}