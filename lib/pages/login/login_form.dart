import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trackaware_lite/blocs/login_bloc.dart';
import 'package:trackaware_lite/events/login_event.dart';
import 'package:trackaware_lite/states/login_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:trackaware_lite/constants.dart';
import 'package:trackaware_lite/responsive/size_config.dart';
class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  //final emailController = TextEditingController(text: 'teresaf');
  //final passwordController = TextEditingController(text: 'Teresaf11@');
  final emailController = TextEditingController(text: 'testtest');
  final passwordController = TextEditingController(text: 'testtest1');
  var userFetchCount = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    bool isTermsAndCon = false;

    final email = new Material(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          child: new TextFormField(

            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(
                color: HexColor(ColorStrings.emailPwdTextColor), fontSize: 16),
            autofocus: false,
            decoration: InputDecoration.collapsed(
                focusColor: HexColor(ColorStrings.emailPwdTextColor),
                hintText: "Enter username",
                hintStyle: TextStyle(color: Colors.white70.withOpacity(0.2), fontSize: 15)),
            validator: (value) {
              if (value.isEmpty) {
                return Strings.userNameValidationMessage;
              }
              return null;
            },
            controller: emailController,
            textInputAction: TextInputAction.next,
            focusNode: _emailFocus,
            onFieldSubmitted: (v) {
              _emailFocus.unfocus();
              FocusScope.of(context).requestFocus(_passwordFocus);
            },
          ),
        ));

    final userNameBlock = GestureDetector(
        onTap: () {
          _passwordFocus.unfocus();
          FocusScope.of(context).requestFocus(_emailFocus);
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  SizedBox(width: 5),
                  Text(
                    Strings.usernameCaps,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: HexColor(ColorStrings.emailPwdTextColor),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
              ),
              email
            ],
          ),
        ));

    final password = new Material(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          child: TextFormField(

            focusNode: _passwordFocus,
            autofocus: false,
            style: TextStyle(
                color: HexColor(ColorStrings.emailPwdTextColor), fontSize: 17),
            controller: passwordController,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value.isEmpty) {
                return Strings.passwordValidationMessage;
              }
              return null;
            },
            obscureText: true,
            decoration: InputDecoration.collapsed(
                hintText: "Enter Password",
                hintStyle: TextStyle(color: Colors.white70.withOpacity(0.2), fontSize: 15)),
          ),
        ));

    final passwordBlock = GestureDetector(
        onTap: () {
          _emailFocus.unfocus();
          FocusScope.of(context).requestFocus(_passwordFocus);
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  SizedBox(width: 5),
                  Text(
                    Strings.passwordCaps,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: HexColor(ColorStrings.emailPwdTextColor),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
              ),
              password
            ],
          ),
        ));

    _onLoginButtonPressed() {
      if (_formKey.currentState.validate()) {
        //terms and conditions changed to remember me
        /* if (!isTermsAndCon) {
          showDemoDialog<String>(
            context: context,
            child: CupertinoAlertDialog(
              title: const Text(
                  'By logging in, you agree to Terms and Conditions for using Trackaware'),
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
        FocusScope.of(context).requestFocus(FocusNode());
        loginBloc.dispatch(LoginButtonPressed(
            userName: emailController.text.replaceAll("\\s", ""),
            password: passwordController.text.replaceAll("\\s", ""),
            rememberMe: isTermsAndCon));
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is FetchUserSuccess) {
          var user = state.user;
          emailController.text = user.userName;
          emailController.selection = TextSelection.fromPosition(
              TextPosition(offset: emailController.text.length));
          passwordController.text = user.password;
          passwordController.selection = TextSelection.fromPosition(
              TextPosition(offset: passwordController.text.length));
          isTermsAndCon = user.rememberMe == 1;
          userFetchCount++;
        }

        if (state is FetchUserFailure) {
          userFetchCount++;
        }

        if (state is LoginSuccess) {
          Navigator.of(context).pushReplacementNamed('/LandingScreen');
        }

        if (state is CheckBoxChecked) {
          isTermsAndCon = true;
        }

        if (state is CheckBoxUnChecked) {
          isTermsAndCon = false;
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        bloc: loginBloc,
        builder: (
          BuildContext context,
          LoginState state,
        ) {
          if (userFetchCount == 0) loginBloc?.dispatch(FetchLoggedInUser());
          return Form(
              key: _formKey,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xff2C2C34),
                          Color(0xff171721)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(26.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            SizedBox(
                              width: 7,
                            ),
                            SvgPicture.asset(
                              "assets/logo.svg",
                              height: verticalPixel*20,
                              color: Colors.white70,
                            ),
                          ],
                        )),
                    SizedBox(height: verticalPixel*2,),
                    Column(children: [
                      userNameBlock,
                      passwordBlock,
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0, 8, 40, 8),
                        child: CheckboxListTile(
                          activeColor: Colors.indigoAccent.withOpacity(.5),

                          title: Text("Remember me",
                            style: TextStyle(color: Colors.white70),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: isTermsAndCon,
                          onChanged: (bool value) {
                            isTermsAndCon = value;
                            loginBloc.dispatch(new CheckBoxClick(
                                isChecked: isTermsAndCon));
                          },
                        ),
                      ),
                    ],),

                    SizedBox(height:verticalPixel*4,),

                    Container(
                      child: state is LoginLoading
                          ? CupertinoActivityIndicator(
                              animating: true,
                              radius: 20.0,
                            )
                          : new Container(width: 0.0, height: 0.0),
                    ),

                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _onLoginButtonPressed();
                          },
                          child: Container(
                              width: double.infinity,
                              height: 60,
                              //margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [Color(0xff621fff),
                                        Color(0xff640eba)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                      color: Colors.transparent,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(0)),
                              child: new Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    Strings.loginText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: HexColor(
                                            ColorStrings.loginTextColor)),
                                  ))),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/SignUpScreen');
                          },
                          child: Container(
                              width: double.infinity,
                              height: 60,
                              //margin: EdgeInsets.fromLTRB(40, 8, 40, 0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [Color(0xffe0e0ff).withOpacity(.8), Color(
                                          0xffffffff).withOpacity(1)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                      color: Colors.transparent,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(0)),
                              child: new Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    Strings.SIGN_UP,
                                    textAlign: TextAlign.center,
                                  ))),
                        ),
                      ],
                    ),


                    GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/ForgotPwdScreen');
                        },
                        child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(30, 16, 40, 0),
                            child: Text(
                              Strings.forgotpassword,
                              style: TextStyle(
                                color: Colors.white70,
                                  decoration: TextDecoration.underline),
                            ))),
                    SizedBox(height: verticalPixel*1,),
                    Padding(
                        padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        child: RichText(
                          textAlign: TextAlign.center,
                            text: TextSpan(
                          style: TextStyle(fontSize: 12),
                          children: [
                          TextSpan(
                              text: 'By Logging In, you agree to the ',
                              style: TextStyle(color: Colors.white70)),
                          TextSpan(
                            text: "Terms of Use",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url =
                                    'https://www.sensitel.com/terms.php';
                                if (await canLaunch(url)) {
                                  await launch(
                                    url,
                                    forceSafariVC: false,
                                  );
                                }
                              },
                          ),
                          TextSpan(
                              text: ' for ',
                              style: TextStyle(color: Colors.white70)),
                          TextSpan(
                              text: 'Sensitel Service.',
                              style: TextStyle(color: Colors.white)),

                        ])))
                  ],
                ),
              ));
        },
      ),
    );
  }
}
