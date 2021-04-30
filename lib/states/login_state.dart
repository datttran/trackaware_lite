import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:trackaware_lite/models/login_response.dart';
import 'package:trackaware_lite/models/user_db.dart';

abstract class LoginState extends Equatable {
  LoginState([List props = const []]) : super(props);
}

class LoginInitial extends LoginState {
  @override
  String toString() => 'LoginInitial';
}

class LoginLoading extends LoginState {
  @override
  String toString() => 'LoginLoading';
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'LoginFailure { error: $error}';
}

class LoginSuccess extends LoginState {
  final LoginResponse loginResponse;

  LoginSuccess({@required this.loginResponse}) : super([loginResponse]);
  @override
  String toString() => 'LoginSuccess { LoginResponse: $loginResponse}';
}

class CheckBoxChecked extends LoginState {
  @override
  String toString() => 'CheckBoxChecked';
}

class CheckBoxUnChecked extends LoginState {
  @override
  String toString() => 'CheckBoxUnChecked';
}

class FetchUserSuccess extends LoginState {
  final User user;
  FetchUserSuccess({@required this.user}) : super([user]);
  @override
  String toString() {
    return "FetchUserSuccess";
  }
}

class FetchUserFailure extends LoginState {
  @override
  String toString() {
    return "FetchUserFailure";
  }
}
