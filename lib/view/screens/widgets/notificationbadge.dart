import 'package:flutter/material.dart';

import 'package:virtuallearningapp/view/screens/lecturer/dashboard/layouts/assignment_updates.dart';

class NamedIcon extends StatefulWidget {
  final IconData iconData;

  final int text2;
  final VoidCallback onTap;

  const NamedIcon({
    Key key,
    @required this.iconData,
    this.text2,
    this.onTap,
  }) : super(key: key);

  @override
  _NamedIconState createState() => _NamedIconState();
}

class _NamedIconState extends State<NamedIcon> {
  @override
  void initState() {
    super.initState();
    setState(() {
      assignmentlist = widget.text2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => Tooltip(
      //   message: '$assignmentlist Students Have Submitted Assignments',
      // ),
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  widget.iconData,
                  color: Colors.white,
                  size: 28,
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                alignment: Alignment.center,
                child: Text("2") //widget.text2.toString()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
