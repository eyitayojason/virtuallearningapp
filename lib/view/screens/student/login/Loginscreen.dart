import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sizer/sizer.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';
import 'package:virtuallearningapp/view/screens/student/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:virtuallearningapp/view/screens/student/course_content/course_content.dart';
import 'package:virtuallearningapp/view/screens/student/dashboard/dashboard.dart';
import 'package:virtuallearningapp/widgets/alertdialog.dart';
import 'package:virtuallearningapp/widgets/button.dart';
import 'package:virtuallearningapp/widgets/form_textfield.dart';
import 'package:virtuallearningapp/widgets/logo.dart';
import '../../assesmenthome.dart';

bool isLoading = false;
String email;
String password;
String displayName;
final _auth = FirebaseAuth.instance;
final formKey = GlobalKey<FormState>();
User loggedinuser;
Authentication authService = Authentication();

class StudentLogin extends StatefulWidget {
  @override
  _StudentLoginState createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedinuser = user;
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
        // ignore: unused_local_variable
        final status =
            await authService.signInWithEmailAndPassword(email, password);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBAr(
              pages: [
                StudentDashboard(),
                StudentCourseContent(),
                Home(),
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
                  Text('Login as a Student'),
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
