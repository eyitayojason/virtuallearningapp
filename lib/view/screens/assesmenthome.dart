import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';
import 'package:virtuallearningapp/services%20and%20providers/database.dart';
import 'package:virtuallearningapp/view/screens/lecturer/dashboard/dashboard.dart';
import 'package:virtuallearningapp/view/screens/playQuiz.dart';
import 'package:virtuallearningapp/view/screens/student/dashboard/dashboard.dart';

import 'lecturer/course_content/course_content.dart';
import 'lecturer/createquiz.dart';
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
            child: StreamBuilder(
              builder: (
                context,
                snapshot,
              ) {
                String dispName = data.data()["displayName"];
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
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return QuizTile(
                            noOfQuestions: snapshot.data.docs.length,
                            imageUrl:
                                snapshot.data.docs[index].data()['quizImgUrl'],
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
      quizStream = value;
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
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //brightness: Brightness.li,
      ),
      body: quizList(),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => CreateQuiz()));
      //   },
      // ),
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
