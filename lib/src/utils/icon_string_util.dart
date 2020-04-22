import 'package:app_invernadero/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

final _icons = <String,IconData>{
  'heart'             : Icons.favorite_border,
  'bell'              : LineIcons.bell,
  'info-circle'       : LineIcons.info_circle,
  'question_circle'   : LineIcons.question_circle,
  'sign_in'           : LineIcons.sign_in
};

Icon getIcon(String iconName){
  return Icon(_icons[iconName],color: miTema.primaryColor,);
}