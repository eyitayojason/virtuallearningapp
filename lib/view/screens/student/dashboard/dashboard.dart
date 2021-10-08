import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:virtuallearningapp/helper/willpop.dart';
import 'package:virtuallearningapp/widgets/appbar.dart';
import 'package:virtuallearningapp/widgets/news.dart';

class StudentDashboard extends StatelessWidget {
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
                username: _auth.currentUser.displayName,
                onpressed: () {
                  _auth.signOut().whenComplete(() {
                    Navigator.pop(context);
                  });
                },
                departmentname: _auth.currentUser.photoURL),
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
                    Expanded(
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
