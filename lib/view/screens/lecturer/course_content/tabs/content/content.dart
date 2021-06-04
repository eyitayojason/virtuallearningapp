import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtuallearningapp/main.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';
import 'package:virtuallearningapp/view/screens/lecturer/course_content/tabs/content/layouts/course_content_card.dart';
import 'package:virtuallearningapp/view/screens/widgets/button.dart';

class WeeklyCourseContents extends StatefulWidget {
  const WeeklyCourseContents({Key key, this.addcontent});

  final Widget addcontent;

  @override
  _WeeklyCourseContentsState createState() => _WeeklyCourseContentsState();
}

class _WeeklyCourseContentsState extends State<WeeklyCourseContents> {
  User coursecontentuser;
  TextEditingController courseTitleController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  TextEditingController weekController = TextEditingController();

  FirebaseAuth _auth;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    courseTitleController.dispose();
    weekController.dispose();
    super.dispose();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        coursecontentuser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<Authentication>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("Coursecontent")
            .orderBy("timestamp", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final contents = snapshot.data.docs.reversed;
          List<CourseContentCard> coursecontents = [];
          for (var content in contents) {
            courseweek = content.data()["week"];
            contentDownloadUrl = content.data()["fileURL"];
            title = content.data()["coursetitle"];
            coursetimestamp = content.data()["timestamp"].toString();
            final coursecontent = CourseContentCard(
              courseTitle: title,
              pdflinkk: contentDownloadUrl,
              timestamp: coursetimestamp,
              week: courseweek,
            );
            coursecontents.add(coursecontent);
          }
          return Scaffold(resizeToAvoidBottomInset: false,
                      body: Padding(
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
                                    Expanded(
                                      child: TextFormField(
                                        obscureText: false,
                                        decoration: InputDecoration(
                                            hintText: "Enter Week"),
                                        controller: weekController,
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                                ? 'Please enter lecture week'
                                                : null,
                                        onChanged: (value) => courseweek = value,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                          obscureText: false,
                                          controller: courseTitleController,
                                          decoration: InputDecoration(
                                              hintText: "Enter Course Title"),
                                          validator: (value) =>
                                              value == null || value.isEmpty
                                                  ? 'Please enter course title'
                                                  : null,
                                          onChanged: (value) => title = value),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: CustomButton(
                                            onPressed: () async {
                                              await authProvider
                                                  .selectContentFile();
                                            },
                                            text: "Select File",
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                        ),
                                        Expanded(
                                          child: CustomButton(
                                            onPressed: () async {
                                              if (formKey.currentState
                                                  .validate()) {
                                                 Navigator.pop(context);
                                                await authProvider
                                                    .uploadContent()
                                                    .whenComplete(() {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Content Posted Sucessfully'),
                                                  ));
                                                });
                                                await _firestore
                                                    .collection("Coursecontent")
                                                    .add({
                                                  "fileURL": contentDownloadUrl,
                                                  "timestamp": DateTime.now(),
                                                  "week": weekController.text,
                                                  "coursetitle":
                                                      courseTitleController.text,
                                                });
                                              }
                                              weekController.clear();
                                              courseTitleController.clear();
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
                      child: widget.addcontent)
                ],
              ),
            ),
          );
        });
  }
}
