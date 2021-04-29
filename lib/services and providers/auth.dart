import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtuallearningapp/view/screens/lecturer/login/form.dart';

class Authentication with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  bool showspinner = false;
  String uemail;
  User loggedinuser;

  signInWithEmailAndPassword(String loginemail, String loginpassword) async {
    await _auth.signInWithEmailAndPassword(
        email: loginemail, password: password);

    // final user = (await _auth.signInWithEmailAndPassword(
    //         email: loginemail, password: loginpassword))
    //     .user;

    notifyListeners();
  }

  logout() {
    _auth.signOut();
  }

  // void getCurrentUser() async {
  //   try {
  //     final user = _auth.currentUser;

  //     if (user != null) {
  //       loggedinuser = user;
  //       print(loggedinuser.email);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }

    
  // }

  void showSpinner() async {
    showspinner = true;

    notifyListeners();
  }

  void stopSpinner() async {
    showspinner = false;
    notifyListeners();
  }

  void showSubmitRequestSnackBar(BuildContext context, String message) async {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      message: message,
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.white,
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 4),
      leftBarIndicatorColor: Colors.green,
    )..show(context);

    notifyListeners();
  }

  void writeNewUserToDatabase() async {
    try {
      if (User != null) {
        //check if already signed up
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: loggedinuser.uid)
            .get();
        final List<DocumentSnapshot> documents = result.docs;
        if (documents.length == 0) {
          //update data to server if new user
          FirebaseFirestore.instance
              .collection('users')
              .doc(loggedinuser.uid)
              .set({
            'nickname': loggedinuser.displayName,
            'photoUrl': loggedinuser.photoURL,
            'id': loggedinuser.uid
          }).whenComplete(() {
            print("done");
          });
        }
      }
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }
}
