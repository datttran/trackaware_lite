import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/scan_option_bloc.dart';
import 'package:trackaware_lite/events/scan_option_event.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/states/scan_option_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';

class ScanOptionPage extends StatefulWidget {
  @override
  State<ScanOptionPage> createState() {
    return _ScanOptionPageState();
  }
}

final List<String> _tenderPartItems = <String>[Strings.ORDER_NUMBER_SCAN, Strings.PART_NUMBER_SCAN, Strings.TOOL_NUMBER_SCAN];

final List<String> _tenderExternalItems = <String>[Strings.ORDER_NUMBER_SCAN, Strings.REF_NUMBER_SCAN, Strings.PART_NUMBER_SCAN, Strings.TRACKING_NUMBER_SCAN];

final List<String> _pickUpPartItems = <String>[Strings.ORDER_NUMBER_SCAN, Strings.PART_NUMBER_SCAN];

final List<String> _pickUpExternalItems = <String>[Strings.TRACKING_NUMBER_SCAN];

var _scanOptionBloc;

class _ScanOptionPageState extends State<ScanOptionPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scanOptionBloc = BlocProvider.of<ScanOptionBloc>(context);

    Widget getScaffold() {
      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
              backgroundColor: HexColor(ColorStrings.boxBackground).withAlpha(30),
              leading: GestureDetector(
                onTap: () {
                  navigationBack();
                },
                child: Row(
                  children: <Widget>[Image.asset("images/ic_back.png")],
                ),
              ),
              middle: Text(Strings.PICK_SCAN_ITEM)),
          child: Container(
              padding: EdgeInsets.fromLTRB(0, 72, 0, 0),
              decoration: BoxDecoration(color: HexColor(ColorStrings.boxBackground).withAlpha(30)),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                shrinkWrap: false,
                itemBuilder: (context, position) {
                  return Column(children: [
                    Material(
                        color: Colors.transparent,
                        child: ListTile(
                          title: Text(_getTitle(position), style: TextStyle(color: const Color(0xff202020), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0)),
                          trailing: Image.asset("images/ic_chevron_right.png"),
                          onTap: () {
                            navigateToScan(position);
                          },
                        )),
                    Divider(thickness: 1.0, color: const Color(0xff979797))
                  ]);
                },
                itemCount: _getItemCount(),
              )));
    }

    Widget getCupertinoScaffold(ScanOptionState state, _scanOptionBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                navigationBack();
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<ScanOptionBloc, ScanOptionState>(
        listener: (context, state) {
          if (state is OrderNumberScanSuccess) {
            globals.orderNumber = state.barCode;
          }

          if (state is PartNumberScanSuccess) {
            globals.partNumber = state.barCode;
          }

          if (state is RefNumberScanSuccess) {
            globals.refNumber = state.barCode;
          }

          if (state is ToolNumberScanSuccess) {
            globals.toolNumber = state.barCode;
          }

          if (state is TrackingNumberScanSuccess) {
            globals.trackingNumber = state.barCode;
          }

          if (state is OrderNumberScanSuccess || state is PartNumberScanSuccess || state is RefNumberScanSuccess || state is ToolNumberScanSuccess || state is TrackingNumberScanSuccess) {
            globals.navFrom = Strings.SCAN_OPTION;
            navigateToForm();
          }
        },
        child: BlocBuilder<ScanOptionBloc, ScanOptionState>(
            bloc: _scanOptionBloc,
            builder: (
              BuildContext context,
              ScanOptionState state,
            ) {
              return getCupertinoScaffold(state, _scanOptionBloc);
            }));
  }

  void navigateTenderExternal(int position) {
    switch (position) {
      case 0:
        {
          _scanOptionBloc.dispatch(OrderNumberScanEvent());
          break;
        }
      case 1:
        {
          _scanOptionBloc.dispatch(RefNumberScanEvent());
          break;
        }
      case 2:
        {
          _scanOptionBloc.dispatch(PartNumberScanEvent());
          break;
        }
      case 3:
        {
          _scanOptionBloc.dispatch(TrackingNumberScanEvent());
          break;
        }
    }
  }

  void navigateTenderPart(int position) {
    switch (position) {
      case 0:
        {
          _scanOptionBloc.dispatch(OrderNumberScanEvent());
          break;
        }
      case 1:
        {
          _scanOptionBloc.dispatch(PartNumberScanEvent());
          break;
        }
      case 2:
        {
          _scanOptionBloc.dispatch(ToolNumberScanEvent());
          break;
        }
    }
  }

  void navigatePickUpExternal() {
    _scanOptionBloc.dispatch(TrackingNumberScanEvent());
  }

  void navigatePickUpPart(int position) {
    switch (position) {
      case 0:
        {
          _scanOptionBloc.dispatch(OrderNumberScanEvent());
          break;
        }
      case 1:
        {
          _scanOptionBloc.dispatch(PartNumberScanEvent());
          break;
        }
    }
  }

  void navigateToForm() {
    switch (globals.scanOption) {
      case Strings.TENDER_EXTERNAL_PACKAGES:
        {
          Navigator.of(context).pushNamed('/NewTenderExternalScreen');
          break;
        }
      case Strings.CREATE_TENDER_EXTERNAL_PACKAGES:
        {
          globals.navFrom = "";
          Navigator.of(context).pushNamed('/NewTenderExternalScreen');
          break;
        }
      case Strings.TENDER_PRODUCTION_PARTS:
        {
          Navigator.of(context).pushNamed('/NewTenderPartsScreen');
          break;
        }
      case Strings.CREATE_TENDER_PRODUCTION_PARTS:
        {
          globals.navFrom = "";
          Navigator.of(context).pushNamed('/NewTenderPartsScreen');
          break;
        }
      case Strings.PICKUP_EXTERNAL_PACKAGES:
        {
          Navigator.of(context).pushNamed('/NewPickUpExternalScreen');
          break;
        }
      case Strings.CREATE_PICKUP_EXTERNAL_PACKAGES:
        {
          globals.navFrom = "";
          Navigator.of(context).pushNamed('/NewPickUpExternalScreen');
          break;
        }
      case Strings.PICKUP_PRODUCTION_PARTS:
        {
          Navigator.of(context).pushNamed('/NewPickUpPartsScreen');
          break;
        }
      case Strings.CREATE_PICKUP_PRODUCTION_PARTS:
        {
          globals.navFrom = "";
          Navigator.of(context).pushNamed('/NewPickUpPartsScreen');
          break;
        }
    }
  }

  int _getItemCount() {
    switch (globals.scanOption) {
      case Strings.TENDER_EXTERNAL_PACKAGES:
        {
          globals.navFrom = Strings.SCAN_OPTION;
          return _tenderExternalItems.length;
        }
      case Strings.CREATE_TENDER_EXTERNAL_PACKAGES:
        {
          globals.navFrom = "";
          return _tenderExternalItems.length;
        }
      case Strings.TENDER_PRODUCTION_PARTS:
        {
          globals.navFrom = Strings.SCAN_OPTION;
          return _tenderPartItems.length;
        }
      case Strings.CREATE_TENDER_PRODUCTION_PARTS:
        {
          globals.navFrom = "";
          return _tenderPartItems.length;
        }
      case Strings.PICKUP_EXTERNAL_PACKAGES:
        {
          globals.navFrom = Strings.SCAN_OPTION;
          return _pickUpExternalItems.length;
        }
      case Strings.CREATE_PICKUP_EXTERNAL_PACKAGES:
        {
          globals.navFrom = "";
          return _pickUpExternalItems.length;
        }
      case Strings.PICKUP_PRODUCTION_PARTS:
        {
          globals.navFrom = Strings.SCAN_OPTION;
          return _pickUpPartItems.length;
        }
      case Strings.CREATE_PICKUP_PRODUCTION_PARTS:
        {
          globals.navFrom = "";
          return _pickUpPartItems.length;
        }
      default:
        {
          return -1;
        }
    }
  }

  void navigateToScan(int position) {
    switch (globals.scanOption) {
      case Strings.TENDER_EXTERNAL_PACKAGES:
      case Strings.CREATE_TENDER_EXTERNAL_PACKAGES:
        {
          globals.pickScanOption = _tenderExternalItems[position];
          navigateTenderExternal(position);
          break;
        }
      case Strings.TENDER_PRODUCTION_PARTS:
      case Strings.CREATE_TENDER_PRODUCTION_PARTS:
        {
          globals.pickScanOption = _tenderPartItems[position];
          navigateTenderPart(position);
          break;
        }
      case Strings.PICKUP_PRODUCTION_PARTS:
      case Strings.CREATE_PICKUP_PRODUCTION_PARTS:
        {
          globals.pickScanOption = _pickUpPartItems[position];
          navigatePickUpPart(position);
          break;
        }
      case Strings.PICKUP_EXTERNAL_PACKAGES:
      case Strings.CREATE_PICKUP_EXTERNAL_PACKAGES:
        {
          globals.pickScanOption = _pickUpExternalItems[position];
          navigatePickUpExternal();
          break;
        }
    }
  }

  String _getTitle(int position) {
    switch (globals.scanOption) {
      case Strings.TENDER_EXTERNAL_PACKAGES:
      case Strings.CREATE_TENDER_EXTERNAL_PACKAGES:
        {
          return _tenderExternalItems[position];
        }
      case Strings.TENDER_PRODUCTION_PARTS:
      case Strings.CREATE_TENDER_PRODUCTION_PARTS:
        {
          return _tenderPartItems[position];
        }
      case Strings.PICKUP_EXTERNAL_PACKAGES:
      case Strings.CREATE_PICKUP_EXTERNAL_PACKAGES:
        {
          return _pickUpExternalItems[position];
        }
      case Strings.PICKUP_PRODUCTION_PARTS:
      case Strings.CREATE_PICKUP_PRODUCTION_PARTS:
        {
          return _pickUpPartItems[position];
        }
      default:
        {
          return "";
        }
    }
  }

  void navigationBack() {
    switch (globals.scanOption) {
      case Strings.CREATE_TENDER_EXTERNAL_PACKAGES:
        {
          Navigator.of(context).pushNamed('/NewTenderExternalScreen');
          break;
        }
      case Strings.CREATE_TENDER_PRODUCTION_PARTS:
        {
          Navigator.of(context).pushNamed('/NewTenderPartsScreen');
          break;
        }
      case Strings.CREATE_PICKUP_EXTERNAL_PACKAGES:
        {
          Navigator.of(context).pushNamed('/NewPickUpExternalScreen');
          break;
        }
      case Strings.CREATE_PICKUP_PRODUCTION_PARTS:
        {
          Navigator.of(context).pushNamed('/NewPickUpPartsScreen');
          break;
        }
      default:
        {
          Navigator.of(context).pushNamed('/TenderPickUpScan');
          break;
        }
    }
  }
}
