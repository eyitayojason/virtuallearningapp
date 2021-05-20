import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:virtuallearningapp/main.dart';
import 'package:virtuallearningapp/view/screens/lecturer/course_content/tabs/classroom/classroom.dart';
import 'package:virtuallearningapp/view/screens/lecturer/course_content/tabs/content/layouts/add_new_content.dart';
import 'package:virtuallearningapp/view/screens/lecturer/login/Loginscreen.dart';
import 'package:virtuallearningapp/view/screens/student/course_content/tabs/content/layouts/course_content_card.dart';
import 'package:virtuallearningapp/view/screens/widgets/button.dart';
import 'package:virtuallearningapp/view/screens/widgets/form_textfield.dart';

class LecturerWeeklyCourseContents extends StatefulWidget {
  @override
  _LecturerWeeklyCourseContentsState createState() =>
      _LecturerWeeklyCourseContentsState();
}

class _LecturerWeeklyCourseContentsState
    extends State<LecturerWeeklyCourseContents> {
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

  Future uploadContent() async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('fileURL/${basename(file.path)}}');
    uploadTask = storageReference.putFile(file);
    await uploadTask.whenComplete(() async {
      contentDownloadUrl = await storageReference.getDownloadURL();
    });
    print(contentDownloadUrl);
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
            .collection("Coursecontent")
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
            child: Column(
              children: [
                Expanded(
                  child: ListView(children: coursecontents),
                ),
                InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          child: Padding(
                            padding: const EdgeInsets.all(35.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomFormField(
                                    obsureText: false,
                                    textEditingController: weekController,
                                    validate: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter lecture week';
                                      }
                                    },
                                    onChanged: (
                                      value,
                                    ) {
                                      week = value;
                                    },
                                    hintText: "Week",
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  CustomFormField(
                                    validate: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter course title';
                                      }
                                    },
                                    obsureText: false,
                                    onChanged: (
                                      value,
                                    ) {
                                      title = value;
                                    },
                                    hintText: "Course Title",
                                    textEditingController:
                                        courseTitleController,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 150,
                                        child: CustomButton(
                                          onPressed: () async {
                                            await selectContentFile();
                                          },
                                          text: "Select File",
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        child: CustomButton(
                                          onPressed: () async {
                                            if (formKey.currentState
                                                .validate()) {
                                              weekController.clear();
                                              courseTitleController.clear();
                                              await uploadContent();
                                              await FirebaseFirestore.instance
                                                  .collection("Coursecontent")
                                                  .add({
                                                "sender":
                                                    loggedinuser.displayName,
                                                "fileURL": contentDownloadUrl,
                                                "timestamp": FieldValue.serverTimestamp(),
                                                "week": week,
                                                "coursetitle": title,
                                              });
                                            }
                                          },
                                          text: "Upload File",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      );
                    },
                    child: AddNewContent())
              ],
            ),
          );
        });
  }
}



