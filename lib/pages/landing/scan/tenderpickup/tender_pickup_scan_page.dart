import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/tender_pickup_scan_bloc.dart';
import 'package:trackaware_lite/events/tender_pickup_scan_event.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/states/tender_pickup_scan_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';

class TenderScanPage extends StatefulWidget {
  @override
  State<TenderScanPage> createState() {
    return _TenderScanPageState();
  }
}

final List<String> _tenderScanItems = <String>[Strings.TENDER_PRODUCTION_PARTS, Strings.TENDER_EXTERNAL_PACKAGES];

final List<String> _pickUpScanItems = <String>[Strings.PICKUP_PRODUCTION_PARTS, Strings.PICKUP_EXTERNAL_PACKAGES];

var _tenderScanBloc;

class _TenderScanPageState extends State<TenderScanPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tenderScanBloc = BlocProvider.of<TenderPickUpScanBloc>(context);

    Widget getScaffold() {
      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
              backgroundColor: HexColor(ColorStrings.boxBackground).withAlpha(30),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: <Widget>[Image.asset("images/ic_back.png")],
                ),
              ),
              middle: Text(Strings.SCAN)),
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
                          title: Text(globals.tabScanPosName == Strings.tenderTitle ? _tenderScanItems[position] : _pickUpScanItems[position],
                              style: TextStyle(color: const Color(0xff202020), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0)),
                          trailing: Image.asset("images/ic_chevron_right.png"),
                          onTap: () {
                            if (globals.tabScanPosName == Strings.tenderTitle) {
                              globals.pickScanOption = _tenderScanItems[position];
                              if (position == 0) {
                                _tenderScanBloc.dispatch(TenderProductionPartsEvent());
                              } else {
                                _tenderScanBloc.dispatch(TenderExternalPackagesEvent());
                              }
                            } else {
                              globals.pickScanOption = _pickUpScanItems[position];
                              if (position == 0) {
                                _tenderScanBloc.dispatch(PickUpProductionPartsEvent());
                              } else {
                                _tenderScanBloc.dispatch(PickUpExternalPackagesEvent());
                              }
                            }
                          },
                        )),
                    Divider(thickness: 1.0, color: const Color(0xff979797))
                  ]);
                },
                itemCount: globals.tabScanPosName == Strings.tenderTitle ? _tenderScanItems.length : _pickUpScanItems.length,
              )));
    }

    Widget getCupertinoScaffold(TenderPickUpScanState state, _tenderScanBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                Navigator.pop(context);
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<TenderPickUpScanBloc, TenderPickUpScanState>(
        listener: (context, state) {
          if (state is NavigateToTenderProductionPartsScan) {
            globals.scanOption = Strings.TENDER_PRODUCTION_PARTS;
          }

          if (state is NavigateToTenderExternalPackagesScan) {
            globals.scanOption = Strings.TENDER_EXTERNAL_PACKAGES;
          }

          if (state is NavigateToPickUpProductionPartsScan) {
            globals.scanOption = Strings.PICKUP_PRODUCTION_PARTS;
          }

          if (state is NavigateToPickUpExternalPackagesScan) {
            globals.scanOption = Strings.PICKUP_EXTERNAL_PACKAGES;
          }

          if (state is NavigateToTenderProductionPartsScan ||
              state is NavigateToTenderExternalPackagesScan ||
              state is NavigateToPickUpProductionPartsScan ||
              state is NavigateToPickUpExternalPackagesScan) {
            Navigator.of(context).pushNamed('/ScanOption');
          }
        },
        child: BlocBuilder<TenderPickUpScanBloc, TenderPickUpScanState>(
            bloc: _tenderScanBloc,
            builder: (
              BuildContext context,
              TenderPickUpScanState state,
            ) {
              return getCupertinoScaffold(state, _tenderScanBloc);
            }));
  }
}
