import 'package:app_invernadero/src/blocs/client_bloc.dart';
import 'package:app_invernadero/src/blocs/feature_bloc.dart';
import 'package:app_invernadero/src/blocs/provider.dart';
import 'package:app_invernadero/src/models/feature_model.dart';
import 'package:app_invernadero/src/search/mapbox_search.dart';
import 'package:app_invernadero/src/storage/secure_storage.dart';
import 'package:app_invernadero/src/utils/colors.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:app_invernadero/src/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart'; 

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  FeatureBloc featureBloc;
  ClientBloc clientBloc;
  Stream<List<Feature>> _streamFeatures;
  SecureStorage storage = SecureStorage();
  Responsive _responsive;
  String idFeature;
  @override
  void didChangeDependencies() {
    featureBloc = Provider.featureBloc(context);
    clientBloc = Provider.clientBloc(context);
    _responsive = Responsive.of(context);

    featureBloc.features();

    _streamFeatures = featureBloc.featureListStream;
    idFeature = storage.idFeature;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        title: "Detalles de envio",
        actions: <Widget>[
          IconButton(
            icon:Icon(LineIcons.search,color: Colors.grey,),
            onPressed: ()=>showSearch(
           context: context, delegate: PlacesSearch()),
          )
        ],
      ),
      body: _content(),
    );
  }

  _content(){
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: StreamBuilder(
        stream: _streamFeatures ,
        builder: (BuildContext context, AsyncSnapshot<List<Feature>> snapshot){
          if(snapshot.hasData && snapshot.data.length!=0){
            return ListView.builder( 
              itemCount:  snapshot.data.length,
              itemBuilder: (context, index) {
               Feature feature = snapshot.data[index];
                return _itemView(feature);
                }
            );  
          } 
          return Container(child: Text("No hay direcciones",style: TextStyle(color:Colors.red),),);
        },
      ),
    );
  }
  _setSelection(Feature feature){
    print("Vambiando");
    setState(() {
      //storage.idFeature = feature.id;
      clientBloc.updateAddres(feature);
      idFeature = storage.idFeature;
      
    });

    // setState(() {
      
    // });
  }
  _itemView(Feature feature){
    return GestureDetector(
      onTap: ()=>_setSelection(feature),
          child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal:8),
        width: _responsive.widht,
        height: _responsive.ip(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:<Widget>[
                Icon(LineIcons.location_arrow,color: Colors.grey,),
                Container(
                  width: _responsive.wp(80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:<Widget>[
                      Text(
                        "${feature.placeName} ",
                         overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: _responsive.ip(1.7),
                                        color:MyColors.BlackAccent,
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w600
                                      ),  
                      ),
                      Text(
                        "${feature.text}",
                        overflow: TextOverflow.ellipsis,
                        style: 
                        TextStyle(
                          fontSize: _responsive.ip(1.2),
                          color:Colors.grey,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w600
                          ),
                      ),
                    ]
                  ),
                ),
                (idFeature==feature.id)?Icon(LineIcons.check,color: Colors.green,):Container()
              ]
            ),
            (idFeature==feature.id)?Text(
            "${feature.id}  ${feature.text} ",
              style: TextStyle(color: Colors.grey, fontSize:_responsive.ip(1.2)),
            ):Container(),
            SizedBox(height:5),
            Container(
              width:double.infinity,
              height:1,
              color:Colors.grey.withOpacity(0.5)
            )
           
          ],
        )
      ),
    );
  }
}