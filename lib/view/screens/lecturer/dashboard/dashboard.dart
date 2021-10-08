import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtuallearningapp/view/screens/lecturer/dashboard/layouts/assignment_updates.dart';
import 'package:virtuallearningapp/helper/willpop.dart';
import 'package:virtuallearningapp/widgets/appbar.dart';
import 'package:virtuallearningapp/widgets/news.dart';
import 'package:virtuallearningapp/widgets/notificationbadge.dart';

class LecturerDashboard extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
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
                _auth.signOut().whenComplete(() {
                  Navigator.pop(context);
                });
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
                        assignmentlist != null
                            ? NamedIcon(
                                iconData: Icons.picture_as_pdf_outlined,
                                text2: assignmentlist.toString(),
                              )
                            : SizedBox()
                      ],
                    ),
                    Expanded(
                      child: AssignmentUpdates(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      flex: 2,
                      child: NewsScreen(),
                    ),
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
