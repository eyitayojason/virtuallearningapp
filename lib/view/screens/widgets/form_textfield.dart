import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key key,
    this.hintText,
    this.textInputType,
    this.obsureText,
    this.onChanged,
    this.textEditingController,
    this.validate,
    this.errorText,
  }) : super(key: key);

  final String hintText;
  final TextInputType textInputType;
  final bool obsureText;
  final Function onChanged;
  final TextEditingController textEditingController;
  final Function validate;
  final String errorText;

  @override
  Widget build(BuildContext context) {
    // var provider = Provider.of<SignupAndValidationProvider>(context);
    return TextFormField(
      textAlign: TextAlign.center,
      controller: textEditingController,
      obscureText: obsureText,
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
        fillColor: Colors.grey.shade300,
        filled: true,
      ),
      validator: validate,
      onChanged: onChanged,
    );
  }
}
