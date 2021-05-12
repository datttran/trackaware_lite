import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff171721),
        body: Container(
          child: Image.asset("images/ic_launcher.png"),
          alignment: Alignment.center,
        ));
  }
}
