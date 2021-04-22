import 'package:flutter/material.dart';
import 'Dashboard.dart';
import 'Firstscreen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Hero(tag: "yct",
                child: const Yctlogo()),
                Column(
                  children: [
                    Container(
                      width: 300,
                      child: FormField(
                        text: "Email",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 300,
                      child: FormField(text: "Password"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 300,
                      height: 50,
                      child: LoginButtons(
                        text: "LOGIN",
                        widget: Dashboard(),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormField extends StatelessWidget {
  final String text;
  const FormField({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: text,
          border: OutlineInputBorder(),
          fillColor: Colors.grey.shade300,
          filled: true),
    );
  }
}
