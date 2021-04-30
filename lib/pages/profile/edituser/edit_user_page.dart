import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trackaware_lite/blocs/profile_bloc.dart';
import 'package:trackaware_lite/events/profile_event.dart';
import 'package:trackaware_lite/events/sign_up_event.dart';
import 'package:trackaware_lite/pages/signup/sign_up_page.dart';
import 'package:trackaware_lite/states/profile_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';

class EditUserPage extends StatefulWidget {
  @override
  State<EditUserPage> createState() {
    return _EditUserPageState();
  }
}

var profileBloc;
var _userName;
var _token;
var name;
var email;
var phoneNo;
File imageFile;
var base64String = new StringBuffer();

//todo - set values from UserDetailsResponse
class _EditUserPageState extends State<EditUserPage> {
  final firstNameController = TextEditingController();
  final emailController = TextEditingController();
  final lastNameController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  var fileImage;
  var image;
  var file;
  bool _isLoading = false;
  ImagePicker picker = ImagePicker();

  final _createUserFormKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _userNameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  PickedFile _imageFile;

  @override
  void dispose() {
    _isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    profileBloc = BlocProvider.of<ProfileBloc>(context);
    if (_userName == null || _userName.isEmpty) {
      profileBloc.dispatch(FetchUser());
    }

    Widget _previewImage() {
      if (_imageFile != null) {
        return Image.file(File(_imageFile.path));
      } else {
        return new CircleAvatar(
          backgroundImage: AssetImage('images/ic_user.png'),
          radius: 75.0,
        );
      }
    }

    showDemoActionSheet<T>({BuildContext context, Widget child}) {
      showCupertinoModalPopup<T>(
        context: context,
        builder: (BuildContext context) => child,
      );
    }

    final profileImage = GestureDetector(
        child: new Container(
          alignment: Alignment.topCenter,
          child: _previewImage(),
        ),
        onTap: () {
          showDemoActionSheet<String>(
              context: context,
              child: CupertinoActionSheet(
                  title: const Text('Select source'),
                  message:
                      const Text('Please select from the below two options'),
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                      child: const Text('Camera'),
                      onPressed: () {
                        profileBloc.dispatch(ImageButtonClick(
                            imageSource: ImageSource.camera,
                            imagePicker: picker));
                      },
                    ),
                    CupertinoActionSheetAction(
                      child: const Text('Gallery'),
                      onPressed: () {
                        profileBloc.dispatch(ImageButtonClick(
                            imageSource: ImageSource.gallery,
                            imagePicker: picker));
                      },
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    child: const Text('Cancel'),
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    },
                  )));
        });

    final emailWidget = Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            border: Border.all(
              color: HexColor(ColorStrings.BORDER),
            ),
            color: Colors.white),
        child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: <Widget>[
                Align(
                  child: Material(
                      color: Colors.transparent,
                      child: Text(Strings.EMAIL,
                          style: TextStyle(
                              color: const Color(0xff202020),
                              fontWeight: FontWeight.w400,
                              fontFamily: "SourceSansPro",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0))),
                  alignment: Alignment.centerLeft,
                ),
                new Material(
                    color: Colors.transparent,
                    child: new TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          color: HexColor(ColorStrings.VALUES), fontSize: 16),
                      autofocus: true,
                      decoration: InputDecoration.collapsed(
                          focusColor: HexColor(ColorStrings.emailPwdTextColor),
                          hintText: Strings.ENTER_EMAIL),
                      validator: (value) {
                        if (validateEmail(value)) {
                          return Strings.PLEASE_CHECK_EMAIL_ENTERED;
                        } else {
                          return null;
                        }
                      },
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      focusNode: _emailFocus,
                      onFieldSubmitted: (v) {
                        _emailFocus.unfocus();
                        FocusScope.of(context).requestFocus(_firstNameFocus);
                      },
                    ))
              ],
            )));

    final firstName = Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: HexColor(ColorStrings.BORDER),
            ),
            color: Colors.white),
        child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: <Widget>[
                Align(
                  child: Material(
                      color: Colors.transparent,
                      child: Text(Strings.FIRST_NAME,
                          style: TextStyle(
                              color: const Color(0xff202020),
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
                          color: HexColor(ColorStrings.VALUES), fontSize: 16),
                      autofocus: true,
                      decoration: InputDecoration.collapsed(
                          focusColor: HexColor(ColorStrings.emailPwdTextColor),
                          hintText: Strings.ENTER_FIRST_NAME),
                      validator: (value) {
                        if (value.isEmpty) {
                          return Strings.FIELD_CANNOT_BE_EMPTY;
                        } else {
                          return null;
                        }
                      },
                      controller: firstNameController,
                      textInputAction: TextInputAction.next,
                      focusNode: _firstNameFocus,
                      onFieldSubmitted: (v) {
                        _firstNameFocus.unfocus();
                        FocusScope.of(context).requestFocus(_lastNameFocus);
                      },
                    ))
              ],
            )));

    final lastName = Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            border: Border.all(
              color: HexColor(ColorStrings.BORDER),
            ),
            color: Colors.white),
        child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: <Widget>[
                Align(
                  child: Material(
                      color: Colors.transparent,
                      child: Text(Strings.LAST_NAME,
                          style: TextStyle(
                              color: const Color(0xff202020),
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
                          color: HexColor(ColorStrings.VALUES), fontSize: 16),
                      autofocus: true,
                      decoration: InputDecoration.collapsed(
                          focusColor: HexColor(ColorStrings.emailPwdTextColor),
                          hintText: Strings.ENTER_LAST_NAME),
                      validator: (value) {
                        if (value.isEmpty) {
                          return Strings.FIELD_CANNOT_BE_EMPTY;
                        } else {
                          return null;
                        }
                      },
                      controller: lastNameController,
                      textInputAction: TextInputAction.next,
                      focusNode: _lastNameFocus,
                      onFieldSubmitted: (v) {
                        _lastNameFocus.unfocus();
                        FocusScope.of(context).requestFocus(_userNameFocus);
                      },
                    ))
              ],
            )));

    final userName = Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            border: Border.all(
              color: HexColor(ColorStrings.BORDER),
            ),
            color: Colors.white),
        child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: <Widget>[
                Align(
                  child: Material(
                      color: Colors.transparent,
                      child: Text(Strings.USER_NAME_HEADING,
                          style: TextStyle(
                              color: const Color(0xff202020),
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
                          color: HexColor(ColorStrings.VALUES), fontSize: 16),
                      autofocus: true,
                      decoration: InputDecoration.collapsed(
                          focusColor: HexColor(ColorStrings.emailPwdTextColor),
                          hintText: Strings.ENTER_USERNAME),
                      validator: (value) {
                        if (value.isEmpty) {
                          return Strings.FIELD_CANNOT_BE_EMPTY;
                        } else {
                          return null;
                        }
                      },
                      controller: userNameController,
                      textInputAction: TextInputAction.next,
                      focusNode: _userNameFocus,
                      onFieldSubmitted: (v) {
                        _userNameFocus.unfocus();
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      },
                    ))
              ],
            )));

    final password = Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            border: Border.all(
              color: HexColor(ColorStrings.BORDER),
            ),
            color: Colors.white),
        child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: <Widget>[
                Align(
                  child: Material(
                      color: Colors.transparent,
                      child: Text(Strings.PASSWORD,
                          style: TextStyle(
                              color: const Color(0xff202020),
                              fontWeight: FontWeight.w400,
                              fontFamily: "SourceSansPro",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0))),
                  alignment: Alignment.centerLeft,
                ),
                new Material(
                    color: Colors.transparent,
                    child: new TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(
                          color: HexColor(ColorStrings.VALUES), fontSize: 16),
                      autofocus: true,
                      decoration: InputDecoration.collapsed(
                          focusColor: HexColor(ColorStrings.emailPwdTextColor),
                          hintText: Strings.ENTER_PASSWORD),
                      validator: (value) {
                        if (value.isEmpty) {
                          return Strings.FIELD_CANNOT_BE_EMPTY;
                        } else {
                          return null;
                        }
                      },
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
                      focusNode: _passwordFocus,
                      onFieldSubmitted: (v) {
                        _passwordFocus.unfocus();
                      },
                    ))
              ],
            )));

    Widget getSaveButton() {
      return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 26),
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
                    _saveUser();
                  },
                  color: const Color(0xff424e53))));
    }

    Widget getCupertinoScaffold(ProfileState state, ProfileBloc signUpBloc) {
      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
              backgroundColor:
                  HexColor(ColorStrings.boxBackground).withAlpha(30),
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/LoginScreen');
                },
                child: Row(
                  children: <Widget>[Image.asset("images/ic_back.png")],
                ),
              ),
              middle: Text(Strings.SIGN_UP)),
          child: Form(
              key: _createUserFormKey,
              child: Container(
                  decoration: BoxDecoration(
                      color:
                          HexColor(ColorStrings.boxBackground).withAlpha(30)),
                  child: Stack(children: <Widget>[
                    ListView(
                      children: <Widget>[
                        Padding(
                          child: profileImage,
                          padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
                        ),
                        emailWidget,
                        firstName,
                        lastName,
                        userName,
                        password,
                        Align(
                            child: getSaveButton(),
                            alignment: AlignmentDirectional.bottomCenter)
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
                    ),
                  ]))));
    }

    return BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) async {
          if (state is FetchUserSuccess) {
            _isLoading = false;
            _userName = state.users[0].userName;
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
            print(error);
            profileBloc.dispatch(
                FetchUserProfileImage(userName: _userName, token: _token));
          }

          if (state is FetchUserProfileImageSuccess) {
            _isLoading = false;
            var response = state.response;
            Directory tempDir = await getTemporaryDirectory();
            String tempPath = tempDir.path;
            imageFile = new File('$tempPath/trackaware/user_profile.png');
            await imageFile.writeAsBytes(response.bodyBytes);
          }

          if (state is FetchUserProfileImageFailure) {
            _isLoading = false;
          }

          if (state is ImageButtonClickSuccess) {
            _imageFile = state.pickedFile;
            if (_imageFile != null) {
              file = new File(_imageFile.path);
              fileImage = new FileImage(file);
            }
            Navigator.pop(context, 'Cancel');
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

  void _saveUser() {
    if (_imageFile == null) {
      showDemoDialog<String>(
        context: context,
        child: CupertinoAlertDialog(
          title: const Text('Please pick a photo'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Ok'),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context, 'Discard');
              },
            )
          ],
        ),
      );
      return;
    }
    if (_createUserFormKey.currentState.validate()) {
      var userMap = Map<String, String>();
      userMap.putIfAbsent("email", () => emailController.text);
      userMap.putIfAbsent("firstName", () => firstNameController.text);
      userMap.putIfAbsent("lastName", () => lastNameController.text);
      userMap.putIfAbsent("username", () => userNameController.text);
      userMap.putIfAbsent("password", () => passwordController.text);
      userMap.putIfAbsent("token", () => _token);
      // profileBloc.dispatch(SaveBtnClick(map: userMap, file: _imageFile));
    }
  }
}

showDemoDialog<T>({BuildContext context, Widget child}) {
  showDialog<T>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => child,
  );
}
