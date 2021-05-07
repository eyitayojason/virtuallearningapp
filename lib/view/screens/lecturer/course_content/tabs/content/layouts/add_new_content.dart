import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';

Authentication authentication = Authentication();

class AddNewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(10),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  LineIcon(Icons.upload_outlined),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Add New Content")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
