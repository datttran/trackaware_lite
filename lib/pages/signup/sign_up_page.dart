import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:trackaware_lite/blocs/sign_up_bloc.dart';
import 'package:trackaware_lite/events/sign_up_event.dart';
import 'package:trackaware_lite/states/sign_up_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() {
    return _SignUpPageState();
  }
}

var signUpBloc;
var base64String = new StringBuffer();

class _SignUpPageState extends State<SignUpPage> implements AlertClickCallBack {
  final firstNameController = TextEditingController();
  final emailController = TextEditingController();
  final lastNameController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  var fileImage;
  var image;
  var file;
  bool _isLoading = false;
  bool _isImageAvailable = false;

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
    signUpBloc = BlocProvider.of<SignUpBloc>(context);

    showDemoActionSheet<T>({BuildContext context, Widget child}) {
      showCupertinoModalPopup<T>(
        context: context,
        builder: (BuildContext context) => child,
      );
    }

    Widget _getProfileImage() {
      return GestureDetector(
          child: new Container(
              alignment: Alignment.topCenter,
              child: _isImageAvailable
                  ? CircleAvatar(
                      backgroundImage: fileImage,
                      radius: 75.0,
                    )
                  : CircleAvatar(
                      backgroundImage: AssetImage('images/ic_user.png'),
                      radius: 75.0,
                    )),
          onTap: () {
            showDemoActionSheet<String>(
                context: context,
                child: CupertinoActionSheet(
                    title: const Text('Select source'),
                    message: const Text('Please select from the below two options'),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                        child: const Text('Camera'),
                        onPressed: () {
                          signUpBloc.dispatch(ImageButtonClick(imageSource: ImageSource.camera, imagePicker: ImagePicker()));
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: const Text('Gallery'),
                        onPressed: () {
                          signUpBloc.dispatch(ImageButtonClick(imageSource: ImageSource.gallery, imagePicker: ImagePicker()));
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
    }

    final email = GestureDetector(
        onTap: () {
          _firstNameFocus.unfocus();
          _lastNameFocus.unfocus();
          _userNameFocus.unfocus();
          _passwordFocus.unfocus();
          FocusScope.of(context).requestFocus(_emailFocus);
        },
        child: Container(
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
                          child: Text(Strings.EMAIL, style: TextStyle(color: const Color(0xff202020), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0))),
                      alignment: Alignment.centerLeft,
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: new Material(
                            color: Colors.transparent,
                            child: new TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: HexColor(ColorStrings.VALUES), fontSize: 16),
                              autofocus: false,
                              decoration: InputDecoration.collapsed(focusColor: HexColor(ColorStrings.emailPwdTextColor), hintText: Strings.ENTER_EMAIL),
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
                            )))
                  ],
                ))));

    final firstName = GestureDetector(
        onTap: () {
          _emailFocus.unfocus();
          _lastNameFocus.unfocus();
          _userNameFocus.unfocus();
          _passwordFocus.unfocus();
          FocusScope.of(context).requestFocus(_firstNameFocus);
        },
        child: Container(
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
                          child: Text(Strings.FIRST_NAME, style: TextStyle(color: const Color(0xff202020), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0))),
                      alignment: Alignment.centerLeft,
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: new Material(
                            color: Colors.transparent,
                            child: new TextFormField(
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: HexColor(ColorStrings.VALUES), fontSize: 16),
                              autofocus: false,
                              decoration: InputDecoration.collapsed(focusColor: HexColor(ColorStrings.emailPwdTextColor), hintText: Strings.ENTER_FIRST_NAME),
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
                            )))
                  ],
                ))));

    final lastName = GestureDetector(
        onTap: () {
          _emailFocus.unfocus();
          _lastNameFocus.unfocus();
          _userNameFocus.unfocus();
          _passwordFocus.unfocus();
          FocusScope.of(context).requestFocus(_lastNameFocus);
        },
        child: Container(
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
                          child: Text(Strings.LAST_NAME, style: TextStyle(color: const Color(0xff202020), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0))),
                      alignment: Alignment.centerLeft,
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: new Material(
                            color: Colors.transparent,
                            child: new TextFormField(
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: HexColor(ColorStrings.VALUES), fontSize: 16),
                              autofocus: false,
                              decoration: InputDecoration.collapsed(focusColor: HexColor(ColorStrings.emailPwdTextColor), hintText: Strings.ENTER_LAST_NAME),
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
                            )))
                  ],
                ))));

    final userName = GestureDetector(
        onTap: () {
          _emailFocus.unfocus();
          _lastNameFocus.unfocus();
          _firstNameFocus.unfocus();
          _passwordFocus.unfocus();
          FocusScope.of(context).requestFocus(_userNameFocus);
        },
        child: Container(
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
                          child: Text(Strings.USER_NAME_HEADING, style: TextStyle(color: const Color(0xff202020), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0))),
                      alignment: Alignment.centerLeft,
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: new Material(
                            color: Colors.transparent,
                            child: new TextFormField(
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: HexColor(ColorStrings.VALUES), fontSize: 16),
                              autofocus: false,
                              decoration: InputDecoration.collapsed(focusColor: HexColor(ColorStrings.emailPwdTextColor), hintText: Strings.ENTER_USERNAME),
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
                            )))
                  ],
                ))));

    final password = GestureDetector(
        onTap: () {
          _firstNameFocus.unfocus();
          _lastNameFocus.unfocus();
          _userNameFocus.unfocus();
          _emailFocus.unfocus();
          FocusScope.of(context).requestFocus(_passwordFocus);
        },
        child: Container(
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
                          child: Text(Strings.PASSWORD, style: TextStyle(color: const Color(0xff202020), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0))),
                      alignment: Alignment.centerLeft,
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: new Material(
                            color: Colors.transparent,
                            child: new TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              style: TextStyle(color: HexColor(ColorStrings.VALUES), fontSize: 16),
                              autofocus: false,
                              decoration: InputDecoration.collapsed(focusColor: HexColor(ColorStrings.emailPwdTextColor), hintText: Strings.ENTER_PASSWORD),
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
                            )))
                  ],
                ))));

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
                      style: TextStyle(color: HexColor(ColorStrings.SEND_BUTTON_TEXT_COLOR), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0), textAlign: TextAlign.center),
                  onPressed: () {
                    _saveUser();
                  },
                  color: const Color(0xff424e53))));
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
              middle: Text(Strings.SIGN_UP)),
          child: Form(
              key: _createUserFormKey,
              child: Container(
                  decoration: BoxDecoration(color: HexColor(ColorStrings.boxBackground).withAlpha(30)),
                  child: Stack(children: <Widget>[
                    ListView(
                      children: <Widget>[
                        Padding(
                          child: _getProfileImage(),
                          padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
                        ),
                        email,
                        firstName,
                        lastName,
                        userName,
                        password,
                        Align(child: getSaveButton(), alignment: AlignmentDirectional.bottomCenter)
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

    Widget getCupertinoScaffold(SignUpState state, SignUpBloc signUpBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                Navigator.pop(context);
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpLoading) {
            _isLoading = true;
          }

          if (state is SignUpSuccess) {
            _isLoading = false;
            showAlertDialog(context, "Signed Up Successfully", this);
          }

          if (state is SignUpFailure) {
            _isLoading = false;
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is ImageButtonClickSuccess) {
            _imageFile = state.pickedFile;
            _isImageAvailable = true;
            file = new File(_imageFile.path);
            fileImage = new FileImage(file);
            signUpBloc.dispatch(ResetEvent());
            Navigator.pop(context, 'Cancel');
          }
        },
        child: BlocBuilder<SignUpBloc, SignUpState>(
            bloc: signUpBloc,
            builder: (
              BuildContext context,
              SignUpState state,
            ) {
              return getCupertinoScaffold(state, signUpBloc);
            }));
  }

  Future<void> _saveUser() async {
    /*
    Commented out to make photo optional on signup
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
    } */
    if (_createUserFormKey.currentState.validate()) {
      var userMap = Map<String, String>();
      userMap.putIfAbsent("email", () => emailController.text);
      userMap.putIfAbsent("firstName", () => firstNameController.text);
      userMap.putIfAbsent("lastName", () => lastNameController.text);
      userMap.putIfAbsent("username", () => userNameController.text);
      userMap.putIfAbsent("password", () => passwordController.text);
      if (_imageFile != null) {
        final dir = await path_provider.getTemporaryDirectory();
        final targetPath = dir.absolute.path + "/temp.jpg";
        var file = await testCompressAndGetFile(_imageFile, targetPath);
        signUpBloc.dispatch(SaveBtnClick(map: userMap, file: file));
      } else {
        final dir = await path_provider.getApplicationDocumentsDirectory();
        var imagePath = dir.path + "/ic_user.png";
        ByteData data = await rootBundle.load("images/ic_user.png");
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(imagePath).writeAsBytes(bytes);
        signUpBloc.dispatch(SaveBtnClick(map: userMap, file: File(imagePath)));
      }
    }
  }

  File createFile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    return file;
  }

  Future<File> testCompressAndGetFile(PickedFile file, String targetPath) async {
    print("testCompressAndGetFile");
    final result = await FlutterImageCompress.compressAndGetFile(file.path, targetPath, quality: 90, minWidth: 200, minHeight: 200);

    print(result.lengthSync());
    return result;
  }

  @override
  void onClickAction() {
    Navigator.pop(context);
  }
}

showDemoDialog<T>({BuildContext context, Widget child}) {
  showDialog<T>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => child,
  );
}

bool validateEmail(String value) {
  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);
  if (value.isEmpty) {
    return true;
  } else if (!regExp.hasMatch(value)) {
    return true;
  } else {
    return false;
  }
}
