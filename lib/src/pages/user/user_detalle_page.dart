import 'dart:io';
import 'package:app_invernadero/src/blocs/client_bloc.dart'; 
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/client_model.dart'; 
import 'package:app_invernadero/src/theme/theme.dart'; 
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/my_appbar.dart';
import 'package:app_invernadero/src/widgets/rounded_button.dart';  
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';  

class UserDetallePage extends StatefulWidget { 
  @override
  _UserDetallePageState createState() => _UserDetallePageState();
}

class _UserDetallePageState extends State<UserDetallePage> {
  
  final TextStyle _style =  TextStyle(color:Colors.grey,fontSize:18,fontFamily: 'Quicksand',fontWeight: FontWeight.w700);
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _guardando = false;
 
  ClientModel user;
  File foto;

  ClientBloc clientBloc;
  Responsive responsive;
 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies(); 

    clientBloc = Provider.clientBloc(context);
    responsive = Responsive.of(context); 
    user = ModalRoute.of(context).settings.arguments;
    clientBloc.initialData(user);

  }

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Editar datos"),  
      body: Container(   
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
        children: <Widget>[
          _mostrarFoto(),  
          SizedBox(height:responsive.ip(6)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Datos personales", style:TextStyle(fontFamily: 'Quicksand',fontSize:responsive.ip(2),color:Color(0xFF545D68))),
              Text("* Campos obligatorios", style:TextStyle(fontFamily: 'Quicksand',fontSize:responsive.ip(1.5),color:Colors.grey)),
            ],
          ),
           SizedBox(height:5),
          SizedBox(height:responsive.ip(1)),
          Expanded(
            child: _inputs(),
          ),
           
      ],
    ),
    ),
    );
  }
  
  _inputs(){
    return SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Nombre",
            style:_style),
          StreamBuilder(
            stream:clientBloc.nameStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return _inputTextt(
                TextInputType.text,snapshot.error,clientBloc.changeName);
            },
          ),
          SizedBox(height:5),
          Text("Apellido Paterno",
            style:_style),
          StreamBuilder(
            stream:clientBloc.apStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return _inputTextt(
                TextInputType.text,snapshot.error,clientBloc.changeAp);
            },
          ),

          Text("Apellido Materno",
            style:_style),
          StreamBuilder(
            stream:clientBloc.amStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return _inputTextt(
                TextInputType.text,snapshot.error,clientBloc.changeAm);
            },
          ),

          Text("RFC",
            style:_style),
          StreamBuilder(
            stream:clientBloc.rfStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return _inputTextt(
                TextInputType.text,snapshot.error,clientBloc.changeR);
            },
          ),


         
        ],
      ),
    );
  } 

  Widget _inputTextt(TextInputType textInput, String errorText,Function(String) func){
    

    return TextField(
      
      keyboardType: textInput,
      decoration: InputDecoration(
          focusedBorder:  UnderlineInputBorder(      
                          borderSide: BorderSide(color:Color(0xffdddddd))),
          enabledBorder: UnderlineInputBorder(      
                          borderSide: BorderSide(color:Color(0xffdddddd)),),
          hintStyle: TextStyle(color:Colors.grey),
          errorText: errorText,
      ),
      textCapitalization: TextCapitalization.sentences, 
      onChanged: func,
    );
  } 
  
  _button(){
    return  Align(
      alignment: Alignment.bottomRight,
      child: Container(height:20,width:double.infinity,color:Colors.red),  
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