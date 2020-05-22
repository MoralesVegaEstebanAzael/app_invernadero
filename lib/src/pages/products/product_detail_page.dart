
import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../../app_config.dart';

class ProductDetailPage extends StatefulWidget {
  
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Responsive responsive;
  ProductoModel producto; 
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    responsive = Responsive.of(context);
    producto = ModalRoute.of(context).settings.arguments;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          _appBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                
               _contenido()
               
              ]
            ),
          ),
        ],
      ),
    );
  }


  Widget _appBar(){
    return SliverAppBar(
      elevation: 0,
      backgroundColor: miTema.accentColor,
      leading: Container(
      margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white70,
          shape: BoxShape.circle,
        ),
      child: IconButton(
      icon: Icon(LineIcons.angle_left, color: Colors.black87),
      onPressed: () => Navigator.of(context).pop(),
    ),
      ), 
    
    );
  }

  Widget _contenido() {
    return SingleChildScrollView(
      
        child: Container(
          height: responsive.height,
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            
            _background(),
            _encabezado(),
            _descripcion()
            ],
          ),
        ),
      );
  }

  _background() {
    return AspectRatio(
      aspectRatio: 16/12,
          child: Container(
            //color:Colors.yellow,
            color:miTema.accentColor,
            child: Stack(children: <Widget>[
        Positioned(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom:45.0),
                 child:Hero(
                    tag: producto.id,
                    child: //(producto.urlImagen!=null)?
                  FadeInImage(
                      width: responsive.ip(25),
                      image: NetworkImage(producto.urlImagen) , 
                      placeholder: AssetImage('assets/placeholder.png'),)
                  // CachedNetworkImage(
                  //     placeholder: (context, url) => CircularProgressIndicator(),
                  //     imageUrl: producto.urlImagen,
                  //   )
                  //   :
                  //   Image(image: AssetImage('assets/placeholder.png'),height: responsive.ip(20)),
                  ),
              ),
            ),
            ),
      ],
      ),
    ),
    );
  }

  _encabezado() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal:15),
      padding: EdgeInsets.all(0),
      width: double.infinity,
      transform: Matrix4.translationValues(0.0, -40.0, 0.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 30.0,
              right: 30.0,
              top: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Text(
              producto.nombre,
              style: TextStyle(
                color: Color.fromRGBO(43, 43, 43, 1),
                fontSize: 25.0,fontFamily: 'Quicksand',fontWeight: FontWeight.w900),
            ),
          SizedBox(height: responsive.ip(2)),
          Text(
          "Especificaciones: ${producto.contCaja} ${AppConfig.uni_medida} | Existencias: " ,
            style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w700,color:Colors.grey),
          ),
          SizedBox(height: responsive.ip(2)),
                      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:<Widget>[
            
            Column(
              children:<Widget>[
                  Text("\$ ${producto.precioMayoreo}",style: TextStyle(
                    fontSize:20,fontFamily: 'Quicksand',
              fontWeight: FontWeight.w900,color: miTema.accentColor,),),
              Text("\$ ${producto.precioMenudeo}",style: TextStyle(
                fontSize:20,fontFamily: 'Quicksand',
              fontWeight: FontWeight.w900,color: miTema.accentColor,),),
              ]
            ),
            Column(
              children:<Widget>[
                Text("Mayoreo",style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w700,color:Colors.grey),),
                SizedBox(height:responsive.ip(1)),
                  Text("Menudeo",style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w700,color:Colors.grey),),
              ]
            ),
          Column(
            children: <Widget>[
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                padding: EdgeInsets.symmetric(horizontal:20,vertical:8),
                decoration: BoxDecoration(
                  color: miTema.accentColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(
                          color:Colors.black26,
                          blurRadius: 5
                  )]
                ),
                child: Text("AGREGAR",style: TextStyle(fontFamily: 'Quiksand',color:Colors.white,letterSpacing: 1,fontSize: 15),),
                ),
                onPressed: (){}),
                      ],
                    )
                    ],
                    
                      )
                    ],
                  ),
                ),
                
              ],
            ),
      );
  }
  
  _descripcion() {
    return  Expanded(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal:15),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          Row(
            children: <Widget>[
              Icon(LineIcons.align_center,color: Colors.black,),
              SizedBox(width:responsive.ip(1)),
            Text('Descripción', style: TextStyle(fontFamily:'Quicksand',fontSize: 18.0, fontWeight: FontWeight.w600)),
            ],
          ),
          
        
        ],),
      ),
    );
  }


  Widget _createAppBar(){
    return SliverAppBar(
      elevation: 0.0,
      backgroundColor: miTema.accentColor,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle:true,
        title: Text(
          producto.nombre,
          style: TextStyle(color:Colors.white,fontSize:16.0,),
          overflow: TextOverflow.ellipsis,
          ),
          background: FadeInImage(
            placeholder: AssetImage('assets/images/jar-loading.gif'), 
            image: NetworkImage(producto.urlImagen),
            fit:BoxFit.cover,
          ),
      ),
    );
  }
}