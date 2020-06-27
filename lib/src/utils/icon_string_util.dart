import 'package:app_invernadero/src/theme/theme.dart';
import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

final _icons = <String,IconData>{
  'heart'             : Icons.favorite_border,
  'bell'              : LineIcons.bell,
  'info-circle'       : LineIcons.info_circle,
  'question_circle'   : LineIcons.question_circle,
  'sign_in'           : LineIcons.sign_in,
  'key'               : LineIcons.key
};

Icon getIcon(String iconName,Responsive _responsive){
  return Icon(_icons[iconName],color: Colors.grey,size:_responsive.ip(2.5) ,);
}