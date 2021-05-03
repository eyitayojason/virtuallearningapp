import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


import 'package:virtuallearningapp/services%20and%20providers/model.dart';
import 'package:path/path.dart';

class Authentication with ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  String uemail;
  User loggedinuser;
  UploadTask uploadTask;
  File file;
  String url;

  FireUser _userFromFirebaseUser(User user) {
    return user != null ? FireUser(user.uid) : null;
  }

  // void urlLauncher() {
  //   launch("$url");
  //   notifyListeners();
  // }

  Future signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      loggedinuser = userCredential.user;

      return _userFromFirebaseUser(loggedinuser);
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }

  Future signUpwithEmailandPassword(
      String email, String password, String displayName) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      await userCredential.user.updateProfile(displayName: displayName);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future logout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future uploadFile() async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('imageURL/${basename(file.path)}}');
    uploadTask = storageReference.putFile(file);
    await uploadTask.whenComplete(() {});
    print('File Uploaded');

    url = await storageReference.getDownloadURL();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        loggedinuser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  // void showSubmitRequestSnackBar(BuildContext context, String message) async {
  //   Flushbar(
  //     flushbarPosition: FlushbarPosition.TOP,
  //     message: message,
  //     icon: Icon(
  //       Icons.info_outline,
  //       size: 28.0,
  //       color: Colors.white,
  //     ),
  //     backgroundColor: Colors.green,
  //     duration: Duration(seconds: 4),
  //     leftBarIndicatorColor: Colors.green,
  //   )..show(context);

  //   notifyListeners();
  // }

  void writeNewUserToDatabase(String displayName) async {
    //check if already signed up
    // final QuerySnapshot result = await FirebaseFirestore.instance
    //     .collection('users')
    //     .where('id', isEqualTo: loggedinuser.uid)
    //     .get();
    // final List<DocumentSnapshot> documents = result.docs;
    // if (documents.length == 0) {
    //   //update data to server if new user
    //   await FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(loggedinuser.uid)
    //       .set({
    //     'fullname': loggedinuser.displayName,
    //   }).whenComplete(() {
    //     print("done");
    //   });
    // }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(loggedinuser.uid)
        .set({
      'fullname': loggedinuser.displayName,
    }).whenComplete(() {
      print("done");
    });
  }

  notifyListeners();
}
