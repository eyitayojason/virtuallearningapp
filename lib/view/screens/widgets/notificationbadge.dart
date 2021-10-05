import 'package:flutter/material.dart';

class NamedIcon extends StatelessWidget {
  final IconData iconData;

  final String text2;
  final VoidCallback onTap;
  const NamedIcon({
    @required this.iconData,
    this.text2,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                iconData,
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
              child: Text(
                text2, 
              ),
            ),
          )
        ],
      ),
    );
  }
}
