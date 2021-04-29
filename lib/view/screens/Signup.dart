import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';
import 'package:virtuallearningapp/view/screens/Firstscreen.dart';
import 'package:virtuallearningapp/view/screens/widgets/button.dart';
import 'package:virtuallearningapp/view/screens/widgets/form_textfield.dart';
import 'package:virtuallearningapp/view/screens/widgets/logo.dart';

final _auth = FirebaseAuth.instance;
String email;
String password;
String fullname;
String matricStaffno;
User user;

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authentication = Provider.of<Authentication>(context);

    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: authentication.showspinner,
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
                  SignupForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
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
              hintText: 'Fullname',
              obsureText: false,
              validate: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
              },
              onChanged: (value) {
                fullname = value;
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
              onPressed: () async {
                try {
                  if (formKey.currentState.validate()) {
                    authentication.showSpinner();
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FirstScreen(),
                        ),
                      );
                    }
                    authentication.showSubmitRequestSnackBar(
                        context, "Registration Complete, Proceed to LOGIN");

                    authentication.stopSpinner();
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
