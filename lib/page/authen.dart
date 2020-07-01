import 'package:armrci/utility/my_style.dart';
import 'package:flutter/material.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MyStyle().showlogo(),
            MyStyle().showTextH1('Royal Can'),
            userForm(),
          ],
        ),
      ),
    );
  }

  Widget userForm() => Container(width: 250,
        child: TextField(),
      );
}
