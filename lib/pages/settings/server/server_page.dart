import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/server_bloc.dart';
import 'package:trackaware_lite/constants.dart';
import 'package:trackaware_lite/events/server_event.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/models/server_db.dart';
import 'package:trackaware_lite/states/server_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';

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
        _serverBloc.dispatch(SaveEvent(serverConfigResponse: serverConfigResponse));
      }
    }

    Widget getSaveButton() {
      return Container(
          width: double.infinity,
          child: RaisedButton(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.all(16),
              child: Text(Strings.SAVE, style: TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0), textAlign: TextAlign.center),
              onPressed: () {
                _saveServerConfigToDb();
              },
              color: const Color(0xff2d92ff)));
    }

    Widget getScaffold() {
      return CupertinoPageScaffold(
          child: Form(
              key: _formKey,
              child: Container(
                  decoration: BoxDecoration(color: Color(0xff171721)),
                  child: Stack(children: <Widget>[
                    ListView(
                      children: <Widget>[
                        Material(
                          color: Color(0xff171721),
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(0), bottom: Radius.circular(15)),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                              child: Container(
                                height: verticalPixel * 12,
                                width: horizontalPixel * 97,
                                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                margin: EdgeInsets.symmetric(horizontal: horizontalPixel * 0),
                                decoration: BoxDecoration(
                                  color: Color(0xff2C2C34),
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(0), bottom: Radius.circular(15)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    /*GestureDetector(
                      child: _userProfileImage,
                      onTap: () {
                          Navigator.of(context).pushNamed('/Profile');
                      },
                    ),*/
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          width: horizontalPixel * 80,
                                        ),
                                        Container(
                                          width: horizontalPixel * 80,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('T R A C K A W A R E', style: TextStyle(color: Color(0xff689ffd), fontSize: verticalPixel * 3.4)),
                                            ],
                                          ),
                                        ),
                                        Text(' DELIVERY EXPERIENCE PLATFORM', style: TextStyle(color: Color(0xff93b1ee), fontSize: verticalPixel * 1.3)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: verticalPixel * 3,
                        ),
                        GestureDetector(
                            onTap: () {
                              userNameFocus.unfocus();
                              passwordFocus.unfocus();
                              FocusScope.of(context).requestFocus(baseUrlFocus);
                            },
                            child: Container(
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(color: Color(0xff2C2C34)),
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                    child: Column(
                                      children: <Widget>[
                                        Align(
                                          child: Material(
                                              color: Colors.transparent,
                                              child:
                                                  Text(Strings.BASE_URL, style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0))),
                                          alignment: Alignment.centerLeft,
                                        ),
                                        new Material(
                                            color: Colors.transparent,
                                            child: new TextFormField(
                                              keyboardType: TextInputType.url,
                                              style: TextStyle(color: Color(0xffffffff), fontSize: 16),
                                              autofocus: false,
                                              decoration: InputDecoration.collapsed(focusColor: HexColor(ColorStrings.emailPwdTextColor), hintText: Strings.ENTER_URL),
                                              validator: (value) {
                                                RegExp regExp = new RegExp(r'^((http?|ftp|smtp):\/\/)?[a-z0-9]+\.[a-z0-9]+\.[a-z0-9]');
                                                return regExp.hasMatch(value) ? null : Strings.URL_VALIDATION;
                                              },
                                              controller: baseUrlController,
                                              textInputAction: TextInputAction.next,
                                              focusNode: baseUrlFocus,
                                              onFieldSubmitted: (v) {
                                                baseUrlFocus.unfocus();
                                                FocusScope.of(context).requestFocus(userNameFocus);
                                              },
                                            ))
                                      ],
                                    )))),
                        Divider(thickness: 1.0, height: 1.0, color: const Color(0xffffffff).withOpacity(0)),
                        GestureDetector(
                            onTap: () {
                              baseUrlFocus.unfocus();
                              passwordFocus.unfocus();
                              FocusScope.of(context).requestFocus(userNameFocus);
                            },
                            child: Container(
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(color: Color(0xff2C2C34)),
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                    child: Column(
                                      children: <Widget>[
                                        Align(
                                          child: Material(
                                              color: Colors.transparent,
                                              child: Text(Strings.USERNAME,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0))),
                                          alignment: Alignment.centerLeft,
                                        ),
                                        new Material(
                                            color: Colors.transparent,
                                            child: new TextFormField(
                                              keyboardType: TextInputType.number,
                                              style: TextStyle(color: Color(0xffffffff), fontSize: 16),
                                              autofocus: false,
                                              decoration: InputDecoration.collapsed(focusColor: HexColor(ColorStrings.emailPwdTextColor), hintText: Strings.ENTER_USERNAME),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return Strings.userNameValidationMessage;
                                                }
                                                return null;
                                              },
                                              controller: userNameController,
                                              textInputAction: TextInputAction.next,
                                              focusNode: userNameFocus,
                                              onFieldSubmitted: (v) {
                                                userNameFocus.unfocus();
                                                FocusScope.of(context).requestFocus(passwordFocus);
                                              },
                                            ))
                                      ],
                                    )))),
                        Divider(thickness: 1.0, height: 1.0, color: const Color(0xffffffff).withOpacity(0)),
                        GestureDetector(
                            onTap: () {
                              baseUrlFocus.unfocus();
                              userNameFocus.unfocus();
                              FocusScope.of(context).requestFocus(passwordFocus);
                            },
                            child: Container(
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(color: Color(0xff2C2C34)),
                                child: Padding(
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        child: Material(
                                            color: Colors.transparent,
                                            child: Text(Strings.PASSWORD, style: TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0))),
                                        alignment: Alignment.centerLeft,
                                      ),
                                      new Material(
                                          color: Colors.transparent,
                                          child: new TextFormField(
                                            keyboardType: TextInputType.text,
                                            style: TextStyle(color: Color(0xffffffff), fontSize: 16),
                                            autofocus: false,
                                            decoration: InputDecoration.collapsed(focusColor: HexColor(ColorStrings.emailPwdTextColor), hintText: Strings.ENTER_PASSWORD),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return Strings.passwordValidationMessage;
                                              }
                                              return null;
                                            },
                                            controller: passwordController,
                                            textInputAction: TextInputAction.next,
                                            focusNode: passwordFocus,
                                            onFieldSubmitted: (v) {
                                              passwordFocus.unfocus();
                                            },
                                          ))
                                    ],
                                  ),
                                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                ))),
                        Divider(thickness: 1.0, height: 1.0, color: const Color(0xffffffff).withOpacity(0)),
                      ],
                    ),
                    Align(child: getSaveButton(), alignment: AlignmentDirectional.bottomCenter),
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
              serverConfigValue = serverConfigResponse[serverConfigResponse.length - 1];
              baseUrlController.text = serverConfigValue.baseUrl;
              baseUrlController.selection = TextSelection.fromPosition(TextPosition(offset: baseUrlController.text.length));

              userNameController.text = serverConfigValue.userName;
              userNameController.selection = TextSelection.fromPosition(TextPosition(offset: userNameController.text.length));

              passwordController.text = serverConfigValue.password;
              passwordController.selection = TextSelection.fromPosition(TextPosition(offset: passwordController.text.length));
            }
          }

          if (state is ServerDetailsSaveSuccess) {
            var serverConfigResponse = state.serverConfigResponse;
            if (serverConfigResponse != null && serverConfigResponse.isNotEmpty) {
              serverConfigValue = serverConfigResponse[serverConfigResponse.length - 1];
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
