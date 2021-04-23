import 'package:flutter/material.dart';
import 'package:virtuallearningapp/view/screens/student/course_content/tabs/classroom/classroom.dart';
import 'package:virtuallearningapp/view/screens/student/course_content/tabs/content/content.dart';

class StudentCourseContent extends StatelessWidget {
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
              bottom: TabBar(
                tabs: [
                  Tab(text: 'CONTENT'),
                  Tab(text: 'CLASSROOM'),
                ],
              ),
            ),
          ),
          body: _Body(),
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
        WeeklyCourseContents(),
        StudentClassroom(),
      ],
    );
  }
}
