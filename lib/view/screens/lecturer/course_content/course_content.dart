import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtuallearningapp/view/screens/lecturer/course_content/tabs/classroom/classroom.dart';
import 'package:virtuallearningapp/view/screens/lecturer/course_content/tabs/content/content.dart';
import 'package:virtuallearningapp/view/screens/lecturer/course_content/tabs/content/layouts/add_new_content.dart';
import 'package:virtuallearningapp/view/screens/lecturer/dashboard/dashboard.dart';
import 'package:virtuallearningapp/view/screens/student/dashboard/dashboard.dart';
import 'package:virtuallearningapp/view/screens/widgets/appbar.dart';
import 'package:virtuallearningapp/helper/willpop.dart';

class LecturerCourseContent extends StatefulWidget {
  @override
  _LecturerCourseContentState createState() => _LecturerCourseContentState();
}

class _LecturerCourseContentState extends State<LecturerCourseContent> {
  User courseuser;
  final _auth = FirebaseAuth.instance;
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        courseuser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    print(courseuser.displayName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: WillPop(
          child: Scaffold(
            backgroundColor: Colors.grey.shade300,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(150),
              child: AppBar(
                leading: Container(),
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: CustomAppBar(
                    username: lecturerdata.data()["displayName"],
                    departmentname: lecturerdata.data()["matricNo"],
                  ),
                ),
                backgroundColor: Colors.orange,
                bottom: TabBar(
                  indicatorColor: Colors.green,
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
                  color: Colors.white.withOpacity(0.8),
                  colorBlendMode: BlendMode.screen,
                  height: double.infinity,
                ),
                TabBarView(
                  children: [
                    WeeklyCourseContents(
                      addcontent: AddNewContent(
                        text: "Add New Content",
                      ),
                    ),
                    LecturerClassroom(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
