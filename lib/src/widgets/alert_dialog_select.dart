import 'package:app_invernadero/app_config.dart';
import 'package:app_invernadero/src/blocs/producto_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AlertDialogSelect extends StatefulWidget {
  final String unidad;

  const AlertDialogSelect({Key key,@required this.unidad}) : super(key: key);

  @override
  _AlertDialogSelectState createState() => _AlertDialogSelectState();
}

class _AlertDialogSelectState extends State<AlertDialogSelect> {
   // state variable
  int _radioValue=-1;
  ProductoBloc productoBloc;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    productoBloc = Provider.productoBloc(context);
    
    switch(widget.unidad){
      case AppConfig.uniMedidaCaja:
        _radioValue=0;
      break;

      case AppConfig.uniMedidaTonelada:
        _radioValue=1;
      break;

      case AppConfig.uniMedidaKilo:
      _radioValue=2;
      break;
    }

    
    
  }


  void _handleRadioValueChange(int value) {
    print("value $value");
    setState(() {
      _radioValue = value;
    });
    setState(() {
      print("cambiando de unidad");
    });
  }
  @override
  Widget build(BuildContext context) {
    print("unidad default: ${widget.unidad}");

    return AlertDialog(
          title: new Text("Unidad",
            style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w900),),
          content: SingleChildScrollView(
                      child: Column(
              children:<Widget>[
                 ListTile(
                  leading: new Radio(
                    activeColor: miTema.accentColor,
                    value: 0,
                    groupValue:  _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                  title: Text("Caja"),
                ),
                ListTile(
                  leading: new Radio(
                     activeColor: miTema.accentColor,
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                  title: Text("Tonelada"),
                ),
                ListTile(
                  leading: new Radio(
                     activeColor: miTema.accentColor,
                    value: 2,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                  title: Text("Kilogramo"),
                )
               
              ]
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Aceptar",style: TextStyle(color:miTema.accentColor),),
              onPressed: () {
               

                Navigator.of(context).pop();

                setState(() {
                  switch (_radioValue){
                  case 0:
                    productoBloc.addUniMedida(AppConfig.uniMedidaCaja, FontAwesomeIcons.box,_radioValue);
                  break;
                  case 1:
                  productoBloc.addUniMedida(AppConfig.uniMedidaTonelada, FontAwesomeIcons.weightHanging,_radioValue);
                  break;
                  case 2:
                  productoBloc.addUniMedida(AppConfig.uniMedidaKilo, FontAwesomeIcons.weight,_radioValue);
                  break;
                }
                });
              },
            ),

            new FlatButton(
              child: new Text("Cancelar",style: TextStyle(color:Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
  }

 
}