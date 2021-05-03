import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';
import 'package:virtuallearningapp/view/screens/Firstscreen.dart';
import 'package:virtuallearningapp/view/screens/widgets/button.dart';
import 'package:virtuallearningapp/view/screens/widgets/form_textfield.dart';
import 'package:virtuallearningapp/view/screens/widgets/logo.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

String email;
String password;
String displayName;
String matricStaffno;
User user;
bool isLoading = false;


class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Authentication authentication = Authentication();
final formKey = GlobalKey<FormState>();
  signUp() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      authentication.signUpwithEmailandPassword(email, password, displayName).then((val) {
        if (val != null) {
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FirstScreen(),
            ),
          );
        }
      });
    }
  
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: ModalProgressHUD(
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
                    Text('Register'),
                    SizedBox(height: 5.0.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          CustomFormField(
                            hintText: 'Fullname',
                            obsureText: false,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                            },
                            onChanged: (value) {
                              displayName = value;
                            },
                          ),
                          SizedBox(height: 20),
                          CustomFormField(
                            hintText: 'Matric Number/Staff Number',
                            textInputType: TextInputType.number,
                            obsureText: false,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Matric Number/Staff Number';
                              }
                            },
                            onChanged: (value) => matricStaffno = value,
                          ),
                          SizedBox(height: 20),
                          CustomFormField(
                            hintText: 'Email',
                            textInputType: TextInputType.emailAddress,
                            obsureText: false,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                            },
                            onChanged: (value) => email = value,
                          ),
                          SizedBox(height: 20),
                          CustomFormField(
                            hintText: 'Password',
                            obsureText: true,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                            },
                            onChanged: (value) => password = value,
                          ),
                          SizedBox(height: 20),
                          CustomButton(
                            text: 'SIGNUP',
                            onPressed: () {
                              signUp();
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
