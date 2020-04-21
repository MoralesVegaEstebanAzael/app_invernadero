import 'dart:async';

class Validators{

  final validarTelefono=StreamTransformer<String,String>.fromHandlers(
    handleData: (telefono,sink){
      if(telefono.length>0){
        sink.add(telefono);
      }else{
        sink.addError('Teléfono incorrecto');
      }
    }
  );

  
  final validarPassword=StreamTransformer<String,String>.fromHandlers(
    handleData: (password,sink){
      if(password.length>=6){
        sink.add(password);
      }else{
        sink.addError('Más de 6 caracteres');
      }
    }
  );
  

  /*
  
  */
}