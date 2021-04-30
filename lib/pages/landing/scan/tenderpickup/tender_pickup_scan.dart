import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/tender_pickup_scan_bloc.dart';
import 'package:trackaware_lite/pages/landing/scan/tenderpickup/tender_pickup_scan_page.dart';

class TenderPickUpScan extends StatefulWidget {
  TenderPickUpScan({Key key}) : super(key: key);
  @override
  _TenderPickUpScanState createState() => new _TenderPickUpScanState();
}

class _TenderPickUpScanState extends State<TenderPickUpScan> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (context) {
          return TenderPickUpScanBloc();
        },
        child: TenderScanPage());
  }
}
