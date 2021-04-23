import 'package:flutter/material.dart';
import 'package:virtuallearningapp/view/screens/widgets/bubblestyle.dart';
import 'package:virtuallearningapp/view/screens/widgets/chatbubbles.dart';
import 'package:virtuallearningapp/view/screens/widgets/conversationEntry.dart';

class StudentClassroom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey.shade400,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: InkWell(
                  child: Chatbubbles(
                    styleSomebody: Bubblestyle.styleSomebody,
                    styleMe: Bubblestyle.styleMe,
                  ),
                ),
              ),
              Conversationentrybox(),
            ],
          ),
        ),
      ),
    );
  }
}
