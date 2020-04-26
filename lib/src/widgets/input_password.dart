import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class InputPassword extends StatefulWidget {
  final placeholder;
  final Function(String) validator;
  final Function(String) onChange;
  final String counterText;
  final String errorText;
  const InputPassword({
     this.placeholder, this.validator, this.onChange, this.counterText, this.errorText});
  
  @override
  _InputPasswordState createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool _obscureText=true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        
        obscureText: _obscureText,
        decoration: InputDecoration(
          focusedBorder:  UnderlineInputBorder(      
                          borderSide: BorderSide(color:Color(0xffdddddd))),
          enabledBorder: UnderlineInputBorder(      
                          borderSide: BorderSide(color:Color(0xffdddddd)),),
          hintText: widget.placeholder,
          hintStyle: TextStyle(color:Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(_obscureText
              ? LineIcons.eye
              : LineIcons.eye_slash,
              color: Color(0xffdddddd),
              ),
              onPressed: _toggle
            ),
          prefixIcon: Icon(
          LineIcons.key,color: Color(0xffdddddd),),
          counterText: widget.counterText,
          errorText: widget.errorText,
          ), 
        validator: widget.validator,
        onChanged: widget.onChange,
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}