class AppConfig{
  static const base_url = 'http://yurtapp.herokuapp.com';

  static const nexmo_api_key = '965b8d2e';
  static const nexmo_secret_key='161Yk6mqvbxT1Wgo';
  static const nexmo_country_code='52';
  static const String  nexmo_business_name= "SA Invernadero";

  static const int venta_mayoreo=10;
  static const String uni_medida= "Kg/Caja";
  /** serve heroku ps:exec -a yurtapp
   *  php artisan passport:keys
  */
}