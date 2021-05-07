import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:virtuallearningapp/main.dart';

import 'package:virtuallearningapp/view/screens/student/course_content/tabs/content/layouts/course_content_card.dart';
import 'package:virtuallearningapp/view/screens/student/login/Loginscreen.dart';
import 'package:virtuallearningapp/view/screens/widgets/button.dart';
import 'package:virtuallearningapp/view/screens/widgets/form_textfield.dart';

class WeeklyCourseContents extends StatefulWidget {
  @override
  _WeeklyCourseContentsState createState() => _WeeklyCourseContentsState();
}

class _WeeklyCourseContentsState extends State<WeeklyCourseContents> {
  final formKey = GlobalKey<FormState>();
  TextEditingController weekController = TextEditingController();
  TextEditingController courseTitleController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  User loggedinuser;
  File file;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinuser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future selectContentFile() async {
    String contentpath;
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ["pdf", "doc", "docx"]);
    if (result == null) return;
    contentpath = result.files.single.path;
    setState(() => file = File(contentpath));
    print(contentpath);
  }

  String title;
  String timestamp;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Messages")
            .orderBy("timestamp", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final messages = snapshot.data.docs.reversed;
          List<CourseContentCard> coursecontents = [];

          for (var message in messages) {
            week = message.data()["week"];
            contentDownloadUrl = message.data()["fileURL"];
            title = message.data()["coursetitle"];
            timestamp = message.data()["timestamp"].toString();
            final currentUser = authService.loggedinuser.displayName;
            final messageSender = message.data()["sender"];
            final coursecontent = CourseContentCard(
              courseTitle: title,
              pdflinkk: contentDownloadUrl,
              timestamp: timestamp,
              week: week,
            );
            coursecontents.add(coursecontent);
          }
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Expanded(
              child: ListView(children: coursecontents),
            ),
          );
        });
  }
}
