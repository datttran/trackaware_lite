import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/tabs_config_bloc.dart';
import 'package:trackaware_lite/events/tabs_config_event.dart';
import 'package:trackaware_lite/states/tabs_config_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';

class TabsConfigPage extends StatefulWidget {
  @override
  State<TabsConfigPage> createState() {
    return _TabsConfigPageState();
  }
}

var tabsConfigBloc;

class _TabsConfigPageState extends State<TabsConfigPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tabsConfigBloc = BlocProvider.of<TabsConfigBloc>(context);

    Widget getScaffold() {
      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
              backgroundColor:
                  HexColor(ColorStrings.boxBackground).withAlpha(30),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: <Widget>[Image.asset("images/ic_back.png")],
                ),
              ),
              middle: Text(Strings.TABS)),
          child: Container(
              decoration: BoxDecoration(
                  color: HexColor(ColorStrings.boxBackground).withAlpha(30)),
              child: Stack(children: <Widget>[
                ListView(
                  children: <Widget>[
                    Material(
                        color: Colors.transparent,
                        child: ListTile(
                          title: Text(Strings.tenderTitle,
                              style: TextStyle(
                                  color: const Color(0xff202020),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "SourceSansPro",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0)),
                          trailing: Image.asset("images/ic_chevron_right.png"),
                          onTap: () {
                            tabsConfigBloc.dispatch(TenderClickAction());
                          },
                        )),
                    Divider(thickness: 1.0, color: const Color(0xff979797)),
                    Material(
                        color: Colors.transparent,
                        child: ListTile(
                          title: Text(Strings.pickUpTitle,
                              style: TextStyle(
                                  color: const Color(0xff202020),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "SourceSansPro",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0)),
                          trailing: Image.asset("images/ic_chevron_right.png"),
                          onTap: () {
                            tabsConfigBloc.dispatch(PickUpClickAction());
                          },
                        )),
                    Divider(thickness: 1.0, color: const Color(0xff979797)),
                    Material(
                        color: Colors.transparent,
                        child: ListTile(
                          title: Text(Strings.deliveryTitle,
                              style: TextStyle(
                                  color: const Color(0xff202020),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "SourceSansPro",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0)),
                          trailing: Image.asset("images/ic_chevron_right.png"),
                          onTap: () {
                            tabsConfigBloc.dispatch(DeliveryClickAction());
                          },
                        )),
                    Divider(thickness: 1.0, color: const Color(0xff979797))
                  ],
                ),
              ])));
    }

    Widget getCupertinoScaffold(TabsConfigState state, tabsConfigBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                Navigator.pop(context);
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<TabsConfigBloc, TabsConfigState>(
        listener: (context, state) {
          if (state is NavigateToTenderConfig) {
            Navigator.of(context).pushNamed('/TenderConfig');
            tabsConfigBloc.dispatch(ResetEvent());
          }

          if (state is NavigateToPickUpConfig) {
            Navigator.of(context).pushNamed('/PickUpConfig');
            tabsConfigBloc.dispatch(ResetEvent());
          }

          if (state is NavigateToDeliveryConfig) {
            Navigator.of(context).pushNamed('/DeliveryConfig');
            tabsConfigBloc.dispatch(ResetEvent());
          }
        },
        child: BlocBuilder<TabsConfigBloc, TabsConfigState>(
            bloc: tabsConfigBloc,
            builder: (
              BuildContext context,
              TabsConfigState state,
            ) {
              return getCupertinoScaffold(state, tabsConfigBloc);
            }));
  }
}
