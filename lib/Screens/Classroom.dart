import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:virtuallearningapp/Screens/Coursecontentlecurer.dart';
import 'Coursecontent.dart';

class Classroom extends StatelessWidget {
  static const styleSomebody = BubbleStyle(
    nip: BubbleNip.leftCenter,
    color: Colors.white,
    borderColor: Colors.blue,
    borderWidth: 1,
    elevation: 4,
    margin: BubbleEdges.only(top: 8, right: 50),
    alignment: Alignment.topLeft,
  );

  static const styleMe = BubbleStyle(
    nip: BubbleNip.rightCenter,
    color: Color.fromARGB(255, 225, 255, 199),
    borderColor: Colors.blue,
    borderWidth: 1,
    elevation: 4,
    margin: BubbleEdges.only(top: 8, left: 50),
    alignment: Alignment.topRight,
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey.shade400,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: Tabbar(
              text: "HND Computer Science",
            ),
          ),
          body: Stack(children: [
            SingleChildScrollView(
              child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Coursecontentlecturer(),
                      )),
                  child: Chatbubbles(
                      styleSomebody: styleSomebody, styleMe: styleMe)),
            ),
            Conversationentrybox(),
          ]),
        ),
      ),
    );
  }
}

class Chatbubbles extends StatelessWidget {
  const Chatbubbles({
    Key key,
    @required this.styleSomebody,
    @required this.styleMe,
  }) : super(key: key);

  final BubbleStyle styleSomebody;
  final BubbleStyle styleMe;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Bubble(
          alignment: Alignment.center,
          color: const Color.fromARGB(255, 212, 234, 244),
          margin: const BubbleEdges.only(top: 8),
          child: const Text(
            'TODAY',
            style: TextStyle(fontSize: 10),
          ),
        ),
        Bubble(
          style: styleSomebody,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Lecturer:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              const Text(
                  'Hi Jason. Sorry to bother you. I have a queston for you.'),
            ],
          ),
        ),
        Bubble(
          style: styleMe,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Student:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              const Text("Whats'up?"),
            ],
          ),
        ),
        Bubble(
          style: styleSomebody,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Lecturer:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              const Text("I've been having a problem with my computer."),
            ],
          ),
        ),
        Bubble(
          style: styleSomebody,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Lecturer:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              const Text('Can you help me?'),
            ],
          ),
        ),
        Bubble(
          style: styleMe,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Student:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              const Text('Ok'),
            ],
          ),
        ),
        Bubble(
          style: styleMe,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Student:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              const Text("What's the problem?"),
            ],
          ),
        ),
        Bubble(
          style: styleSomebody,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Lecturer:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              const Text(
                  'Hi Jason. Sorry to bother you. I have a queston for you.'),
            ],
          ),
        ),
        Bubble(
          style: styleMe,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Student:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              const Text("Whats'up?"),
            ],
          ),
        ),
        Bubble(
          style: styleSomebody,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Lecturer:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              const Text("I've been having a problem with my computer."),
            ],
          ),
        ),
        Bubble(
          style: styleSomebody,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Lecturer:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              const Text('Can you help me?'),
            ],
          ),
        ),
        Bubble(
          style: styleMe,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Student:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              const Text('Ok'),
            ],
          ),
        ),
        Bubble(
          style: styleMe,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Student:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              const Text("What's the problem?"),
            ],
          ),
        ),
      ],
    );
  }
}

class Conversationentrybox extends StatelessWidget {
  const Conversationentrybox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(30),
                ),
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
              ),
            ),
            SizedBox(
              width: 15,
            ),
            FloatingActionButton(
              onPressed: () {},
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              backgroundColor: Colors.blue,
              elevation: 0,
            ),
          ],
        ),
      ),
    );
  }
}
