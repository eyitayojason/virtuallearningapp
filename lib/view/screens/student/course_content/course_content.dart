import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtuallearningapp/main.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';
import 'package:virtuallearningapp/view/screens/Signup.dart';
import 'package:virtuallearningapp/view/screens/student/course_content/tabs/classroom/classroom.dart';
import 'package:virtuallearningapp/view/screens/lecturer/course_content/tabs/content/content.dart';
import 'package:virtuallearningapp/view/screens/student/dashboard/dashboard.dart';
import 'package:virtuallearningapp/view/screens/widgets/appbar.dart';
import 'package:virtuallearningapp/helper/willpop.dart';

User user;
User loggedinuser;
final _auth = FirebaseAuth.instance;
String url;

class StudentCourseContent extends StatefulWidget {
  @override
  _StudentCourseContentState createState() => _StudentCourseContentState();
}

class _StudentCourseContentState extends State<StudentCourseContent> {
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

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

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<Authentication>(context);
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: WillPop(
          child: Scaffold(
            backgroundColor: Colors.grey.shade400,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(150),
              child: AppBar(
                leading: Container(),
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: CustomAppBar(
                    username: FirebaseAuth.instance.currentUser.displayName,
                    departmentname: FirebaseAuth.instance.currentUser.photoURL,
                  ),
                ),
                backgroundColor: Colors.orange,
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(text: 'CONTENT'),
                    Tab(text: 'CLASSROOM'),
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                Image.asset(
                  "assets/images/schoolbg.png",
                  fit: BoxFit.fitHeight,
                  height: double.infinity,
                ),
                TabBarView(
                  children: [
                    WeeklyCourseContents(
                      addcontent: Card(
                        child: TextButton(
                          onPressed: () async {
                            await authProvider.selectContentFile();
                            await authProvider.uploadContent();
                            await FirebaseFirestore.instance
                                .collection("assignments")
                                .add({
                              "fileURL": contentDownloadUrl,
                              "timestamp": DateTime.now().toString(),
                              "sender": data.data()["matricNo"],
                            }).whenComplete(() {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Assignment Submitted'),
                                ),
                              );
                            });
                          },
                          child: Text(
                            "Submit Assignment",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    StudentClassroom(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
