import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:virtuallearningapp/main.dart';
import 'auth.dart';
import 'messagestream.dart';

class ChatStream extends StatelessWidget {
  final TextEditingController messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    var authprovider = Provider.of<Authentication>(
      context,
    );
    return Stack(
      children: [
        Image.asset(
          "assets/images/schoolbg.png",
          fit: BoxFit.fitHeight,
          color: Colors.white.withOpacity(0.8),
          colorBlendMode: BlendMode.screen,
          height: double.infinity,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            MessagesStream(),
            Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      await authprovider
                          .selectImageFile()
                          .whenComplete(() async {
                        await authprovider.uploadImageFile();
                      });
                      await _firestore.collection("Messages").add({
                        "sender": FirebaseAuth.instance.currentUser.displayName,
                        "imageURL": firebaseDownloadUrl,
                        "timestamp": FieldValue.serverTimestamp()
                      });
                    },
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      await authprovider
                          .selectVideoFile()
                          .whenComplete(() async {
                        await authprovider.uploadVideoFile();
                      });
                      await _firestore.collection("Messages").add({
                        "sender": FirebaseAuth.instance.currentUser.displayName,
                        "videoURL": firebasevideoURL,
                        "timestamp": FieldValue.serverTimestamp()
                      });
                    },
                    child: Icon(
                      Icons.video_library,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.green,
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
                  isRecorded
                      ? isUploading
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.upload_file),
                                    onPressed: () async {
                                      await authprovider
                                          .onFileUploadButtonPressed(
                                              context: context);
                                      await _firestore
                                          .collection("Messages")
                                          .add({
                                        "sender": FirebaseAuth
                                            .instance.currentUser.displayName,
                                        "audioURL": recordingURL,
                                        "audioName": "AUD" + randomNumeric(5),
                                        "timestamp":
                                            FieldValue.serverTimestamp()
                                      });
                                    }),
                              ],
                            )
                      : IconButton(
                          icon: isRecording
                              ? Icon(Icons.stop)
                              : Icon(
                                  Icons.fiber_manual_record,
                                  color: Colors.red,
                                ),
                          onPressed: () {
                            authprovider.onRecordButtonPressed();
                          },
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        messageTextController.clear();
                        _firestore.collection("Messages").add({
                          "sender":
                              FirebaseAuth.instance.currentUser.displayName,
                          "text": chattext,
                          "timestamp": FieldValue.serverTimestamp(),
                        });
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.orange,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
