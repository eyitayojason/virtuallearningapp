import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:virtuallearningapp/main.dart';
import 'package:virtuallearningapp/services%20and%20providers/messagestream.dart';
import 'package:path/path.dart';

final _firestore = FirebaseFirestore.instance;
User loggedinuser;
final _auth = FirebaseAuth.instance;
MessagesStream messageStream;
UploadTask uploadTask;
File file;
String pdf;
String path;

class LecturerClassroom extends StatefulWidget {
  @override
  _LecturerClassroomState createState() => _LecturerClassroomState();
}

class _LecturerClassroomState extends State<LecturerClassroom> {
  final messageTextController = TextEditingController();

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

  Future uploadFile() async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('imageURL/${basename(file.path)}}');
    uploadTask = storageReference.putFile(file);
    await uploadTask.whenComplete(() async {
      firebaseDownloadUrl = await storageReference.getDownloadURL();
    });
    print(firebaseDownloadUrl);
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    path = result.files.single.path;
    setState(() => file = File(path));
    print(path);
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          body: Stack(
            children: [
              Image.asset(
                "assets/images/schoolbg.png",
                fit: BoxFit.fitHeight,
                color: Colors.white.withOpacity(0.8),
                colorBlendMode: BlendMode.screen,
                height: double.infinity,
              ),
              Column(
                children: <Widget>[
                  MessagesStream(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                      height: 60,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                await selectFile().whenComplete(() async {
                                  await uploadFile();
                                });
                                await _firestore.collection("Messages").add({
                                  "sender": loggedinuser.displayName,
                                  "imageURL": firebaseDownloadUrl,
                                  "timestamp": Timestamp.now().toDate()
                                });
                                print(firebaseDownloadUrl);
                              },
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: "Write message...",
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none),
                              controller: messageTextController,
                              onChanged: (value) {
                                chattext = value;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              messageTextController.clear();
                              _firestore.collection("Messages").add({
                                "sender": loggedinuser.displayName,
                                "text": chattext,
                                "timestamp": Timestamp.now().toDate()
                              });
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                            backgroundColor: Colors.orange,
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// FutureBuilder<File>(
//   future: DefaultCacheManager().getSingleFile(
//     'https://github.com/espresso3389/flutter_pdf_render/raw/master/example/assets/hello.pdf'),
//   builder: (context, snapshot) => snapshot.hasData
//     ? PdfViewer.openFile(snapshot.data!.path)
//     : Container( /* placeholder */),
// )
