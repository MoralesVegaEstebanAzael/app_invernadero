import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:hive/hive.dart';
part 'favorite_model.g.dart';

@HiveType(
  typeId: AppConfig.hive_type_7,adapterName: AppConfig.hive_adapter_7)

class FavoriteModel{
  @HiveField(0)
  ProductoModel producto;
  
  FavoriteModel({
    this.producto,
  }
  );
}


