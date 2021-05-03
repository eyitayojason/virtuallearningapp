import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';

Authentication authentication = Authentication();
final _firestore = FirebaseFirestore.instance;
User loggedinuser;

String url;

File file;

class AddNewContent extends StatefulWidget {
  @override
  _AddNewContentState createState() => _AddNewContentState();
}

class _AddNewContentState extends State<AddNewContent> {
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;

    setState(() => file = File(path));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(10),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                splashColor: Colors.orange,
                splashFactory: InkSplash.splashFactory,
                onTap: () async {
                  await selectFile().whenComplete(() async {
                    await authentication.uploadFile();
                  });
                },
                child: Row(
                  children: [
                    LineIcon(Icons.upload_outlined),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Add New Content")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

_sendMessage({
  String pdf,
}) async {
  await _firestore.collection("Messages").add({
    "sender": loggedinuser.displayName,
    "PdfURL": pdf,
    "timestamp": Timestamp.now().toDate()
  });
}
