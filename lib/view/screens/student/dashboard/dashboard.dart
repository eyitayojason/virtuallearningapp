import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:virtuallearningapp/view/screens/widgets/appbar.dart';
import 'package:virtuallearningapp/view/screens/widgets/news.dart';
import 'package:virtuallearningapp/helper/willpop.dart';

final _auth = FirebaseAuth.instance;
User loggedinuser;
final firestore = FirebaseFirestore.instance;
User user = _auth.currentUser;
var data;

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPop(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (BuildContext context, snapshot) {
              final datas = snapshot.data.docs;
              for (data in datas) {
                return Scaffold(
                    backgroundColor: Colors.grey.shade400,
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(100),
                      child: CustomAppBar(
                        username: data.data()["displayName"],
                        onpressed: () {
                          _auth.signOut().whenComplete(() {
                            Navigator.pop(context);
                          });
                        },
                        departmentname: data.data()["matricNo"],
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
                            children: [
                              Expanded(child: NewsScreen()),
                            ],
                          ),
                        ),
                      ],
                    ));
              }
              return null;
            }),
      ),
    );
  }
}
