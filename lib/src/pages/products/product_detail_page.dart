
import 'package:app_invernadero/src/models/planta_model.dart';
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductDetailPage extends StatefulWidget {
  
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ProductoModel producto; 
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    producto = ModalRoute.of(context).settings.arguments; 

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    top: 60.0,
                  ),
                  height: 520.0,
                  color: Color(0xFF32A060),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                              child: Icon(
                              Icons.arrow_back,
                              size: 30.0,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.shopping_cart,
                            size: 30.0,
                            color: Colors.white,
                          )
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        producto.nombre.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        producto.nombre,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'FROM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0, 
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        '\$${producto.precioMenudeo}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        'Tamaño',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0, 
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        producto.solar.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 40.0),
                      RawMaterialButton(
                        padding: EdgeInsets.all(20.0),
                        shape: CircleBorder(),
                        elevation: 2.0,
                        fillColor: Colors.black,
                        child: Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                          size: 35.0,
                        ),
                        onPressed: () => print('Agregar a carrito'),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 20.0, 
                  bottom: 30.0,
                  child: Hero(
                    tag: producto.urlImagen, 
                     child:Image.network(producto.urlImagen, fit: BoxFit.cover, height: 150,),
                  ),
                 ),
              ],
             ),
             Container(
              height: 400.0,
              transform: Matrix4.translationValues(0.0, -20.0, 0.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      left: 30.0,
                      right: 30.0,
                      top: 40.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'All to know.....',
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                         producto.nombre,
                          style: TextStyle(color: Colors.black87, fontSize: 16.0),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                      Text('Detalles', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600)),
                      SizedBox(height: 10.0),
                      Text('Altura: 35-45 cm', style: TextStyle(fontSize: 16.0, color: Colors.black87)),
                      Text('Numero de ramas 12 cm', style: TextStyle(fontSize: 16.0, color: Colors.black87)),                   
                    ],),
                  ),
                ],
              ),
             ),
            ],
          ),
        ),
      ),
    );
  }
}