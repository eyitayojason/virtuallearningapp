import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';
import 'package:virtuallearningapp/view/screens/lecturer/dashboard/layouts/assignment_updates.dart';
import 'package:virtuallearningapp/helper/willpop.dart';
import 'package:virtuallearningapp/view/screens/widgets/appbar.dart';
import 'package:virtuallearningapp/view/screens/widgets/news.dart';

Authentication authentication;
final _auth = FirebaseAuth.instance;
User currentuser;

class LecturerDashboard extends StatefulWidget {
  @override
  _LecturerDashboardState createState() => _LecturerDashboardState();
}

class _LecturerDashboardState extends State<LecturerDashboard> {
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        currentuser = user;
        setState(() {});
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
    print(currentuser.displayName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPop(
        child: Scaffold(
            backgroundColor: Colors.grey.shade400,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: CustomAppBar(
                username: currentuser.displayName,
                onpressed: () {
                  _auth.signOut().whenComplete(() {
                    Navigator.pop(context);
                  });
                },
                departmentname: "Department Of Computer Science",
              ),
            ),
            body: Stack(
              children: [
                Image.asset(
                  "assets/images/schoolbg.png",
                  fit: BoxFit.fitHeight,
                  height: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ASSIGNMENTS",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: AssignmentUpdates(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(flex: 2, child: NewsScreen()),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
