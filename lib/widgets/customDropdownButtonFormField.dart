import 'package:flutter/material.dart';

class CDropdownButtonFormField<T> extends StatelessWidget {
  CDropdownButtonFormField({this.textKey, 
    this.labelText, 
    this.icon, 
    this.validator, 
    this.onSaved,
    this.onChanged,
    this.value,
    this.hint,
    this.margin,
    this.items,
    this.useStyle = false});

  final Key textKey;
  final String labelText;
  final Widget icon;
  final FormFieldValidator<T> validator;
  final FormFieldSetter<T> onSaved;
  final ValueChanged<T> onChanged;
  final T value;
  final Widget hint;
  final EdgeInsetsGeometry margin;
  final List<DropdownMenuItem<T>> items;
  final bool useStyle;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: margin,
      shape: 
      (useStyle)
      ?
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(90),
        )
      :
        null,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: DropdownButtonFormField<T>(
          decoration: InputDecoration(
            labelText: labelText,
            icon: (icon!=null) ? icon : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            counterStyle: TextStyle(height: double.minPositive,),
          ),
          hint: hint,
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          onSaved: onSaved,
        )
      )
    );
  }
}