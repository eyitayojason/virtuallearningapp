import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:virtuallearningapp/helper/functions.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';
import 'package:virtuallearningapp/view/screens/lecturer/course_content/course_content.dart';
import 'package:virtuallearningapp/view/screens/lecturer/dashboard/dashboard.dart';
import 'package:virtuallearningapp/view/screens/student/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:virtuallearningapp/view/screens/widgets/button.dart';
import 'package:virtuallearningapp/view/screens/widgets/form_textfield.dart';
import 'package:virtuallearningapp/view/screens/widgets/logo.dart';
import 'package:sizer/sizer.dart';
import '../createquiz.dart';
import 'package:virtuallearningapp/view/screens/widgets/alertdialog.dart';

bool isLoading = false;
String email;
String password;
String displayName;
final _auth = FirebaseAuth.instance;
final formKey = GlobalKey<FormState>();
User loggedinuser;
Authentication authService = Authentication();

class LecturerLogin extends StatefulWidget {
  @override
  _LecturerLoginState createState() => _LecturerLoginState();
}

class _LecturerLoginState extends State<LecturerLogin> {
  void getCurrentUser() async {
    // ignore: unused_local_variable
    User _loggedinuser;
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          _loggedinuser = user;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final status =
            await authService.signInWithEmailAndPassword(email, password);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBAr(
              pages: [
                LecturerDashboard(),
                LecturerCourseContent(),
                CreateQuiz(),
              ],
            ),
          ),
        );
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        AlrtDialog().showAlertDialog(context, e.toString().substring(30));
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          dismissible: true,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 10.0.h),
                  Hero(
                    tag: "yct",
                    child: const Yctlogo(),
                  ),
                  SizedBox(height: 5.0.h),
                  Text('Login as a Lecturer'),
                  SizedBox(height: 5.0.h),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          CustomFormField(
                              hintText: 'Email',
                              textInputType: TextInputType.emailAddress,
                              obsureText: false,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                              },
                              onChanged: (value) {
                                email = value;
                              }),
                          SizedBox(height: 20),
                          CustomFormField(
                              hintText: 'Password',
                              obsureText: true,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter password';
                                }
                              },
                              onChanged: (value) {
                                password = value;
                              }),
                          SizedBox(height: 20),
                          CustomButton(
                              text: 'SUBMIT',
                              onPressed: () {
                                signIn();
                                Helperfunctions
                                    .saveUserLoggedInSharedPreference(true);
                              }),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
