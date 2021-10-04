import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtuallearningapp/main.dart';

int assignmentlist;

class AssignmentUpdates extends StatefulWidget {
  @override
  _AssignmentUpdatesState createState() => _AssignmentUpdatesState();
}

class _AssignmentUpdatesState extends State<AssignmentUpdates> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("assignments")
            .orderBy("timestamp", descending: false)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final contents = snapshot.data.docs;
          List<AssignmentCard> assignmentcontent = [];
          for (var content in contents) {
            courseweek = content.data()["week"];
            final assignmentDownloadUrl = content.data()["fileURL"];
            title = content.data()["coursetitle"];
            final sender = content.data()["sender"];
            coursetimestamp = content.data()["timestamp"].toString();
            final coursecontent = AssignmentCard(
                // courseTitle: title,
                pdflinkk: assignmentDownloadUrl,
                timestamp: coursetimestamp,
                sender: sender);
            assignmentcontent.add(coursecontent);
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            setState(() {
              assignmentlist = assignmentcontent.length;
            });
          });

          return ListView(
              scrollDirection: Axis.horizontal, children: assignmentcontent);
        });
  }
}

class AssignmentCard extends StatelessWidget {
  //final String courseTitle;
  final String pdflinkk;
  final String timestamp;
  final String sender;

  const AssignmentCard({this.pdflinkk, this.timestamp, this.sender});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => _launchURL(pdflinkk),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        sender,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        "assets/images/pdf.png",
                      ),
                    ),
                    Text(
                      timestamp.substring(0, 11),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

_launchURL(var url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
