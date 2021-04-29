import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';
import 'package:virtuallearningapp/view/screens/student/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:virtuallearningapp/view/screens/student/course_content/course_content.dart';
import 'package:virtuallearningapp/view/screens/student/dashboard/dashboard.dart';

import 'package:virtuallearningapp/view/screens/widgets/button.dart';
import 'package:virtuallearningapp/view/screens/widgets/form_textfield.dart';

String email;
String password;

class StudentForm extends StatelessWidget {
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
              text: 'SUBMIT',
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  authentication.showSpinner();
                  authentication
                      .signInWithEmailAndPassword(email, password)
                      .whenComplete(() async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavBAr(
                          pages: [
                            StudentDashboard(),
                            StudentCourseContent(),
                          ],
                        ),
                      ),
                    );
                    authentication.writeNewUserToDatabase();

                    authentication.showSubmitRequestSnackBar(
                        context, "Welcome " + authentication.uemail);
                    print(authentication.uemail);
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
