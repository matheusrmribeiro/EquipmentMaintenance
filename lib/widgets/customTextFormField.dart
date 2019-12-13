import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import '../bloc/blocThemes.dart';

class CTextFormField extends StatefulWidget {
  CTextFormField({this.textKey, 
    this.keyboardType, 
    this.labelText, 
    this.icon, 
    this.obscureText = false, 
    this.validator, 
    this.onSaved,
    this.onChanged,
    this.onFieldSubmited,
    this.initialValue,
    this.maxLength,
    this.hintText,
    this.controller,
    this.margin,
    this.removeLeftMargin = false,
    this.enabled = true,
    this.textInputAction,
    this.focusNode,
    this.useStyle = true,
    this.textCapitalization = TextCapitalization.none});

  final Key textKey;
  final TextInputType keyboardType;
  final String labelText;
  final Widget icon;
  final bool obscureText;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final FormFieldSetter<String> onFieldSubmited;
  final ValueChanged<String> onChanged;
  final String initialValue;
  final int maxLength;
  final String hintText;
  final TextEditingController controller;
  final EdgeInsetsGeometry margin;
  final bool removeLeftMargin;
  final bool enabled;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final FocusNode focusNode;
  final bool useStyle;

  @override
  _CTextFormFieldState createState() => _CTextFormFieldState();
}

class _CTextFormFieldState extends State<CTextFormField> {
  FocusNode node;

  @override
  void initState() {
    node = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<BlocThemes>();

    if (widget.useStyle){
      return Card(
        elevation: (widget.enabled ? 6 : 1),
        margin: widget.margin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(90),
        ),
        color: widget.enabled ? null : (bloc.selectedTheme()==ApplicationTheme.lightTheme ? Colors.grey[300] : Colors.grey[700]),
        child: Container(
          padding: EdgeInsets.fromLTRB((widget.removeLeftMargin) ? 0 : 20, 10, 20, 5),
          child: TextFormField(
            initialValue: widget.initialValue,
            maxLength: widget.maxLength,
            controller: widget.controller,
            enabled: widget.enabled,
            focusNode: node,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            key: widget.textKey,
            decoration: InputDecoration(
              hintText: widget.hintText,
              labelText: widget.labelText,
              icon: (widget.icon!=null) ? widget.icon : null,
              border: InputBorder.none,
              contentPadding:EdgeInsets.fromLTRB(0, 0, 0, 0), 
              counterStyle:TextStyle(height: double.minPositive),
            ),
            style: TextStyle(
              fontSize: 18
            ),
            obscureText: widget.obscureText,
            validator: widget.validator,
            onSaved: widget.onSaved,
            onChanged: widget.onChanged,
            onFieldSubmitted: ((widget.onFieldSubmited==null)&&(widget.textInputAction==TextInputAction.next)) ? (String value){FocusScope.of(context).nextFocus();} : widget.onFieldSubmited,
          ),
        )
      );
    }
    else{
      return Container(
        child: TextFormField(
          initialValue: widget.initialValue,
          maxLength: widget.maxLength,
          controller: widget.controller,
          enabled: widget.enabled,
          focusNode: node,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          key: widget.textKey,
          decoration: InputDecoration(
            hintText: widget.hintText,
            labelText: widget.labelText,
            icon: (widget.icon!=null) ? widget.icon : null,
          ),
          obscureText: widget.obscureText,
          validator: widget.validator,
          onSaved: widget.onSaved,
          onChanged: widget.onChanged,
          onFieldSubmitted: ((widget.onFieldSubmited==null)&&(widget.textInputAction==TextInputAction.next)) ? (String value){FocusScope.of(context).nextFocus();} : widget.onFieldSubmited,
        ),
      );
    }
  }
}