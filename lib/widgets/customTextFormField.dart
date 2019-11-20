import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import '../bloc/blocThemes.dart';

class CTextFormField extends StatelessWidget {
  CTextFormField({this.textKey, 
    this.keyboardType, 
    this.labelText, 
    this.icon, 
    this.obscureText = false, 
    this.validator, 
    this.onSaved,
    this.onChanged,
    this.initialValue,
    this.maxLength,
    this.hintText,
    this.controller,
    this.margin,
    this.removeLeftMargin = false,
    this.enabled = true});

  final Key textKey;
  final TextInputType keyboardType;
  final String labelText;
  final Widget icon;
  final bool obscureText;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final ValueChanged<String> onChanged;
  final String initialValue;
  final int maxLength;
  final String hintText;
  final TextEditingController controller;
  final EdgeInsetsGeometry margin;
  final bool removeLeftMargin;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<BlocThemes>();
    return Card(
      elevation: enabled ? 6 : 1,
      margin: margin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(90),
      ),
      color: enabled ? null : (bloc.selectedTheme()==ApplicationTheme.lightTheme ? Colors.grey[300] : Colors.grey[700]),
      child: Container(
        padding: EdgeInsets.fromLTRB((removeLeftMargin) ? 0 : 20, 10, 20, 5),
        child: TextFormField(
          initialValue: initialValue,
          maxLength: maxLength,
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          key: textKey,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            icon: (icon!=null) ? icon : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            counterStyle: TextStyle(height: double.minPositive,),
          ),
          style: TextStyle(
            fontSize: 18
          ),
          obscureText: obscureText,
          validator: validator,
          onSaved: onSaved,
          onChanged: onChanged,
        ),
      )
    );
  }
}