import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    this.text,
    this.onPressed,
  });

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.orange,
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
