import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trackaware_lite/blocs/profile_bloc.dart';
import 'package:trackaware_lite/events/profile_event.dart';
import 'package:trackaware_lite/states/profile_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

var profileBloc;
var _userName;
var _password;
var _token;
var name;
var email;
var phoneNo;
var _isLoading = false;
var _isImageAvailable = false;
File imageFile;

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() {
    _userName = null;
    imageFile = null;
    _isImageAvailable = false;
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    profileBloc = BlocProvider.of<ProfileBloc>(context);
    if (_userName == null || _userName.isEmpty) {
      profileBloc.dispatch(FetchUser());
    }

    Widget getProfileImage() {
      return Padding(
          padding: EdgeInsets.fromLTRB(0, 34, 0, 57),
          child: new Container(
            alignment: Alignment.topCenter,
            width: 120.0,
            height: 120.0,
            child: _isImageAvailable
                ? new CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: FileImage(imageFile),
                    radius: 60.0,
                  )
                : new CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage("images/ic_user.png"),
                    radius: 60.0,
                  ),
          ));
    }

    _showLogoutDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return CupertinoAlertDialog(
              title: new Text("Alert!"),
              content: new Text("Are you sure you want to logout ?"),
              actions: <Widget>[
                // usually buttons at th  e bottom of the dialog
                new CupertinoDialogAction(
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new CupertinoDialogAction(
                  child: new Text("Ok"),
                  onPressed: () {
                    profileBloc
                        .dispatch(LogoutClickAction(userName: _userName));
                  },
                )
              ],
            );
          });
    }

    Widget getScaffold() {
      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: HexColor(ColorStrings.boxBackground).withAlpha(30),
            leading: GestureDetector(
              onTap: () {
                profileBloc.dispatch(ResetEvent());
                Navigator.pop(context);
              },
              child: Row(
                children: <Widget>[Image.asset("images/ic_back.png")],
              ),
            ),
            middle: Text(Strings.trackaware_title),
            trailing: GestureDetector(
                onTap: () {
                  _showLogoutDialog();
                },
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    "assets/ic_logout.svg",
                    semanticsLabel: "logout icon",
                    width: 24,
                    height: 24,
                  ),
                )),
          ),
          child: Container(
              decoration: BoxDecoration(
                  color: HexColor(ColorStrings.boxBackground).withAlpha(30)),
              child: Stack(children: <Widget>[
                ListView(
                  children: <Widget>[
                    getProfileImage(),
                    Divider(thickness: 1.0, color: const Color(0xff979797)),
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                            child: SizedBox(
                              width: 24,
                              height: 30,
                              child: SvgPicture.asset(
                                "assets/ic_name.svg",
                                semanticsLabel: "name icon",
                                width: 24,
                                height: 30,
                              ),
                            )),
                        Material(
                            color: Colors.transparent,
                            child: Text(name == null ? " - " : name,
                                style: const TextStyle(
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "SourceSansPro",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0))),
                      ],
                    ),
                    Divider(thickness: 1.0, color: const Color(0xff979797)),
                    Row(children: <Widget>[
                      Padding(
                          padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                          child: SizedBox(
                            width: 24,
                            height: 30,
                            child: SvgPicture.asset(
                              "assets/ic_email.svg",
                              semanticsLabel: "name icon",
                              width: 24,
                              height: 30,
                            ),
                          )),
                      Material(
                          color: Colors.transparent,
                          child: Text(email == null ? " - " : email,
                              style: TextStyle(
                                  color: const Color(0xff202020),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "SourceSansPro",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0)))
                    ]),
                    Divider(thickness: 1.0, color: const Color(0xff979797)),
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                            child: SizedBox(
                              width: 24,
                              height: 30,
                              child: SvgPicture.asset(
                                "assets/ic_username.svg",
                                semanticsLabel: "name icon",
                                width: 24,
                                height: 30,
                              ),
                            )),
                        Material(
                            color: Colors.transparent,
                            child: Text(phoneNo == null ? " - " : phoneNo,
                                style: const TextStyle(
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "SourceSansPro",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0))),
                      ],
                    ),
                    Divider(thickness: 1.0, color: const Color(0xff979797))
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
                ) /* ,
                    Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 100, 16, 0),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: SvgPicture.asset(
                                "assets/ic_edit_user.svg",
                                semanticsLabel: "Edit use icon",
                              ),
                            ))), */
              ])));
    }

    Widget getCupertinoScaffold(ProfileState state, ProfileBloc profileBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                profileBloc.dispatch(ResetEvent());
                Navigator.pop(context);
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) async {
          if (state is FetchUserSuccess) {
            _isLoading = false;
            _userName = state.users[0].userName;
            _password = state.users[0].password;
            _token = state.users[0].token;
            profileBloc.dispatch(
                FetchUserDetailsResponse(userName: _userName, token: _token));
          }

          if (state is ProfileSuccess) {
            _isLoading = false;
            var userDetailsResponse = state.userDetailsResponse;
            name = userDetailsResponse.firstName;
            email = userDetailsResponse.email;
            phoneNo = userDetailsResponse.username;

            profileBloc.dispatch(
                FetchUserProfileImage(userName: _userName, token: _token));
          }

          if (state is ProfileLoading) {
            _isLoading = true;
          }

          if (state is ProfileFailure) {
            _isLoading = false;
            var error = state.error;

            if (error == "{'User Details Not Found! Check Extract Info.'}") {
              profileBloc.dispatch(
                  RefreshTokenEvent(userName: _userName, password: _password));
            } else {
              profileBloc.dispatch(
                  FetchUserProfileImage(userName: _userName, token: _token));
            }
            print(error);
          }

          if (state is RefreshTokenSuccess) {
            var loginResponse = state.loginResponse;
            _token = loginResponse.accessToken;

            profileBloc.dispatch(
                FetchUserProfileImage(userName: _userName, token: _token));
          }

          if (state is RefreshTokenFailure) {
            _isLoading = false;
            var error = state.error;
            print(error);
          }

          if (state is FetchUserProfileImageSuccess) {
            _isLoading = false;
            var response = state.response;
            Directory tempDir = await getTemporaryDirectory();
            String tempPath = tempDir.path;
            imageFile = new File('$tempPath/user_profile.png');
            imageFile.writeAsBytes(response.bodyBytes).then((value) {
              _isImageAvailable = true;
            });
          }

          if (state is FetchUserProfileImageFailure) {
            _isImageAvailable = false;
            _isLoading = false;
          }

          if (state is LogoutSuccess) {
            Navigator.of(context).pop();
            _isLoading = false;
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/LoginScreen', (Route<dynamic> route) => false);
          }

          if (state is LogoutFailure) {
            _isLoading = false;
            Navigator.of(context).pop();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: profileBloc,
            builder: (
              BuildContext context,
              ProfileState state,
            ) {
              return getCupertinoScaffold(state, profileBloc);
            }));
  }
}
