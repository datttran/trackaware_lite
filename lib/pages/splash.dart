import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/utils.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor(ColorStrings.splashBackground),
        body: Container(
          child: Image.asset("images/ic_track_logo.png"),
          alignment: Alignment.center,
        ));
  }
}
