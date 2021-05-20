import 'package:flutter/material.dart';
class CustomAppBar extends StatelessWidget {
  final String username;
  final String departmentname;
  final Function onpressed;
  const CustomAppBar({
    this.username,
    this.departmentname,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  username,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.school,
                      color: Colors.green,
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      departmentname,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 50,
                  ),
                  onPressed: onpressed),
            ),
          ],
        ),
      ),
    );
  }
}
