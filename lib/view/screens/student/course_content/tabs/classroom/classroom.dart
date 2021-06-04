import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:virtuallearningapp/main.dart';
import 'package:virtuallearningapp/services%20and%20providers/chatstream.dart';
import 'package:virtuallearningapp/view/screens/lecturer/course_content/tabs/classroom/classroom.dart';
import 'package:virtuallearningapp/helper/willpop.dart';

class StudentClassroom extends StatefulWidget {
  @override
  _StudentClassroomState createState() => _StudentClassroomState();
}

class _StudentClassroomState extends State<StudentClassroom> {
  final messageTextController = TextEditingController();
  // ignore: unused_field

  final _auth = FirebaseAuth.instance;

  void getCurrentUser() async {
    // ignore: unused_local_variable

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
    
    isUploading = false;
    isRecorded = false;
    isRecording = false;
    //audioPlayer = AudioPlayer();
  }
 @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //audioPlayer.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: WillPop(
          child: Scaffold(
              backgroundColor: Colors.grey.shade300,
              body: ChatStream(messageTextController: messageTextController)),
        ),
      ),
    );
  }
}
