import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/authentication_bloc.dart';
import 'package:trackaware_lite/blocs/login_bloc.dart';
import 'package:trackaware_lite/pages/login/login_form.dart';
import 'package:trackaware_lite/repositories/user_repository.dart';

class LoginPage extends StatefulWidget {

  final UserRespository userRepository;
  
  LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => new _LoginPageState(userRepository: userRepository);
}

class _LoginPageState extends State<LoginPage> {

  final UserRespository userRepository;

  _LoginPageState({@required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocProvider(
          builder: (context){
            return LoginBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              userRespository: userRepository,
            );
          },
        child : LoginForm()));
  }
}
