import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';
import 'package:virtuallearningapp/view/screens/lecturer/login/form.dart';
import 'package:virtuallearningapp/view/screens/widgets/logo.dart';
import 'package:sizer/sizer.dart';

class LecturerLogin extends StatelessWidget {
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
                  Text('Login as a Lecturer'),
                  SizedBox(height: 5.0.h),
                  LecturerForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
