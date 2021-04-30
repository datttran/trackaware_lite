import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/scan_option_bloc.dart';
import 'package:trackaware_lite/pages/landing/scan/scanoptions/scan_option_page.dart';

class ScanOption extends StatefulWidget {
  ScanOption({Key key}) : super(key: key);
  @override
  _ScanOptionState createState() => new _ScanOptionState();
}

class _ScanOptionState extends State<ScanOption> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (context) {
          return ScanOptionBloc();
        },
        child: ScanOptionPage());
  }
}
