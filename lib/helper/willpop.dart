import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtuallearningapp/view/screens/lecturer/login/Loginscreen.dart';

class WillPop extends StatelessWidget {
  final Widget child;
  WillPop({this.child});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: Text('Are you sure you want to quit?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('sign out'),
                      onPressed: () => authService.logout().whenComplete(
                            () => Navigator.of(context).pop(true),
                          ),
                    ),
                    TextButton(
                        child: Text('cancel'),
                        onPressed: () => Navigator.of(context).pop(false)),
                  ])),
      child: child,
    );
  }
}
