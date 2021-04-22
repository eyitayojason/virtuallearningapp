import 'package:flutter/material.dart';
import 'Screens/Splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Virtual Learning App ',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: Splashscreen(
        
        ));
  }
}
