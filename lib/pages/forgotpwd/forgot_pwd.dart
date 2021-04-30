import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/forgot_password_bloc.dart';
import 'package:trackaware_lite/pages/forgotpwd/forgot_pwd_page.dart';
import 'package:trackaware_lite/repositories/user_repository.dart';

class ForgotPwd extends StatefulWidget {
  final UserRespository userRepository;

  ForgotPwd({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);
  @override
  _ForgotPwdState createState() =>
      new _ForgotPwdState(userRespository: userRepository);
}

class _ForgotPwdState extends State<ForgotPwd> {
  final UserRespository userRespository;
  _ForgotPwdState({@required this.userRespository});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (context) {
          return ForgotPasswordBloc(userRespository: userRespository);
        },
        child: ForgotPwdPage());
  }
}
