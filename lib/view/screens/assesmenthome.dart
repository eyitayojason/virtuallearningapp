import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:octo_image/octo_image.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';
import 'package:virtuallearningapp/services%20and%20providers/database.dart';
import 'package:virtuallearningapp/view/screens/playQuiz.dart';
import 'package:virtuallearningapp/view/screens/student/dashboard/dashboard.dart';
import 'student/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'student/course_content/course_content.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

Authentication authentication;
final _auth = FirebaseAuth.instance;
User currentuser;

class _HomeState extends State<Home> {
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        currentuser = user;
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  Stream quizStream;
  DatabaseService databaseService = DatabaseService();

  Widget quizList() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: databaseService.getQuizData(),
              builder: (
                context,
                snapshot,
              ) {
                String dispName = FirebaseAuth.instance.currentUser.displayName;
                return snapshot.data == null ||
                        snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.none
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text(
                            "Dear $dispName,\nThere is no assesment for you at this time",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            child: Text("Go back"),
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavBAr(
                                  pages: [
                                    StudentDashboard(),
                                    StudentCourseContent(),
                                    Home(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                    : ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                              height: 20,
                            ),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return QuizTile(
                            noOfQuestions: snapshot.data.docs.length,
                            imageUrl: snapshot.data.docs[index]
                                .data()['quizImgUrl'] as String,
                            title:
                                snapshot.data.docs[index].data()['quizTitle'],
                            description:
                                snapshot.data.docs[index].data()['quizDesc'],
                            quizId: snapshot.data.docs[index].data()["id"],
                          );
                        });
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    databaseService.getQuizData().then((value) {
      // quizStream = value;
      setState(() {});
    });
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Assesment HomePage",
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //brightness: Brightness.li,
      ),
      body: quizList(),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String imageUrl, title, quizId, description;
  final int noOfQuestions;

  QuizTile(
      {@required this.title,
      @required this.imageUrl,
      @required this.description,
      @required this.quizId,
      @required this.noOfQuestions});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return QuizPlay(quizId);
            },
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // OctoImage(
              //   image: CachedNetworkImageProvider(imageUrl.toString()),
              //   placeholderBuilder: OctoPlaceholder.blurHash(
              //     'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
              //   ),
              //   errorBuilder: OctoError.icon(color: Colors.red),
              //   fit: BoxFit.cover,
              // ),
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                color: Colors.black26,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
