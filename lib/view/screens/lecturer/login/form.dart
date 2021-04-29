import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';
import 'package:virtuallearningapp/view/screens/lecturer/course_content/course_content.dart';
import 'package:virtuallearningapp/view/screens/lecturer/dashboard/dashboard.dart';
import 'package:virtuallearningapp/view/screens/student/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:virtuallearningapp/view/screens/widgets/button.dart';
import 'package:virtuallearningapp/view/screens/widgets/form_textfield.dart';

String email;
String password;
final _auth = FirebaseAuth.instance;
User loggedinuser;

class LecturerForm extends StatefulWidget {
  @override
  _LecturerFormState createState() => _LecturerFormState();
}

class _LecturerFormState extends State<LecturerForm> {
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        loggedinuser = user;
        print(loggedinuser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var authentication = Provider.of<Authentication>(context);

    return Form(
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
                  email = value;
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
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  authentication.showSpinner();
                  authentication
                      .signInWithEmailAndPassword(email, password)
                      .whenComplete(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavBAr(
                          pages: [
                            LecturerDashboard(),
                            LecturerCourseContent(),
                          ],
                        ),
                      ),
                    );
                    authentication.writeNewUserToDatabase();
                    authentication.showSubmitRequestSnackBar(
                        context, "Welcome " + loggedinuser.email);
                   
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
