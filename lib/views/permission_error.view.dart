import 'package:flutter/material.dart';

class PermissionErrorView extends StatelessWidget {
  const PermissionErrorView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            child: Text("Permission Error"),
          ),
        ),
      ),
    );
  }
}
