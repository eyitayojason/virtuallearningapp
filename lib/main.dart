import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:sizer/sizer.dart';
import 'package:virtuallearningapp/helper/functions.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';
import 'package:virtuallearningapp/view/Splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:virtuallearningapp/view/screens/Signup.dart';
import 'package:virtuallearningapp/view/screens/lecturer/dashboard/dashboard.dart';
import 'package:virtuallearningapp/view/screens/lecturer/login/Loginscreen.dart';
import 'package:virtuallearningapp/view/screens/widgets/form_textfield.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  authService.getCurrentUser();

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
        ),
      ],
      child: MyApp(),
    ),
  );
}

String firebaseDownloadUrl;
String contentDownloadUrl;
String recordingURL;
String firebasevideoURL;
String chattext;
String audioname;
String title;
String coursetimestamp;
String courseweek;
bool isUploading;
bool isRecorded;

bool isRecording;
String filePath;
FlutterAudioRecorder audioRecorder;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedin = false;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.signOut();
    FirebaseAuth.instance.userChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  checkUserLoggedInStatus() async {
    await Helperfunctions.getUerLoggedInSharedPreference().then((value) {
      setState(() {
        _isLoggedin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Center(
              child: Column(
                children: [
                  Text("Something Went Wrong While initializing app"),
                  CircularProgressIndicator()
                ],
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Sizer(
            builder: (context, orientation, screenType) {
              return MaterialApp(
                  title: 'Virtual Learning App ',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                      textSelectionTheme:
                          TextSelectionThemeData(cursorColor: Colors.green),
                      inputDecorationTheme: InputDecorationTheme(
                        hintStyle: TextStyle(fontStyle: FontStyle.italic),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                      ),
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                      fontFamily: "Poppins"),
                  home: (_isLoggedin ?? false)
                      ? LecturerDashboard()
                      : Splashscreen()
                  //Splashscreen(),
                  );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
