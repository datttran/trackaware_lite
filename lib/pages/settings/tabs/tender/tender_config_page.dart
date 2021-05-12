import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/tender_config_bloc.dart';
import 'package:trackaware_lite/events/tender_config_event.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/states/tender_config_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';

class TenderConfigPage extends StatefulWidget {
  @override
  State<TenderConfigPage> createState() {
    return _TenderConfigPageState();
  }
}

var tenderConfigBloc;

class _TenderConfigPageState extends State<TenderConfigPage> {
  @override
  void dispose() {
    super.dispose();
  }

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
            middle: Text(Strings.tenderTitle)),
        child: Container(
            decoration: BoxDecoration(color: HexColor(ColorStrings.boxBackground).withAlpha(30)),
            child: Stack(children: <Widget>[
              ListView(
                children: <Widget>[
                  Material(
                      color: Colors.transparent,
                      child: ListTile(
                        title: Text(Strings.TENDER_PRODUCTION_PARTS, style: TextStyle(color: const Color(0xff202020), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0)),
                        trailing: Image.asset("images/ic_chevron_right.png"),
                        onTap: () {
                          tenderConfigBloc.dispatch(TenderProductionPartsClickAction());
                        },
                      )),
                  Divider(thickness: 1.0, color: const Color(0xff979797)),
                  Material(
                      color: Colors.transparent,
                      child: ListTile(
                        title: Text(Strings.TENDER_EXTERNAL_PACKAGES, style: TextStyle(color: const Color(0xff202020), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0)),
                        trailing: Image.asset("images/ic_chevron_right.png"),
                        onTap: () {
                          tenderConfigBloc.dispatch(TenderExternalPackagesClickAction());
                        },
                      )),
                  Divider(thickness: 1.0, color: const Color(0xff979797))
                ],
              ),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    tenderConfigBloc = BlocProvider.of<TenderConfigBloc>(context);

    Widget getCupertinoScaffold(TenderConfigState state, TenderConfigBloc tenderConfigBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                Navigator.pop(context);
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<TenderConfigBloc, TenderConfigState>(
        listener: (context, state) {
          if (state is NavigateToTenderProductionPartsConfig) {
            globals.selectedKey = Strings.TENDER_PRODUCTION_PARTS_KEY;
            globals.selectedName = Strings.TENDER_PRODUCTION_PARTS;
            Navigator.of(context).pushNamed('/DisplayConfig');
            tenderConfigBloc.dispatch(ResetTenderConfigEvent());
          }

          if (state is NavigateToTenderExternalPackagesConfig) {
            globals.selectedKey = Strings.TENDER_EXTERNAL_PACKAGES_KEY;
            globals.selectedName = Strings.TENDER_EXTERNAL_PACKAGES;
            Navigator.of(context).pushNamed('/DisplayConfig');
            tenderConfigBloc.dispatch(ResetTenderConfigEvent());
          }
        },
        child: BlocBuilder<TenderConfigBloc, TenderConfigState>(
            bloc: tenderConfigBloc,
            builder: (
              BuildContext context,
              TenderConfigState state,
            ) {
              return getCupertinoScaffold(state, tenderConfigBloc);
            }));
  }
}
