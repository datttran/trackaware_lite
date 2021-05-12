import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/delivery_config_bloc.dart';
import 'package:trackaware_lite/events/delivery_config_event.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/states/delivery_config_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';

class DeliveryConfigPage extends StatefulWidget {
  @override
  State<DeliveryConfigPage> createState() {
    return _DeliveryConfigPageState();
  }
}

var deliveryConfigBloc;

class _DeliveryConfigPageState extends State<DeliveryConfigPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deliveryConfigBloc = BlocProvider.of<DeliveryConfigBloc>(context);

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
              middle: Text(Strings.deliveryTitle)),
          child: Container(
              decoration: BoxDecoration(color: HexColor(ColorStrings.boxBackground).withAlpha(30)),
              child: Stack(children: <Widget>[
                ListView(
                  children: <Widget>[
                    Material(
                        color: Colors.transparent,
                        child: ListTile(
                          title: Text(Strings.departTitle, style: TextStyle(color: const Color(0xff202020), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0)),
                          trailing: Image.asset("images/ic_chevron_right.png"),
                          onTap: () {
                            deliveryConfigBloc.dispatch(DepartClickAction());
                          },
                        )),
                    Divider(thickness: 1.0, color: const Color(0xff979797)),
                    Material(
                        color: Colors.transparent,
                        child: ListTile(
                          title: Text(Strings.arriveTitle, style: TextStyle(color: const Color(0xff202020), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0)),
                          trailing: Image.asset("images/ic_chevron_right.png"),
                          onTap: () {
                            deliveryConfigBloc.dispatch(ArriveClickAction());
                          },
                        )),
                    Divider(thickness: 1.0, color: const Color(0xff979797))
                  ],
                ),
              ])));
    }

    Widget getCupertinoScaffold(DeliveryConfigState state, DeliveryConfigBloc pickUpConfigBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                Navigator.pop(context);
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<DeliveryConfigBloc, DeliveryConfigState>(
        listener: (context, state) {
          if (state is NavigateToDepartConfig) {
            globals.selectedKey = Strings.DEPART_KEY;
            globals.selectedName = Strings.departTitle;
            Navigator.of(context).pushNamed('/DisplayConfig');
            deliveryConfigBloc.dispatch(ResetDeliveryConfigEvent());
          }

          if (state is NavigateToArriveConfig) {
            globals.selectedKey = Strings.ARRIVE_KEY;
            globals.selectedName = Strings.arriveTitle;
            Navigator.of(context).pushNamed('/DisplayConfig');
            deliveryConfigBloc.dispatch(ResetDeliveryConfigEvent());
          }
        },
        child: BlocBuilder<DeliveryConfigBloc, DeliveryConfigState>(
            bloc: deliveryConfigBloc,
            builder: (
              BuildContext context,
              DeliveryConfigState state,
            ) {
              return getCupertinoScaffold(state, deliveryConfigBloc);
            }));
  }
}
