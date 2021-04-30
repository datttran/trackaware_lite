import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/location_bloc.dart';
import 'package:trackaware_lite/events/location_event.dart';
import 'package:trackaware_lite/models/location_db.dart';
import 'package:trackaware_lite/states/location_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';

class LocationPage extends StatefulWidget {
  @override
  State<LocationPage> createState() {
    return _LocationPageState();
  }
}

var locationBloc;
final gpsPollIntervalController = TextEditingController();
final gpsPostIntervalController = TextEditingController();
final gpsUrlController = TextEditingController();

final FocusNode gpsPollIntervalFocus = FocusNode();
final FocusNode gpsPostIntervalFocus = FocusNode();
final FocusNode gpsUrFocus = FocusNode();

class _LocationPageState extends State<LocationPage> {
  bool _isLoading = false;
  bool _areValuesLoaded = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    locationBloc = BlocProvider.of<LocationBloc>(context);
    if (!_areValuesLoaded) locationBloc.dispatch(FetchLocationValues());

    void _saveLocationToDb() {
      if (_formKey.currentState.validate()) {
        Location location = new Location();
        location.gpsPollInterval = gpsPollIntervalController.text.isNotEmpty
            ? int.parse(gpsPollIntervalController.text)
            : 0;
        location.gpsPostInterval = gpsPostIntervalController.text.isNotEmpty
            ? int.parse(gpsPostIntervalController.text)
            : 0;
        location.gpsUrl = gpsUrlController.text;
        locationBloc.dispatch(SaveButtonClick(location));
      }
    }

