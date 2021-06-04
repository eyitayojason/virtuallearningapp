
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtuallearningapp/main.dart';
import 'package:virtuallearningapp/services%20and%20providers/chatstream.dart';
import 'package:virtuallearningapp/helper/willpop.dart';

class LecturerClassroom extends StatefulWidget {
  static User classroomuser;
  @override
  _LecturerClassroomState createState() => _LecturerClassroomState();
}

class _LecturerClassroomState extends State<LecturerClassroom> {
  final messageTextController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        LecturerClassroom.classroomuser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    //audioPlayer = AudioPlayer();
    
    isUploading = false;
    isRecorded = false;
    isRecording = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  //  audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: WillPop(
          child: Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: ChatStream(messageTextController: messageTextController),
          ),
        ),
      ),
    );
  }
}
