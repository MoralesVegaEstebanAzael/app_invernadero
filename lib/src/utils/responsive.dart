import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart' show required;
import 'dart:math' as math;

class Responsive{
  final double widht,height,inch;

  Responsive({
    @required this.widht,
    @required this.height,
    @required this.inch});

  factory Responsive.of(BuildContext context){
    final MediaQueryData data= MediaQuery.of(context);
    final size = data.size;
    final inch = math.sqrt(math.pow(size.width, 2)+math.pow(size.height, 2));
    return Responsive(widht: size.width,height: size.height,inch: inch);
  }

  double wp(double percent){ //ancho porcentual
    return this.widht*percent/100;
  }

  double hp(double percent){ //altura porcentual
    return this.height*percent/100;
  }
  
  double ip(double percent){//pixelex porcentuales
    return this.inch*percent/100;
  }
}