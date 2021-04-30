import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ForgotPwdState extends Equatable {
  ForgotPwdState([List props = const []]) : super(props);
}

class ForgotPwdInitial extends ForgotPwdState{
  @override
  String toString() {
    return "ForgotPwdInitial";
  }
}

class ForgotPwdSuccess extends ForgotPwdState{
  final String message;
  ForgotPwdSuccess({@required this.message});
  @override
  String toString() {
    return "ForgotPwdSuccess";
  }
}

class ForgotPwdLoading extends ForgotPwdState{
  @override
  String toString() {
    return "ForgotPwdLoading";
  }
}

class ForgotPwdFailure extends ForgotPwdState{
  final String error;
  ForgotPwdFailure({@required this.error});
  @override
  String toString() {
    return "ForgotPwdFailure";
  }
}