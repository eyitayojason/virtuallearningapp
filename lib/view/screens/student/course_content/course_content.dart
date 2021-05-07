import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtuallearningapp/view/screens/student/course_content/tabs/classroom/classroom.dart';
import 'package:virtuallearningapp/view/screens/student/course_content/tabs/content/content.dart';
import 'package:virtuallearningapp/view/screens/widgets/appbar.dart';

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
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: Colors.grey.shade400,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(150),
              child: AppBar(
                leading: Container(),
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: CustomAppBar(
                    username: loggedinuser.displayName,
                    departmentname: "HND Computer Science",
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
                _Body(),
              ],
            )),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        WeeklyCourseContents(),
        StudentClassroom(),
      ],
    );
  }
}
