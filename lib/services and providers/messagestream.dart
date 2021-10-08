import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtuallearningapp/main.dart';
import 'package:virtuallearningapp/widgets/Messagebubble.dart';
import '../main.dart';

class MessagesStream extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Messages")
            .orderBy("timestamp", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final messages = snapshot.data.docs.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messagechattext = message.data()["text"];
            recordingURL = message.data()["audioURL"];
            firebaseDownloadUrl = message.data()["imageURL"];
            firebasevideoURL = message.data()["videoURL"];
            audioname = message.data()["audioName"];
            final messageSender = message.data()["sender"];
            final timestamp = message.data()["timestamp"];
            final currentUser = FirebaseAuth.instance.currentUser.displayName;
            final messageBubble = MessageBubble(
              timestamp: timestamp,
              picture: firebaseDownloadUrl,
              video: firebasevideoURL,
              audioname: audioname,
              voiceNote: recordingURL,
              sender: messageSender,
              text: messagechattext,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
          return Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: SingleChildScrollView(
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  itemCount: messageBubbles.length,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    return messageBubbles[index];
                  },
                ),
              ),
            ),
          );
        },
      );
}
