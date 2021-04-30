import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/server_bloc.dart';
import 'package:trackaware_lite/events/server_event.dart';
import 'package:trackaware_lite/models/server_db.dart';
import 'package:trackaware_lite/states/server_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';
import 'package:trackaware_lite/globals.dart' as globals;

class ServerPage extends StatefulWidget {
  @override
  State<ServerPage> createState() {
    return _ServerPageState();
  }
}

var _serverBloc;
final baseUrlController = TextEditingController();
final userNameController = TextEditingController();
final passwordController = TextEditingController();

final FocusNode baseUrlFocus = FocusNode();
final FocusNode userNameFocus = FocusNode();
final FocusNode passwordFocus = FocusNode();

class _ServerPageState extends State<ServerPage> {
  bool _isLoading = false;
  bool _areValuesLoaded = false;
  final _formKey = GlobalKey<FormState>();
  ServerConfigResponse serverConfigValue;

  @override
  void dispose() {
    _isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _serverBloc = BlocProvider.of<ServerBloc>(context);
    if (!_areValuesLoaded) _serverBloc.dispatch(FetchServerConfigValues());

    void _saveServerConfigToDb() {
      if (_formKey.currentState.validate()) {
        var serverConfigResponse = ServerConfigResponse();
        serverConfigResponse.baseUrl = baseUrlController.text;
        serverConfigResponse.userName = userNameController.text;
        serverConfigResponse.password = passwordController.text;
        _serverBloc
            .dispatch(SaveEvent(serverConfigResponse: serverConfigResponse));
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
                    _saveServerConfigToDb();
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
              middle: Text(Strings.SERVER)),
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
                              userNameFocus.unfocus();
                              passwordFocus.unfocus();
                              FocusScope.of(context).requestFocus(baseUrlFocus);
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
                                              child: Text(Strings.BASE_URL,
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
                                                          Strings.ENTER_URL),
                                              validator: (value) {
                                                RegExp regExp = new RegExp(
                                                    r'^((http?|ftp|smtp):\/\/)?[a-z0-9]+\.[a-z0-9]+\.[a-z0-9]');
                                                return regExp.hasMatch(value)
                                                    ? null
                                                    : Strings.URL_VALIDATION;
                                              },
                                              controller: baseUrlController,
                                              textInputAction:
                                                  TextInputAction.next,
                                              focusNode: baseUrlFocus,
                                              onFieldSubmitted: (v) {
                                                baseUrlFocus.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        userNameFocus);
                                              },
                                            ))
                                      ],
                                    )))),
                        Divider(
                            thickness: 1.0,
                            height: 1.0,
                            color: const Color(0xff979797)),
                        GestureDetector(
                            onTap: () {
                              baseUrlFocus.unfocus();
                              passwordFocus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(userNameFocus);
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
                                              child: Text(Strings.USERNAME,
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
                                              decoration: InputDecoration
                                                  .collapsed(
                                                      focusColor: HexColor(
                                                          ColorStrings
                                                              .emailPwdTextColor),
                                                      hintText: Strings
                                                          .ENTER_USERNAME),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return Strings
                                                      .userNameValidationMessage;
                                                }
                                                return null;
                                              },
                                              controller: userNameController,
                                              textInputAction:
                                                  TextInputAction.next,
                                              focusNode: userNameFocus,
                                              onFieldSubmitted: (v) {
                                                userNameFocus.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        passwordFocus);
                                              },
                                            ))
                                      ],
                                    )))),
                        Divider(
                            thickness: 1.0,
                            height: 1.0,
                            color: const Color(0xff979797)),
                        GestureDetector(
                            onTap: () {
                              baseUrlFocus.unfocus();
                              userNameFocus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(passwordFocus);
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
                                            child: Text(Strings.PASSWORD,
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
                                            keyboardType: TextInputType.text,
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
                                                        Strings.ENTER_PASSWORD),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return Strings
                                                    .passwordValidationMessage;
                                              }
                                              return null;
                                            },
                                            controller: passwordController,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: passwordFocus,
                                            onFieldSubmitted: (v) {
                                              passwordFocus.unfocus();
                                            },
                                          ))
                                    ],
                                  ),
                                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                ))),
                        Divider(
                            thickness: 1.0,
                            height: 1.0,
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

    Widget getCupertinoScaffold(ServerState state, ServerBloc serverBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                Navigator.pop(context);
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<ServerBloc, ServerState>(
        listener: (context, state) {
          if (state is FetchServerConfigValuesSuccess) {
            var serverConfigResponse = state.serverConfigResponse;
            if (serverConfigResponse.isNotEmpty) {
              serverConfigValue =
                  serverConfigResponse[serverConfigResponse.length - 1];
              baseUrlController.text = serverConfigValue.baseUrl;
              baseUrlController.selection = TextSelection.fromPosition(
                  TextPosition(offset: baseUrlController.text.length));

              userNameController.text = serverConfigValue.userName;
              userNameController.selection = TextSelection.fromPosition(
                  TextPosition(offset: userNameController.text.length));

              passwordController.text = serverConfigValue.password;
              passwordController.selection = TextSelection.fromPosition(
                  TextPosition(offset: passwordController.text.length));
            }
          }

          if (state is ServerDetailsSaveSuccess) {
            var serverConfigResponse = state.serverConfigResponse;
            if (serverConfigResponse != null &&
                serverConfigResponse.isNotEmpty) {
              serverConfigValue =
                  serverConfigResponse[serverConfigResponse.length - 1];
              globals.baseUrl = serverConfigValue.baseUrl;
              globals.serverUserName = serverConfigValue.userName;
              globals.serverPassword = serverConfigValue.password;
            }
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<ServerBloc, ServerState>(
            bloc: _serverBloc,
            builder: (
              BuildContext context,
              ServerState state,
            ) {
              return getCupertinoScaffold(state, _serverBloc);
            }));
  }
}
