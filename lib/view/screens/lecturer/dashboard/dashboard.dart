import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';
import 'package:virtuallearningapp/view/screens/lecturer/dashboard/layouts/assignment_updates.dart';
import 'package:virtuallearningapp/helper/willpop.dart';
import 'package:virtuallearningapp/view/screens/widgets/appbar.dart';
import 'package:virtuallearningapp/view/screens/widgets/news.dart';
import 'package:virtuallearningapp/view/screens/widgets/notificationbadge.dart';

Authentication authentication;
final _auth = FirebaseAuth.instance;
User currentuser;
var lecturerdata;

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
              username: FirebaseAuth.instance.currentUser.displayName,
              onpressed: () async {
                await _auth.signOut();

                if (_auth.currentUser == null) {
                  Navigator.pop(context);
                }
              },
              departmentname: FirebaseAuth.instance.currentUser.photoURL,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ASSIGNMENTS",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        NamedIcon(
                          iconData: Icons.picture_as_pdf_outlined,
                          //  text2: assignmentlist,
                        )
                      ],
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
          ),
        ),
      ),
    );
  }
}