    Widget getSaveButton() {
      return Padding(
          padding: EdgeInsets.fromLTRB(16, 100, 16, 26),
          child: Container(
              width: double.infinity,
              child: RaisedButton(
                  elevation: 8.0,
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.all(16),
                  child: Text(Strings.SAVE,
                      style: TextStyle(
                          color: HexColor(ColorStrings.SEND_BUTTON_TEXT_COLOR),
                          fontWeight: FontWeight.w400,
                          fontFamily: "SourceSansPro",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.center),
                  onPressed: () {
                    _saveLocationToDb();
                  },
                  color: const Color(0xff424e53))));
    }

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
              middle: Text(Strings.LOCATION)),
          child: Form(
              key: _formKey,
              child: Container(
                  decoration: BoxDecoration(
                      color:
                          HexColor(ColorStrings.boxBackground).withAlpha(30)),
                  child: Stack(children: <Widget>[
                    ListView(
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              gpsPostIntervalFocus.unfocus();
                              gpsUrFocus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(gpsPollIntervalFocus);
                            },
                            child: Container(
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(color: Colors.white),
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                    child: Column(
                                      children: <Widget>[
                                        Align(
                                          child: Material(
                                              color: Colors.transparent,
                                              child: Text(
                                                  Strings.GPS_POLL_INTERVAL,
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xff202020),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          "SourceSansPro",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0))),
                                          alignment: Alignment.centerLeft,
                                        ),
                                        new Material(
                                            color: Colors.transparent,
                                            child: new TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              style: TextStyle(
                                                  color: HexColor(
                                                      ColorStrings.VALUES),
                                                  fontSize: 16),
                                              autofocus: true,
                                              decoration: InputDecoration.collapsed(
                                                  focusColor: HexColor(
                                                      ColorStrings
                                                          .emailPwdTextColor),
                                                  hintText: Strings
                                                      .ENTER_GPS_POLL_INTERVAL),
                                              validator: (value) {
                                                if (value.length >= 4) {
                                                  return Strings
                                                      .NUMBER_LENGTH_VALIDATION;
                                                } else {
                                                  return null;
                                                }
                                              },
                                              controller:
                                                  gpsPollIntervalController,
                                              textInputAction:
                                                  TextInputAction.next,
                                              focusNode: gpsPollIntervalFocus,
                                              onFieldSubmitted: (v) {
                                                gpsPollIntervalFocus.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        gpsPostIntervalFocus);
                                              },
                                            ))
                                      ],
                                    )))),
                        Divider(
                            height: 1.0,
                            thickness: 1.0,
                            color: const Color(0xff979797)),
                        GestureDetector(
                            onTap: () {
                              gpsPollIntervalFocus.unfocus();
                              gpsUrFocus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(gpsPostIntervalFocus);
                            },
                            child: Container(
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(color: Colors.white),
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                    child: Column(
                                      children: <Widget>[
                                        Align(
                                          child: Material(
                                              color: Colors.transparent,
                                              child: Text(
                                                  Strings.GPS_POST_INTERVAL,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xff202020),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          "SourceSansPro",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0))),
                                          alignment: Alignment.centerLeft,
                                        ),
                                        new Material(
                                            color: Colors.transparent,
                                            child: new TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              style: TextStyle(
                                                  color: HexColor(
                                                      ColorStrings.VALUES),
                                                  fontSize: 16),
                                              autofocus: true,
                                              decoration: InputDecoration.collapsed(
                                                  focusColor: HexColor(
                                                      ColorStrings
                                                          .emailPwdTextColor),
                                                  hintText: Strings
                                                      .ENTER_GPS_POST_INTERVAL),
                                              validator: (value) {
                                                if (value.length >= 4) {
                                                  return Strings
                                                      .NUMBER_LENGTH_VALIDATION;
                                                } else {
                                                  return null;
                                                }
                                              },
                                              controller:
                                                  gpsPostIntervalController,
                                              textInputAction:
                                                  TextInputAction.next,
                                              focusNode: gpsPostIntervalFocus,
                                              onFieldSubmitted: (v) {
                                                gpsPostIntervalFocus.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(gpsUrFocus);
                                              },
                                            ))
                                      ],
                                    )))),
                        Divider(
                            height: 1.0,
                            thickness: 1.0,
                            color: const Color(0xff979797)),
                        GestureDetector(
                            onTap: () {
                              gpsPollIntervalFocus.unfocus();
                              gpsPostIntervalFocus.unfocus();
                              FocusScope.of(context).requestFocus(gpsUrFocus);
                            },
                            child: Container(
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(color: Colors.white),
                                child: Padding(
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        child: Material(
                                            color: Colors.transparent,
                                            child: Text(Strings.GPS_URL,
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff202020),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "SourceSansPro",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 16.0))),
                                        alignment: Alignment.centerLeft,
                                      ),
                                      new Material(
                                          color: Colors.transparent,
                                          child: new TextFormField(
                                            keyboardType: TextInputType.url,
                                            style: TextStyle(
                                                color: HexColor(
                                                    ColorStrings.VALUES),
                                                fontSize: 16),
                                            autofocus: true,
                                            decoration:
                                                InputDecoration.collapsed(
                                                    focusColor: HexColor(
                                                        ColorStrings
                                                            .emailPwdTextColor),
                                                    hintText:
                                                        Strings.ENTER_GPS_URL),
                                            validator: (value) {
                                              RegExp regExp = new RegExp(
                                                  r'^((http?|ftp|smtp):\/\/)?[a-z0-9]+\.[a-z0-9]+\.[a-z0-9]+\.[a-z0-9]+(\/[a-zA-Z0-9#]+\/?)*$');
                                              return regExp.hasMatch(value)
                                                  ? null
                                                  : Strings.URL_VALIDATION;
                                            },
                                            controller: gpsUrlController,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: gpsUrFocus,
                                            onFieldSubmitted: (v) {
                                              gpsUrFocus.unfocus();
                                            },
                                          ))
                                    ],
                                  ),
                                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                ))),
                        Divider(
                            height: 1.0,
                            thickness: 1.0,
                            color: const Color(0xff979797)),
                      ],
                    ),
                    Align(
                        child: getSaveButton(),
                        alignment: AlignmentDirectional.bottomCenter),
                    Align(
                      child: _isLoading
                          ? CupertinoActivityIndicator(
                              animating: true,
                              radius: 20.0,
                            )
                          : Text(""),
                      alignment: AlignmentDirectional.center,
                    ),
                  ]))));
    }

    Widget getCupertinoScaffold(
        LocationState state, LocationBloc locationBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                Navigator.pop(context);
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationSaveSuccess) {
            Navigator.pop(context);
          }

          if (state is FetchLocationSuccess) {
            var locationList = state.locationList;
            if (locationList.isNotEmpty) {
              _areValuesLoaded = true;

              var location = locationList[locationList.length - 1];
              gpsPostIntervalController.text =
                  location.gpsPostInterval.toString();
              gpsPostIntervalController.selection = TextSelection.fromPosition(
                  TextPosition(offset: gpsPostIntervalController.text.length));

              gpsPollIntervalController.text =
                  location.gpsPollInterval.toString();
              gpsPollIntervalController.selection = TextSelection.fromPosition(
                  TextPosition(offset: gpsPollIntervalController.text.length));

              gpsUrlController.text = location.gpsUrl;
              gpsUrlController.selection = TextSelection.fromPosition(
                  TextPosition(offset: gpsUrlController.text.length));
            }
          }
        },
        child: BlocBuilder<LocationBloc, LocationState>(
            bloc: locationBloc,
            builder: (
              BuildContext context,
              LocationState state,
            ) {
              return getCupertinoScaffold(state, locationBloc);
            }));
  }
}
