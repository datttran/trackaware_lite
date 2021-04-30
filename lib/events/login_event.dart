import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class LoginButtonPressed extends LoginEvent {
  final String userName;
  final String password;
  final bool rememberMe;

  LoginButtonPressed(
      {@required this.userName,
      @required this.password,
      @required this.rememberMe})
      : super([userName, password, rememberMe]);

  @override
  String toString() {
    return 'LoginButtonPressed : Username: $userName, password: $password, remberMe: $rememberMe';
  }
}

class CheckBoxClick extends LoginEvent {
  final bool isChecked;

  CheckBoxClick({
    @required this.isChecked,
  }) : super([isChecked]);
  @override
  String toString() => 'CheckBoxClick';
}

class FetchLoggedInUser extends LoginEvent {
  @override
  String toString() {
    return "FetchLoggedInUser";
  }
}
