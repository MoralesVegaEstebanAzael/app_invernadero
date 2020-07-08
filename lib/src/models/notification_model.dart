// To parse this JSON data, do
//
//     final notificacionModel = notificacionModelFromJson(jsonString);

import 'dart:convert';

import 'package:app_invernadero/app_config.dart'; 
import 'package:hive/hive.dart'; 
part 'notification_model.g.dart';
  
@HiveType(
  typeId: AppConfig.hive_type_8, adapterName: AppConfig.hive_adapter_8)

class NotificacionModel {
    @HiveField(0)
    String id;
    @HiveField(1)
    String type;
    @HiveField(2)
    String notifiableType;
    @HiveField(3)
    int notifiableId;
    @HiveField(4)
    dynamic data;
    @HiveField(5)
    String readAt;
    @HiveField(6)
    String createdAt;
    @HiveField(7)
    String updatedAt;

    NotificacionModel({
        this.id,
        this.type,
        this.notifiableType,
        this.notifiableId,
        this.data,
        this.readAt,
        this.createdAt,
        this.updatedAt,
    });

   

    factory NotificacionModel.fromJson(Map<String, dynamic> json) => NotificacionModel(
        id: json["id"],
        type: json["type"],
        notifiableType: json["notifiable_type"],
        notifiableId: json["notifiable_id"],
        data: json["data"],
        readAt: json["read_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "notifiable_type": notifiableType,
        "notifiable_id": notifiableId,
        "data": data,
        "read_at": readAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };

    NotificacionModel notificacionModelFromJson(String str) => NotificacionModel.fromJson(json.decode(str));
    
    String notificacionModelToJson(NotificacionModel data) => json.encode(data.toJson());

   
}
