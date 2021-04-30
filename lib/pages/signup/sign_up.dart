import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/sign_up_bloc.dart';
import 'package:trackaware_lite/pages/signup/sign_up_page.dart';
import 'package:trackaware_lite/repositories/user_repository.dart';

class SignUp extends StatefulWidget { 
  
  final UserRespository userRepository;
  
  SignUp({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);
  @override
  _SignUpState createState() =>
      new _SignUpState(userRepository: userRepository);
}

class _SignUpState extends State<SignUp> {

  final UserRespository userRepository;

  _SignUpState({@required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          builder: (context){
            return SignUpBloc(userRespository: userRepository
              );
          },
        child : SignUpPage());
  }
}



