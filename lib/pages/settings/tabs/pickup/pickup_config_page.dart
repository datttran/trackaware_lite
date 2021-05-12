import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/pickup_config_bloc.dart';
import 'package:trackaware_lite/events/pickup_config_event.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/states/pickup_config_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';

class PickUpConfigPage extends StatefulWidget {
  @override
  State<PickUpConfigPage> createState() {
    return _PickUpConfigPageState();
  }
}

var pickUpConfigBloc;

class _PickUpConfigPageState extends State<PickUpConfigPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pickUpConfigBloc = BlocProvider.of<PickUpConfigBloc>(context);

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
              middle: Text(Strings.pickUpTitle)),
          child: Container(
              decoration: BoxDecoration(color: HexColor(ColorStrings.boxBackground).withAlpha(30)),
              child: Stack(children: <Widget>[
                ListView(
                  children: <Widget>[
                    Material(
                        color: Colors.transparent,
                        child: ListTile(
                          title: Text(Strings.PICKUP_PRODUCTION_PARTS, style: TextStyle(color: const Color(0xff202020), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0)),
                          trailing: Image.asset("images/ic_chevron_right.png"),
                          onTap: () {
                            pickUpConfigBloc.dispatch(PickUpProductionPartsClickAction());
                          },
                        )),
                    Divider(thickness: 1.0, color: const Color(0xff979797)),
                    Material(
                        color: Colors.transparent,
                        child: ListTile(
                          title: Text(Strings.PICKUP_EXTERNAL_PACKAGES, style: TextStyle(color: const Color(0xff202020), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0)),
                          trailing: Image.asset("images/ic_chevron_right.png"),
                          onTap: () {
                            pickUpConfigBloc.dispatch(PickUpExternalPackagesClickAction());
                          },
                        )),
                    Divider(thickness: 1.0, color: const Color(0xff979797))
                  ],
                ),
              ])));
    }

    Widget getCupertinoScaffold(PickUpConfigState state, PickUpConfigBloc pickUpConfigBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                Navigator.pop(context);
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<PickUpConfigBloc, PickUpConfigState>(
        listener: (context, state) {
          if (state is NavigateToPickUpProductionPartsConfig) {
            globals.selectedKey = Strings.PICKUP_PRODUCTION_PARTS_KEY;
            globals.selectedName = Strings.PICKUP_PRODUCTION_PARTS;
            Navigator.of(context).pushNamed('/DisplayConfig');
            pickUpConfigBloc.dipatch(ResetPickUpConfigEvent());
          }

          if (state is NavigateToPickUpExternalPackagesConfig) {
            globals.selectedKey = Strings.PICKUP_EXTERNAL_PACKAGES_KEY;
            globals.selectedName = Strings.PICKUP_PRODUCTION_PARTS;
            Navigator.of(context).pushNamed('/DisplayConfig');
            pickUpConfigBloc.dipatch(ResetPickUpConfigEvent());
          }
        },
        child: BlocBuilder<PickUpConfigBloc, PickUpConfigState>(
            bloc: pickUpConfigBloc,
            builder: (
              BuildContext context,
              PickUpConfigState state,
            ) {
              return getCupertinoScaffold(state, pickUpConfigBloc);
            }));
  }
}
