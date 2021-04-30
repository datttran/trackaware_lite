import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/forgot_password_bloc.dart';
import 'package:trackaware_lite/events/forgot_password_event.dart';
import 'package:trackaware_lite/states/forgot_password_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';

class ForgotPwdPage extends StatefulWidget {
  @override
  State<ForgotPwdPage> createState() {
    return _ForgotPwdPageState();
  }
}

final emailController = TextEditingController();

final FocusNode emailFocus = FocusNode();
final _forgotPwdFormKey = GlobalKey<FormState>();

bool _isLoading = false;
var forgotPwdBloc;

class _ForgotPwdPageState extends State<ForgotPwdPage> {
  @override
  void dispose() {
    emailController.clear();
    _isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    forgotPwdBloc = BlocProvider.of<ForgotPasswordBloc>(context);

    _sendEmail() {
      if (_forgotPwdFormKey.currentState.validate())
        forgotPwdBloc.dispatch(SendButtonClick(email: emailController.text));
    }

    Widget getSendButton() {
      return Padding(
          padding: EdgeInsets.fromLTRB(16, 100, 16, 26),
          child: Container(
              width: double.infinity,
              child: RaisedButton(
                  elevation: 8.0,
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.all(16),
                  child: Text(Strings.SEND,
                      style: TextStyle(
                          color: HexColor(ColorStrings.SEND_BUTTON_TEXT_COLOR),
                          fontWeight: FontWeight.w400,
                          fontFamily: "SourceSansPro",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.center),
                  onPressed: () {
                    _sendEmail();
                  },
                  color: const Color(0xff424e53))));
    }

    Widget getUserNameWidget() {
      return Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: HexColor(ColorStrings.BORDER),
              ),
              color: Colors.white),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(14, 16, 10, 0),
                    child: Material(
                        color: Colors.transparent,
                        child: Text(
                          Strings.USERNAME,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: HexColor(ColorStrings.HEADING),
                              fontFamily: "SourceSansPro",
                              fontSize: 12.0,
                              fontStyle: FontStyle.normal),
                        ))),
                Padding(
                    padding: EdgeInsets.fromLTRB(14, 10, 10, 16),
                    child: new Material(
                        color: Colors.transparent,
                        child: new TextFormField(
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: HexColor(ColorStrings.VALUES),
                              fontSize: 16),
                          autofocus: true,
                          decoration: InputDecoration.collapsed(
                              focusColor:
                                  HexColor(ColorStrings.emailPwdTextColor),
                              hintText: Strings.ENTER_USERNAME),
                          validator: (value) {
                            if (value.isEmpty) {
                              return Strings.USER_NAME_CANNOT_BE_EMPTY;
                            } else {
                              return null;
                            }
                          },
                          controller: emailController,
                          textInputAction: TextInputAction.next,
                          focusNode: emailFocus,
                          onFieldSubmitted: (v) {
                            emailFocus.unfocus();
                          },
                        )))
              ]));
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
              middle: Text(Strings.FORGOT_PWD_TITLE)),
          child: Form(
              key: _forgotPwdFormKey,
              child: Container(
                  decoration: BoxDecoration(
                      color:
                          HexColor(ColorStrings.boxBackground).withAlpha(30)),
                  child: Stack(children: <Widget>[
                    ListView(
                      children: <Widget>[getUserNameWidget()],
                    ),
                    Align(
                      child: getSendButton(),
                      alignment: AlignmentDirectional.bottomCenter,
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

    Widget getCupertinoScaffold(
        ForgotPwdState state, ForgotPasswordBloc forgotPasswordBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                Navigator.pop(context);
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<ForgotPasswordBloc, ForgotPwdState>(
        listener: (context, state) {
          if (state is ForgotPwdSuccess) {
            _isLoading = false;
            Navigator.pop(context);
          }

          if (state is ForgotPwdLoading) {
            _isLoading = true;
          }

          if (state is ForgotPwdFailure) {
            _isLoading = false;
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ForgotPasswordBloc, ForgotPwdState>(
            bloc: forgotPwdBloc,
            builder: (
              BuildContext context,
              ForgotPwdState state,
            ) {
              return getCupertinoScaffold(state, forgotPwdBloc);
            }));
  }
}
