import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  CustomTextForm({this.textKey, 
    this.keyboardType, 
    this.label, 
    this.icon, 
    this.obscureText = false, 
    this.validator, 
    this.onSaved,
    this.onChanged});

  final Key textKey;
  final TextInputType keyboardType;
  final String label;
  final IconData icon;
  final bool obscureText;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 2, 0),
        child: TextFormField(
          keyboardType: keyboardType,
          key: textKey,
          decoration: InputDecoration(
            labelText: label,
            icon: Icon(icon),
            border: InputBorder.none,
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