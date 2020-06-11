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
      String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
      bool b = RegExp(pattern).hasMatch(password);
      
      b?sink.add(password):sink.addError("error");
    }
  );


  final validarEmail=StreamTransformer<String,String>.fromHandlers(
    handleData: (email,sink){
      bool emailValid = 
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
      emailValid?sink.add(email):sink.addError("correo invalido");
    }
  );

 final validarNombre=StreamTransformer<String,String>.fromHandlers(
    handleData: (nombre,sink){
      (nombre.length>3)?sink.add(nombre):sink.addError("Ingrese mas de 3 caracteres");
    }
  );

 final validarRFC = StreamTransformer<String, String>.fromHandlers(
   handleData: (rfc, sink){ 
      bool rfcValid = 
      RegExp(r"^([A-ZÑ\x26]{3,4}([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])([A-Z]|[0-9]){2}([A]|[0-9]){1})?$").hasMatch(rfc);
      rfcValid?sink.add(rfc):sink.addError("RFC invalido");
   }
 );
}