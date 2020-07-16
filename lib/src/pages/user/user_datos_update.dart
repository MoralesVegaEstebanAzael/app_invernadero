import 'package:app_invernadero/src/blocs/client_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/client_model.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/my_appbar.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class DetalleDatosUpdate extends StatefulWidget {
  DetalleDatosUpdate({Key key}) : super(key: key);

  @override
  _DetalleDatosUpdateState createState() => _DetalleDatosUpdateState();
}

class _DetalleDatosUpdateState extends State<DetalleDatosUpdate> {
  final TextStyle _style =  TextStyle(color:Colors.grey, fontSize:20 ,fontFamily: 'Quicksand',fontWeight: FontWeight.w700);
  Responsive responsive;
  ClientBloc clientBloc;
  ClientModel cliente = new ClientModel();
  String opcion;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    clientBloc = Provider.clientBloc(context);
    responsive = Responsive.of(context); 

    List data = ModalRoute.of(context).settings.arguments;
    if(data != null){
      opcion = data[0]; 
      cliente = data[1]; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Editar datos"),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column( 
          children: <Widget>[
            _opciones(opcion),
            SizedBox(height: responsive.ip(4),),
            _crearBoton(opcion)
          ],
        ),
      ),
    );
  }
 
  Widget _opciones(String input){  
     switch (input) {
       case 'nombre':
          return _nombre();
        break;
        
        case 'ap':
          return _apPaterno();
        break;
        
        case 'am':
          return _apMaterno();
        break; 

        case 'rfc':
          return _rfc();
        break;

        case 'email':
          return _email();
        break;  
       default:
     }
  } 

  Widget _nombre(){
    return StreamBuilder(
      stream: clientBloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(  
          initialValue: cliente.nombre,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd))),
              enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd)),),
              hintStyle: TextStyle(color:Colors.grey), 
              labelText: 'Nombre *', 
              labelStyle: _style,
              errorText: snapshot.error
          ), 
          onChanged: clientBloc.changeName, 
        );
      },
    );
  }

  Widget _apPaterno(){
   return StreamBuilder(
      stream: clientBloc.apStream, 
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(  
          initialValue: cliente.ap,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd))),
              enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd)),),
              hintStyle: TextStyle(color:Colors.grey), 
              labelText: 'Apellido paterno *', 
              labelStyle: _style,
              errorText: snapshot.error
          ), 
          onChanged: clientBloc.changeAp, 
        );
      },
    );
  }
  Widget _apMaterno(){
    return StreamBuilder(
      stream: clientBloc.amStream, 
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(  
          initialValue: cliente.am,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd))),
              enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd)),),
              hintStyle: TextStyle(color:Colors.grey), 
              labelText: 'Apellido materno *',
              labelStyle: _style,
              errorText: snapshot.error
          ), 
          onChanged: clientBloc.changeAm, 
        );
      },
    );
  }
  Widget _rfc(){
    return StreamBuilder(
      stream: clientBloc.rfStream, 
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(  
          initialValue: cliente.rfc,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd))),
              enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd)),),
              hintStyle: TextStyle(color:Colors.grey), 
              labelText: 'RFC *',
              labelStyle: _style,
              errorText: snapshot.error
          ), 
          onChanged: clientBloc.changeR, 
        );
      },
    );
  }

    _email(){ 
    return StreamBuilder(
      stream: clientBloc.emailStream, 
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(  
          initialValue: cliente.correo,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd))),
              enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd)),),
              hintStyle: TextStyle(color:Colors.grey), 
              labelText: 'Email *',
              labelStyle: _style,
              errorText: snapshot.error
          ), 
          onChanged: clientBloc.changEmail, 
        );
      },
    ); 
  }

  Widget _crearBoton(String opcion){
   Stream stream ; 
   if(opcion == 'nombre'){
     stream = clientBloc.nameStream;
   }else if(opcion == 'ap'){
     stream = clientBloc.apStream;
   }else if(opcion == 'am'){
     stream = clientBloc.amStream;
   }else if(opcion == 'rfc'){
     stream= clientBloc.rfStream;
   }else if(opcion == 'email'){
     stream = clientBloc.emailStream;
   }

    return  StreamBuilder(
      stream: stream, 
      builder: (BuildContext context, AsyncSnapshot snapshot){
       return  RoundedButton(
         label: 'Guardar', 
         onPressed: snapshot.hasData ? () => _submit(opcion) : null,      
      );
      },
    );
  }


  void _submit(String input){  
    print('actualizar usuario');  
    print("+++++++++++++++++++++++++++++++++");  
     switch (input) {
       case 'nombre':
          clientBloc.updateNameLocal(clientBloc.nombre);
          clientBloc.updateNameCliente(cliente);
          Navigator.pop(context); 
        break;
        case 'ap': 
          clientBloc.updateApaternoLocal(clientBloc.apellidoP);
          clientBloc.updatePaternoCliente(cliente);
          Navigator.pop(context);
        break;
        
        case 'am': 
          clientBloc.updateAmaternoLocal(clientBloc.apellidoM);
          clientBloc.updateMaternoCliente(cliente);
          Navigator.pop(context);
        break; 

        case 'rfc': 
          clientBloc.updateRFCLocal(clientBloc.rfc);
          clientBloc.updateRFCliente(cliente);
          Navigator.pop(context);
        break;

        case 'email':
          clientBloc.updateEmailLocal(clientBloc.email);
          clientBloc.updatEmailCliente(cliente);
          Navigator.pop(context);
        break;  
       default:
     } 
   
  }
}