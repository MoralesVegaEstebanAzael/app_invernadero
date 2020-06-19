import 'package:hive/hive.dart';

import '../../../app_config.dart';
part 'context_model.g.dart';

@HiveType(
  typeId: AppConfig.hive_type_12,adapterName: AppConfig.hive_adapter_12)

class Context {
    Context({
        this.id,
        this.text,
        this.wikidata,
        this.shortCode,
    });
    @HiveField(0)
    String id;
    @HiveField(1)
    String text;
    @HiveField(2)
    String wikidata;
    @HiveField(3)
    String shortCode;

    factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: json["id"],
        text: json["text"],
        wikidata: json["wikidata"] == null ? null : json["wikidata"],
        shortCode: json["short_code"] == null ? null : json["short_code"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "wikidata": wikidata == null ? null : wikidata,
        "short_code": shortCode == null ? null : shortCode,
    };
}