import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ProfileEvent extends Equatable {
  ProfileEvent([List props = const []]) : super(props);
}

class FetchUserDetailsResponse extends ProfileEvent {
  final String userName;
  final String token;
  FetchUserDetailsResponse({@required this.userName, @required this.token})
      : super([userName, token]);
  @override
  String toString() {
    return "FetchUserDetailsResponse - User ; $userName, Token - $token";
  }
}

class BackClickAction extends ProfileEvent {
  @override
  String toString() {
    return "BackClickAction";
  }
}

class LogoutClickAction extends ProfileEvent {
  final String userName;
  LogoutClickAction({@required this.userName});
  @override
  String toString() {
    return "LogoutClickAction";
  }
}

class FetchUser extends ProfileEvent {
  @override
  String toString() {
    return "FetchUser";
  }
}

class FetchUserProfileImage extends ProfileEvent {
  final String userName;
  final String token;
  FetchUserProfileImage({@required this.userName, @required this.token})
      : super([userName, token]);
  @override
  String toString() {
    return "FetchUserProfileImage - User ; $userName, Token - $token";
  }
}

class ResetEvent extends ProfileEvent {
  @override
  String toString() {
    return "ResetEvent";
  }
}

class RefreshTokenEvent extends ProfileEvent {
  final String userName;
  final String password;
  RefreshTokenEvent({@required this.userName, @required this.password});
  @override
  String toString() {
    return "RefreshTokenEvent";
  }
}
