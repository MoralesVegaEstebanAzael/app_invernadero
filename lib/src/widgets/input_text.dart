import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';

class InputText extends StatelessWidget {
  final String placeholder;
  final Function(String) validator;
  final TextInputType inputType;
  final IconData icon;
  final Function(String) onChange;
  final String counterText;
  final String errorText;
  final List<TextInputFormatter> inputFormatters;
  final bool autocorrect;
  final String initialValue; 
  final Function(String) onSaved;
  final String labelText;
  const InputText({Key key, this.placeholder, this.initialValue, this.onSaved, this.labelText,
    this.validator, this.inputType, this.icon, this.onChange, 
    this.counterText, this.errorText, this.inputFormatters, this.autocorrect=false}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: inputType,
      decoration: InputDecoration(
          focusedBorder:  UnderlineInputBorder(      
                          borderSide: BorderSide(color:Color(0xffdddddd))),
          enabledBorder: UnderlineInputBorder(      
                          borderSide: BorderSide(color:Color(0xffdddddd)),),
          hintText: placeholder,
          labelText: labelText,
          hintStyle: TextStyle(color:Colors.grey),
          prefixIcon: Icon(
          icon,color: Color(0xffdddddd),),
          counterText: counterText,
          errorText: errorText
      ), 
      validator: validator,
      onChanged: onChange,
      onSaved: onSaved,
      inputFormatters : inputFormatters,
      autocorrect: autocorrect,
    );
  }

 
}

