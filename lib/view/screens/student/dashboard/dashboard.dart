import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:virtuallearningapp/view/screens/student/dashboard/layouts/updates_horizontal_listview.dart';
import 'package:virtuallearningapp/view/screens/widgets/appbar.dart';
import 'package:virtuallearningapp/view/screens/widgets/news.dart';

final _auth = FirebaseAuth.instance;
User loggedinuser;

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
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
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: CustomAppBar(
            username: loggedinuser.displayName,
            onpressed: () {
              _auth.signOut().whenComplete(() {
                Navigator.pop(context);
              });
            },
            departmentname: "HND Computer Science",
          ),
        ),
        body: _Body(),
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
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UpdatesHorizontalListView(),
            SizedBox(
              height: 20,
            ),
            News(),
          ],
        ),
      ),
    );
  }
}
