import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ForgotPwdEvent extends Equatable {
  ForgotPwdEvent([List props = const []]) : super(props);
}

class SendButtonClick extends ForgotPwdEvent {
  final String email;
  SendButtonClick({@required this.email});
  @override
  String toString() {
    return "SendButtonClick";
  }
}
