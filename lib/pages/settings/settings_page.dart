import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';
import 'package:trackaware_lite/blocs/settings_bloc.dart';
import 'package:trackaware_lite/constants.dart';
import 'package:trackaware_lite/events/settings_event.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/models/settings_db.dart';
import 'package:trackaware_lite/states/settings_state.dart';
import 'package:trackaware_lite/utils/strings.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() {
    return _SettingsPageState();
  }
}

var settingsBloc;
var _driverMode = true;
var _useToolNumber = false;
var _isPickUpOnTender = false;
var _isLoading = false;
var _userName = "";

class _SettingsPageState extends State<SettingsPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    settingsBloc = BlocProvider.of<SettingsBloc>(context);
    if (_userName.isEmpty) {
      settingsBloc.dispatch(FetchUser());
    }
    settingsBloc.dispatch(FetchAllDisciplineConfigValues());

    Widget getScaffold() {
      return CupertinoPageScaffold(
          child: Material(
        child: Container(
            decoration: BoxDecoration(
              color: Color(0xff171721),
            ),
            child: Stack(children: <Widget>[
              ListView(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(0), bottom: Radius.circular(15)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                      child: Container(
                        height: verticalPixel * 12,
                        width: horizontalPixel * 97,
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        margin: EdgeInsets.symmetric(horizontal: horizontalPixel * 3.5),
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
                  SizedBox(
                    height: verticalPixel * 5,
                  ),

                  Material(
                      color: Color(0xff2C2C34),
                      child: ListTile(
                        title: Text(Strings.LOCATION, style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0)),
                        trailing: Image.asset("images/ic_chevron_right.png"),
                        onTap: () {
                          settingsBloc.dispatch(LocationClick());
                        },
                      )),

                  //SizedBox(height: verticalPixel*1,),
                  Material(
                      color: Color(0xff2C2C34),
                      child: ListTile(
                        title: Text(Strings.SERVER, style: TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0)),
                        trailing: Image.asset("images/ic_chevron_right.png"),
                        onTap: () {
                          settingsBloc.dispatch(ServerClick());
                        },
                      )),

                  //SizedBox(height: verticalPixel*1,),
                  /*Material(
                          color: Color(0xff2C2C34),
                          child: ListTile(
                            title: Text(Strings.DRIVER_MODE, style: TextStyle(color: Colors.white),),
                            trailing: CupertinoSwitch(
                              activeColor: Color(0xff5b5b5b),
                              value: _driverMode,
                              onChanged: (bool value) {
                                //_updateDriverMode(value);
                              },
                            ),
                            onTap: () {
                              //_updateDriverMode(!_driverMode);
                            },
                          )),*/
                  //SizedBox(height: verticalPixel*1,),
                  Material(
                      color: Color(0xffec2c45),
                      child: ListTile(
                        title: Text(
                          'Sign Out',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          _isLoading = false;
                          Navigator.of(context).pushNamedAndRemoveUntil('/LoginScreen', (Route<dynamic> route) => false);

                          //_updateDriverMode(!_driverMode);
                        },
                      )),

                  //TODO - to be commented out when the server feature is needed
                  /* Material(
                          color: Colors.transparent,
                          child: ListTile(
                            title: Text(Strings.SERVER,
                                style: TextStyle(
                                    color: const Color(0xff202020),
                                    fontWeight: FontWeight.w400,

                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0)),
                            trailing: Image.asset("images/ic_chevron_right.png"),
                            onTap: () {
                              settingsBloc.dispatch(ServerClick());
                            },
                          )),
                      Divider(thickness: 1.0, color: const Color(0xff979797)), */

                  SizedBox(
                    height: verticalPixel * 40,
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: horizontalPixel * 20),
                    child: RaisedButton(
                      color: Color(0xff2C2C34),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                child: _isLoading
                    ? CupertinoActivityIndicator(
                        animating: true,
                        radius: 20.0,
                      )
                    : Text(""),
                alignment: AlignmentDirectional.center,
              )
            ])),
      ));
    }

    Widget getCupertinoScaffold(SettingsState state, SettingsBloc settingsBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                Navigator.pop(context);
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoading) {
            _isLoading = true;
          }

          if (state is DisplayTabs) {
            Navigator.of(context).pushNamed('/TabsConfig');
            settingsBloc.dispatch(ResetSettingEvent());
          }

          if (state is DisplayLocation) {
            Navigator.of(context).pushNamed('/Location');
            settingsBloc.dispatch(ResetSettingEvent());
          }

          if (state is ServerClickSuccess) {
            Navigator.of(context).pushNamed('/Server');
            settingsBloc.dispatch(ResetSettingEvent());
          }

          if (state is TenderModeSuccess) {
            _useToolNumber = !_useToolNumber;

            globals.useToolNumber = _useToolNumber;
            globals.selectedTabIndex = 0;
            settingsBloc.dispatch(ResetSettingEvent());
            /* Navigator.of(context).pushNamedAndRemoveUntil(
                '/LandingScreen', (Route<dynamic> route) => false); */
          }

          if (state is PickUpOnTenderSuccess) {
            _isPickUpOnTender = !_isPickUpOnTender;

            globals.isPickUpOnTender = _isPickUpOnTender;
            globals.selectedTabIndex = 0;
            settingsBloc.dispatch(ResetSettingEvent());
          }

          if (state is DriverModeSuccess) {
            _driverMode = !_driverMode;

            globals.isDriverMode = _driverMode;
            globals.selectedTabIndex = 0;
            Navigator.of(context).pushNamedAndRemoveUntil('/LandingScreen', (Route<dynamic> route) => false);
          }

          if (state is FetchUserSuccess) {
            var users = state.users;

            _userName = users[0].userName;
            settingsBloc.dispatch(FetchSettings(userName: _userName));
          }

          if (state is FetchSettingsSuccess) {
            var settings = state.settings;

            var index = settings.length - 1;
            _useToolNumber = settings[index].useToolNumber == 1;
            _driverMode = settings[index].driverMode == 1;
            _isPickUpOnTender = settings[index].pickUpOnTender == 1;

            if (settings.isNotEmpty) {
              globals.isDriverMode = _driverMode;
              globals.useToolNumber = _useToolNumber;
              globals.isPickUpOnTender = _isPickUpOnTender;
            }
          }

          if (state is LocationResponseFetchSuccess) {
            Toast.show("Done", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            _isLoading = false;
          }

          if (state is PriorityResponseFetchSuccess) {
            Toast.show("Done", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            _isLoading = false;
          }

          if (state is LocationResponseFetchFailure) {
            Toast.show("Sync failed", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            _isLoading = false;
          }

          if (state is PriorityResponseFetchFailure) {
            Toast.show("Sync failed", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            _isLoading = false;
          }
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
            bloc: settingsBloc,
            builder: (
              BuildContext context,
              SettingsState state,
            ) {
              return getCupertinoScaffold(state, settingsBloc);
            }));
  }

  void _updateUseToolNumber(bool value) {
    var settingsResponse = SettingsResponse();
    settingsResponse.useToolNumber = value ? 1 : 0;
    settingsResponse.driverMode = _driverMode ? 1 : 0;
    settingsResponse.userName = _userName;

    settingsBloc.dispatch(TenderModeClick(settingsResponse: settingsResponse));
  }

  void _updateDriverMode(bool value) {
    var settingsResponse = SettingsResponse();
    settingsResponse.useToolNumber = _useToolNumber ? 1 : 0;
    settingsResponse.driverMode = value ? 1 : 0;
    settingsResponse.userName = _userName;

    settingsBloc.dispatch(DriverModeClick(settingsResponse: settingsResponse));
  }

  void _updatePickUpOnTender(bool value) {
    var settingsResponse = SettingsResponse();
    settingsResponse.useToolNumber = _useToolNumber ? 1 : 0;
    settingsResponse.driverMode = _driverMode ? 1 : 0;
    settingsResponse.pickUpOnTender = value ? 1 : 0;
    settingsResponse.userName = _userName;

    settingsBloc.dispatch(PickUpOnTenderClick(settingsResponse: settingsResponse));
  }
}
