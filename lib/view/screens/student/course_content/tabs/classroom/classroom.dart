import 'package:flutter/material.dart';
import 'package:virtuallearningapp/main.dart';
import 'package:virtuallearningapp/services%20and%20providers/chatstream.dart';
import 'package:virtuallearningapp/helper/willpop.dart';

class StudentClassroom extends StatefulWidget {
  @override
  _StudentClassroomState createState() => _StudentClassroomState();
}

class _StudentClassroomState extends State<StudentClassroom> {
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
