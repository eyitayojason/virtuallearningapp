import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:virtuallearningapp/view/screens/lecturer/course_content/tabs/classroom/classroom.dart';
import 'package:virtuallearningapp/view/screens/lecturer/login/Loginscreen.dart';
import 'package:chewie/chewie.dart';

final _firestore = FirebaseFirestore.instance;
var pdf;  

class MessagesStream extends StatefulWidget {
  @override
  _MessagesStreamState createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  @override
  void initState() {
    super.initState();
    authService.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection("Messages")
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()["text"];
          url = message.data()["imageURL"];
          pdf = message.data()["PdfURL"];
          final messageSender = message.data()["sender"];
          final timestamp = message.data()["timestamp"];
          final currentUser = authService.loggedinuser.displayName;
          final messageBubble = MessageBubble(
            timestamp: timestamp,
            picture: url,
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        return snapshot.hasData
            ? Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: ListView(reverse: true, children: messageBubbles),
                ),
              )
            : Container();
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
    this.isMe,
  }) : super(key: key);
  final timestamp;
  final String sender;
  final String text;
  final String picture;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Material(
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
                        color: isMe ? Colors.white : Colors.black54),
                  ),
                  Image.network(
                    "$picture",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
