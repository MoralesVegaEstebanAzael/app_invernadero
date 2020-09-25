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
      (nombre.length>1)?sink.add(nombre):sink.addError("Ingrese este campo");
    }
  );

  final validarAp=StreamTransformer<String,String>.fromHandlers(
    handleData: (ap,sink){
      (ap.length>1)?sink.add(ap):sink.addError("Ingrese este campo");
    }
  );

  final validarAm=StreamTransformer<String,String>.fromHandlers(
    handleData: (am,sink){
      (am.length>1)?sink.add(am):sink.addError("Ingrese este campo");
    }
  );

 final validarRFC = StreamTransformer<String, String>.fromHandlers(
   handleData: (rfc, sink){ 
      bool rfcValid = 
      RegExp(r"^([A-ZÑ\x26]{3,4}([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])([A-Z]|[0-9]){2}([A]|[0-9]){1})?$").hasMatch(rfc);
      rfcValid?sink.add(rfc):sink.addError("RFC invalido");
   }
 );


 final validarToneladas=StreamTransformer<String,String>.fromHandlers(
    handleData: (t,sink){
       bool valid = 
      RegExp(r"^[0-9]{1,10}$").hasMatch(t);
      print("cantidad");
      
       if(valid){
        int x = int.parse(t);
        print("Value x $x");
        if(x>0)
          sink.add(t);
      }else{ 
          sink.addError(''); 
      }
      // (t.length>1)?sink.add(t):sink.addError("Ingrese este campo");
    }
  );
}