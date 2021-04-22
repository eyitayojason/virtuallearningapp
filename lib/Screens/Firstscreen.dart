import 'package:flutter/material.dart';
import 'package:virtuallearningapp/Screens/Dashboardlecturer.dart';
import 'Loginscreen.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Hero(tag: "yct", child: const Yctlogo()),
                Column(
                  children: [
                    Container(
                      width: 300,
                      height: 50,
                      child: LoginButtons(
                        text: "LOGIN AS STUDENT",
                        widget: LoginScreen(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 300,
                      height: 50,
                      child: LoginButtons(
                        text: "LOGIN AS LECTURER",
                        widget: Dashboardlecturer(),
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

class Yctlogo extends StatelessWidget {
  const Yctlogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/logoyct.png",
      height: 200,
    );
  }
}

class LoginButtons extends StatelessWidget {
  final String text;
  final Widget widget;
  const LoginButtons({
    Key key,
    this.text,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        color: Colors.orange,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => widget));
        },
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ));
  }
}
