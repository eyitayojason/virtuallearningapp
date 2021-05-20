import 'dart:async';

import 'package:audioplayer/audioplayer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
String chattext;
String filepath;
var week;
typedef void OnError(Exception exception);
AudioPlayer audioPlugin = AudioPlayer();
enum PlayerState { stopped, playing, paused }
 Duration duration;
  Duration position;
  AudioPlayer audioPlayer;
  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;
  PlayerState playerState = PlayerState.stopped;
  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';
  bool isMuted = false;
  StreamSubscription positionSubscription;
  StreamSubscription audioPlayerStateSubscription;
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedin = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
            title: 'Virtual Learning App ',
            debugShowCheckedModeBanner: false,
            theme:
                ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
            home: (_isLoggedin ?? false) ?
             LecturerDashboard() : 
             Splashscreen()
            //Splashscreen(),
            );
      },
    );
  }
}
