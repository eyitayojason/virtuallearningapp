import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';
import 'package:virtuallearningapp/view/screens/lecturer/dashboard/layouts/assignment_updates.dart';
import 'package:virtuallearningapp/view/screens/lecturer/dashboard/layouts/chat_updates.dart';
import 'package:virtuallearningapp/view/screens/widgets/appbar.dart';
import 'package:virtuallearningapp/view/screens/widgets/news.dart';

Authentication authentication;
final _auth = FirebaseAuth.instance;
User loggedinuser;

class LecturerDashboard extends StatefulWidget {
  @override
  _LecturerDashboardState createState() => _LecturerDashboardState();
}

class _LecturerDashboardState extends State<LecturerDashboard> {
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

  @override
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
            departmentname: "Department Of Computer Science",
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
          children: [
            ChatUpdates(),
            SizedBox(height: 20),
            AssignmentUpdates(),
            SizedBox(height: 20),
            News(),
          ],
        ),
      ),
    );
  }
}
