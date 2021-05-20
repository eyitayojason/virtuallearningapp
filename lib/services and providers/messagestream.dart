import 'package:audio_wave/audio_wave.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtuallearningapp/main.dart';
import 'package:virtuallearningapp/view/screens/lecturer/login/Loginscreen.dart';

import 'auth.dart';

AsyncSnapshot snapshot;
FirebaseAuth _auth;

class MessagesStream extends StatefulWidget {
  @override
  _MessagesStreamState createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  DocumentReference userRef;
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

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    authService.initAudioPlayer();
  }

  @override
  void dispose() {
    positionSubscription.cancel();
    audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Messages")
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messagechattext = message.data()["text"];
          recordingURL = message.data()["audioURL"];
          firebaseDownloadUrl = message.data()["imageURL"];
          final messageSender = message.data()["sender"];
          final timestamp = message.data()["timestamp"];
          final currentUser = authService.loggedinuser.displayName;
          final messageBubble = MessageBubble(
            timestamp: timestamp,
            picture: firebaseDownloadUrl,
            voiceNote: recordingURL,
            sender: messageSender,
            text: messagechattext,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: ListView(reverse: true, children: messageBubbles),
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key key,
    this.sender,
    this.text,
    this.timestamp,
    this.picture,
    this.voiceNote,
    this.isMe,
  }) : super(key: key);
  final timestamp;
  final String sender;
  final String text;
  final String picture;
  final String voiceNote;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    var authentication = Provider.of<Authentication>(context);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Image.network(
            picture.toString(),
            height: 300,
            errorBuilder: (context, error, stackTrace) => Container(),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                    onPressed: isPlaying ? null : () => authentication.play(),
                    iconSize: 20.0,
                    icon: Icon(Icons.play_arrow),
                    color: Colors.cyan,
                  ),
                  // IconButton(
                  //   onPressed: isPlaying ? () => authentication.pause() : null,
                  //   iconSize: 20.0,
                  //   icon: Icon(Icons.pause),
                  //   color: Colors.cyan,
                  // ),
                ]),
                position != null  
                    ? AudioWave(
                        height: 32,
                        width: 88,
                        spacing: 2.5,
                        bars: [
                          AudioWaveBar(
                              height: 10, color: Colors.lightBlueAccent),
                          AudioWaveBar(height: 30, color: Colors.blue),
                          AudioWaveBar(height: 70, color: Colors.black),
                          AudioWaveBar(height: 40),
                          AudioWaveBar(height: 20, color: Colors.orange),
                          AudioWaveBar(
                              height: 10, color: Colors.lightBlueAccent),
                          AudioWaveBar(height: 30, color: Colors.blue),
                          AudioWaveBar(height: 70, color: Colors.black),
                          AudioWaveBar(height: 40),
                          AudioWaveBar(height: 20, color: Colors.orange),
                          AudioWaveBar(
                              height: 10, color: Colors.lightBlueAccent),
                          AudioWaveBar(height: 30, color: Colors.blue),
                          AudioWaveBar(height: 70, color: Colors.black),
                          AudioWaveBar(height: 40),
                          AudioWaveBar(height: 20, color: Colors.orange),
                          AudioWaveBar(
                              height: 10, color: Colors.lightBlueAccent),
                          AudioWaveBar(height: 30, color: Colors.blue),
                          AudioWaveBar(height: 70, color: Colors.black),
                          AudioWaveBar(height: 40),
                          AudioWaveBar(height: 20, color: Colors.orange),
                        ],
                      )
                    : Container()
              ],
            ),
          ),
          text == null
              ? Container()
              : Material(
                  borderRadius: isMe
                      ? BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        )
                      : BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                  elevation: 4,
                  color: isMe ? Colors.lightBlueAccent : Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Text(
                          "$text",
                          style: TextStyle(
                              fontSize: 15,
                              color: isMe ? Colors.white : Colors.black87),
                        )
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
