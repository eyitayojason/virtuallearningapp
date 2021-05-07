import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtuallearningapp/view/screens/lecturer/course_content/tabs/classroom/classroom.dart';
import 'package:virtuallearningapp/view/screens/lecturer/course_content/tabs/content/content.dart';
import 'package:virtuallearningapp/view/screens/widgets/appbar.dart';

final _auth = FirebaseAuth.instance;
User loggedinuser;

class LecturerCourseContent extends StatefulWidget {
  @override
  _LecturerCourseContentState createState() => _LecturerCourseContentState();
}

class _LecturerCourseContentState extends State<LecturerCourseContent> {
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
  void initState() {
    super.initState();
    getCurrentUser();
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
                  departmentname: "Department Of Computer Science",
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
          body:Stack(
            children: [
              Image.asset(
                "assets/images/schoolbg.png",
                fit: BoxFit.fitHeight,height: double.infinity,
              ),
              _Body(),
              
            ],
          )
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        LecturerWeeklyCourseContents(),
        LecturerClassroom(),
      ],
    );
  }
}
