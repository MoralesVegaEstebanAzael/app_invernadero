import 'dart:io';
 
import 'package:app_invernadero/src/blocs/login_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/userModel.dart';  
import 'package:app_invernadero/src/theme/theme.dart'; 
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart'; 
import 'package:app_invernadero/src/blocs/validators.dart' as validator;

class UserDetallePage extends StatefulWidget { 
  @override
  _UserDetallePageState createState() => _UserDetallePageState();
}

class _UserDetallePageState extends State<UserDetallePage> {
  
  final TextStyle _style =  TextStyle(color:Colors.grey,fontSize:18);
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _guardando = false;

  LoginBloc userBloc;
  UserModel user = new UserModel();  
  File foto;

  @override
  Widget build(BuildContext context) {
    userBloc = Provider.of(context);

    final UserModel userData = ModalRoute.of(context).settings.arguments;
    if (userData != null) {
      user = userData;
    }

    Responsive responsive = Responsive.of(context);
    
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0, 
      iconTheme: IconThemeData(
        color:Color(0xFF545D68) //change your color here
      ),
      title: Text("Editar perfil",
        style:TextStyle(
          fontFamily: 'Varela',fontSize:responsive.ip(3),color:Color(0xFF545D68)
        ) ,
      ),
        actions: <Widget>[
          IconButton(
            icon: Icon(LineIcons.picture_o, color:Color(0xFF545D68), size: 28,), 
            onPressed: _selectFoto,
          ),
          IconButton(
            icon: Icon(LineIcons.camera, color:Color(0xFF545D68), size: 30,), 
            onPressed: _tomarFoto,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(), 
                _crearNombre(),
                _crearCorreo(),
                SizedBox(height:responsive.ip(6)),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre(){
    return TextFormField(
      initialValue: user.name,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          focusedBorder:  UnderlineInputBorder(      
                          borderSide: BorderSide(color:Color(0xffdddddd))),
          enabledBorder: UnderlineInputBorder(      
                          borderSide: BorderSide(color:Color(0xffdddddd)),),
          hintStyle: TextStyle(color:Colors.grey),
          labelText: 'Nombre',
          labelStyle: _style
      ),
      onSaved: (value) => user.name = value,
      validator: (value){
        if(value.length < 3){
          return 'Ingrese un nombre de usuario';
        }else { return null;}
      },
    );

  }

  Widget _crearCorreo(){
    return TextFormField(
      initialValue: user.email,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          focusedBorder:  UnderlineInputBorder(      
                          borderSide: BorderSide(color:Color(0xffdddddd))),
          enabledBorder: UnderlineInputBorder(      
                          borderSide: BorderSide(color:Color(0xffdddddd)),),
          hintStyle: TextStyle(color:Colors.grey),
          labelText: 'Correo eletrónico',
          labelStyle: _style
      ),
      onSaved: (value) => user.email = value,
      validator: (value){
        Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp = new RegExp(pattern);

        if(regExp.hasMatch(value)){
           return null;
        }else {
          return 'Correo invalido';
        }
      },
    );
  }

  Widget _crearBoton(){
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

    if (foto != null) {
      user.urlAvatar = await userBloc.subirFoto(foto);
      print(user.urlAvatar);
    }

    if (user.id == null) {
      print('crear producto');
    }else{
      print('actualizar usuario'); 
      userBloc.editarUser(user);
      //userProvider.updateDatosUser(user);
    }

    //setState(() { _guardando = false; });
    mostrarSnackbar('Datos actualizados');
    Navigator.pop(context);
    setState(() {
      userBloc.cargarUsuario();

    });
  }

  
  Widget _mostrarFoto(){
    if(user.urlAvatar != null){
      return ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              height: 150,
              width: 150,
              child: FadeInImage(
              image: NetworkImage(user.urlAvatar),
              placeholder: AssetImage('assets/jar-loading.gif'), 
              fit: BoxFit.fill,
          ),
            ),
      );
    }else {
      return Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          image: DecorationImage(image: AssetImage(foto?.path ?? 'assets/no-image.png'), fit: BoxFit.cover ),
        ),
      );
    }
  }

  _selectFoto() async{
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async{
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async{
    foto = await ImagePicker.pickImage(
      source: origen
    );
    
    if(foto != null){ 
      user.urlAvatar = null; //limpieza para redibujar la nueva foto
    }

    setState(() {});
  }

  void mostrarSnackbar(String mensaje){
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
      backgroundColor: miTema.accentColor,
    );
    scaffoldKey.currentState.showSnackBar(snackbar);

  }
}