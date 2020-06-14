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

    clientBloc.initialData(user);

  }

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
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
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30.0),
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
                SizedBox(height:responsive.ip(1)),
                StreamBuilder(
                  stream: clientBloc.nombreStream ,  
                  initialData: user.nombre,
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    return  
                    _inputText(user.nombre, 'Nombre *', snapshot.error, clientBloc.changeNombre);
                  },
                ),

                SizedBox(height:responsive.ip(1)),
                StreamBuilder(
                  stream: clientBloc.apellidoPStream , 
                  initialData: user.ap,
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    return  
                    _inputText(user.ap,'Apellido paterno *', snapshot.error, clientBloc.changeApellidoP);
                  },
                ),

                SizedBox(height:responsive.ip(1)),
                StreamBuilder(
                  stream: clientBloc.apellidoMStream , 
                  initialData: user.am,
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    return  
                    _inputText(user.am, 'Apellido materno *', snapshot.error, clientBloc.chanfeApellidoM);
                  },
                ),

                SizedBox(height:responsive.ip(1)),   
                StreamBuilder(
                  stream: clientBloc.rfcStream ,  
                  initialData: user.rfc,
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    return  
                     _inputText(user.rfc, "RFC *", snapshot.error, clientBloc.changeRFC);
                  },
                ), 

                SizedBox(height:responsive.ip(6)),
                StreamBuilder(
                  stream: clientBloc.formValidStream, 
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    return  RoundedButton(
                      label: 'Guardar', 
                      onPressed:  snapshot.hasData ? () => _submit() : null,
                      //_submit,        
                    );
                  },
                ),
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
 
  Widget _inputText(String rfc,String label, String errorText,Function(String) func){  
    return TextFormField(  
          initialValue: rfc,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd))),
              enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd)),),
              hintStyle: TextStyle(color:Colors.grey),
              labelText: label,
              labelStyle: _style, 
              errorText: errorText
          ), 
          onChanged: func, 
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
      print("------------------------");
      //clientBloc.updatePhoto(user.urlImagen); 
      print("------------------------");
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

  void _submit() async{
   if (!formKey.currentState.validate()) return;
    formKey.currentState.save(); //guardar la informacon de todos los textfield

       //TODO: ACTUALIZAR LOS DATOS DEL USUARIO
      print('actualizar usuario'); 
      clientBloc.updateDatos(clientBloc.nombre, clientBloc.apellidoP, clientBloc.apellidoM, clientBloc.rfc);
      print("+++++++++++++++++++++++++++++++++");
      //userProvider.updateDatosUser(user);
      clientBloc.updateInfoCliente(user);      
      print("+++++++++++++++++++++++++++++++++"); 
    

    //setState(() { _guardando = false; });
    mostrarSnackbar('Datos actualizados');
    Navigator.pop(context);
   /* setState(() {
      userBloc.cargarUsuario();

    });*/
  }
}