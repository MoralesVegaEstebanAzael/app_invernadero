import 'dart:io';
import 'package:app_invernadero/src/blocs/client_bloc.dart'; 
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/client_model.dart'; 
import 'package:app_invernadero/src/theme/theme.dart'; 
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';  

class UserDetallePage extends StatefulWidget { 
  @override
  _UserDetallePageState createState() => _UserDetallePageState();
}

class _UserDetallePageState extends State<UserDetallePage> {
  
  final TextStyle _style =  TextStyle(color:Colors.grey,fontSize:18);
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _guardando = false;
 
  ClientModel user = new ClientModel();
  File foto;

  ClientBloc clientBloc;
  Responsive responsive;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies(); 
    
    clientBloc = Provider.clientBloc(context);

    responsive = Responsive.of(context);

    final ClientModel userData = ModalRoute.of(context).settings.arguments;
    if (userData != null) {
      user = userData;
    }


  }

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      key: scaffoldKey,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),  
                SizedBox(height:responsive.ip(6)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Datos personales", style:TextStyle(fontFamily: 'Varela',fontSize:responsive.ip(2),color:Color(0xFF545D68))),
                    Text("* Campos obligatorios", style:TextStyle(fontFamily: 'Varela',fontSize:responsive.ip(1.5),color:Colors.grey)),
               
                  ],
                ),
                _crearNombre(clientBloc),
                _crearApellidoP(clientBloc),
                _crearApellidoM(clientBloc),
                _crearRFC(clientBloc),
                SizedBox(height:responsive.ip(6)),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _appBar(){
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0, 
      iconTheme: IconThemeData(
        color:Color(0xFF545D68) //change your color here
      ),
      title: Text("Actualizar datos personales",
        style:TextStyle(
          fontFamily: 'Varela',fontSize:responsive.ip(2.3),color:Color(0xFF545D68)
        ) ,
       ),
      leading: Container(
        margin: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black12,
            shape: BoxShape.circle,
          ),
        child: IconButton(
          icon: Icon(LineIcons.angle_left, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ), 
      );
  }
  Widget _crearNombre(ClientBloc clientBloc){
    return StreamBuilder(
      stream: clientBloc.nombreStream , 
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(
          textAlign: TextAlign.end,
          initialValue: user.nombre,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd))),
              enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd)),),
              hintStyle: TextStyle(color:Colors.grey), 
              labelStyle: _style,
              labelText: 'Nombre *', 
              errorText: snapshot.error
          ),
          onSaved: (value) => user.nombre = value, 
          onChanged: clientBloc.changeNombre,
          validator: (value){
            if(value.length < 3){
              return 'Ingrese su nombre';
            }else { return null;}
          },
        ); 
      },
    );
  }

  Widget _crearApellidoP(ClientBloc clientBloc){ 
    return StreamBuilder(
      stream: clientBloc.apellidoPStream, 
      builder: (BuildContext context, AsyncSnapshot snapshot){
         return TextFormField(
          textAlign: TextAlign.end,
          initialValue: user.ap,
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
          onSaved: (value) => user.ap = value,
          onChanged: clientBloc.changeApellidoP,
          validator: (value){
            if(value.length < 3){
              return 'Ingrese su apellido paterno';
            }else { return null;}
          },
        );  
      },
    );
  }

  Widget _crearApellidoM(ClientBloc clientBloc){
    return StreamBuilder(
      stream: clientBloc.apellidoMStream, 
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(
          textAlign: TextAlign.end,
          initialValue: user.am,
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
          onSaved: (value) => user.am = value,
          onChanged: clientBloc.chanfeApellidoM,
          validator: (value){
            if(value.length < 3){
              return 'Ingrese su apellido materno';
            }else { return null;}
          },
        );   
      },
    );
  }

  Widget _crearRFC(ClientBloc clientBloc){
    return StreamBuilder(
      stream: clientBloc.rfcStream , 
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(
          textAlign: TextAlign.end,
          initialValue: user.rfc,
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
              //counterText: snapshot.data,
              errorText: snapshot.error
          ),
          onSaved: (value) => user.rfc = value,
          onChanged: clientBloc.changeRFC,
          validator: (value){
            if(value.length < 13){
              return 'Ingrese su RFC';
            }else { return null;}
          },
        );
      },
    );
  } 

  Widget _mostrarFoto(){     
    if(user.urlImagen != null){      
      return Stack(
        alignment: const Alignment(0.8, 1.0),
        children: <Widget>[
           ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              height: 150,
              width: 150,
              child: FadeInImage(
              image: NetworkImage(user.urlImagen),
              placeholder: AssetImage('assets/jar-loading.gif'), 
              fit: BoxFit.fill,
          ),
        ),
       ),
       Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: miTema.accentColor,
            ),         
            child: IconButton(
                icon: Icon(LineIcons.camera, color:Colors.white, size: 30,), 
                onPressed: _selectFoto,
              ),
          ),
      ],
      );
      
     
    }else {
      return Stack(
        alignment: const Alignment(0.8, 1.0),
        children: <Widget>[          
            Container(
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(image: AssetImage(foto?.path ?? 'assets/no-image.png'), fit: BoxFit.cover ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: miTema.accentColor,
            ),         
            child: IconButton(
                icon: Icon(LineIcons.camera, color:Colors.white, size: 30,), 
                onPressed: _selectFoto  
              ),
          ),
        ],
      );
    }
  }

  _selectFoto() async{
    _procesarImagen(ImageSource.gallery);   
  }
 
  _procesarImagen(ImageSource origen) async{
    foto = await ImagePicker.pickImage(
      source: origen
    ); 
    if(foto != null){ 
      user.urlImagen = null; //limpieza para redibujar la nueva foto
    } 
    setState(() {
      _guardarImagen();
    });
  }

  _guardarImagen() async{
    if (foto != null) {
      user.urlImagen = await clientBloc.subirFoto(foto);
      clientBloc.updateImagen(user.urlImagen);
      print("++++++++++++++++++++++++++++");
      print(user.urlImagen);
    }
  }

  void mostrarSnackbar(String mensaje){
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
      backgroundColor: miTema.accentColor,
    );
    scaffoldKey.currentState.showSnackBar(snackbar);

  }

  Widget _crearBoton(){
    //formValidStream
    return Center(      
      child: RoundedButton(
        label: 'Guardar', 
        onPressed: (_guardando) ? null : _submit,        
      ),
    ); 
  }

  void _submit() async{
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save(); //guardar la informacon de todos los textfield


     setState(() { _guardando = true; });

    

    if (user.id == null) {
      print('crear producto');
    }else{
      print('actualizar usuario'); 
      print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(user.nombre);
      print(user.ap);
      print(user.am);
      print(user.urlImagen);
      print(user.id);
      print(user.lat);
      clientBloc.updateDatos(user.nombre, user.ap, user.am, user.rfc);

      //TODO: ACTUALIZAR LOS DATOS DEL USUARIO
      //userBloc.editarUser(user);
      //userProvider.updateDatosUser(user);
    }

    setState(() { _guardando = false; });
    mostrarSnackbar('Datos actualizados');
    Navigator.pop(context);
   /* setState(() {
      userBloc.cargarUsuario();

    });*/
  }
}