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

  @override
  void initState() {
    super.initState();
    isUploading = false;
    isRecorded = false;
    isRecording = false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: WillPop(
          child: Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: ChatStream(),
          ),
        ),
      ),
    );
  }
}
