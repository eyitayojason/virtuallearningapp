import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';
import 'package:virtuallearningapp/view/Splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:virtuallearningapp/view/screens/Signup.dart';
import 'package:virtuallearningapp/view/screens/widgets/form_textfield.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => Signup(),
        ),
        Provider(
          create: (context) => CustomFormField(),
        ),
        ChangeNotifierProvider(
          create: (context) => Authentication(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'Virtual Learning App ',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          home: Splashscreen(),
        );
      },
    );
  }
}
