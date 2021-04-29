import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtuallearningapp/view/screens/lecturer/course_content/tabs/classroom/classroom.dart';
import 'package:virtuallearningapp/view/screens/widgets/chatbubbles.dart';
final _firestore = FirebaseFirestore.instance;

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection("Messages")
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot == null) {
          Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()["text"];
          final messageSender = message.data()["sender"];
          final timestamp = message.data()["timestamp"];
          final currentUser = loggedinuser.email;
          final messageBubble = MessageBubble(
            timestamp: timestamp,
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }

        return Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: ListView(
            children: messageBubbles,
            reverse: true,
          ),
        ));
      },
    );
  }
}
