import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackaware_lite/models/login_response.dart';
import 'package:trackaware_lite/models/logout_response.dart';
import 'package:trackaware_lite/models/user_db.dart';
import 'package:trackaware_lite/models/user_details_response.dart';
import 'package:http/http.dart' as http;

abstract class ProfileState extends Equatable {
  ProfileState([List props = const []]) : super(props);
}

class ProfileInitial extends ProfileState {
  @override
  String toString() {
    return "ProfileInitial";
  }
}

class ProfileLoading extends ProfileState {
  @override
  String toString() => 'ProfileLoading';
}

class ProfileFailure extends ProfileState {
  final String error;

  ProfileFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'ProfileFailure { error: $error}';
}

class ProfileSuccess extends ProfileState {
  final UserDetailsResponse userDetailsResponse;

  ProfileSuccess({@required this.userDetailsResponse})
      : super([userDetailsResponse]);
  @override
  String toString() =>
      'ProfileSuccess { UserDetailsResponse: $userDetailsResponse}';
}

class BackClickSuccess extends ProfileState {
  @override
  String toString() {
    return "BackClickSuccess";
  }
}

class LogoutSuccess extends ProfileState {
  final LogoutResponse logoutResponse;
  LogoutSuccess({@required this.logoutResponse});
  @override
  String toString() {
    return "LogoutSuccess";
  }
}

class LogoutFailure extends ProfileState {
  final String error;
  LogoutFailure({@required this.error});
  @override
  String toString() {
    return "LogoutFailure";
  }
}

class FetchUserSuccess extends ProfileState {
  final List<User> users;
  FetchUserSuccess({@required this.users}) : super([users]);
  @override
  String toString() {
    return "FetchUserSuccess";
  }
}

class FetchUserProfileImageSuccess extends ProfileState {
  final http.Response response;
  FetchUserProfileImageSuccess({@required this.response}) : super([response]);
  @override
  String toString() {
    return "FetchUserProfileImageSuccess - $response";
  }

  @override
  List<Object> get props => [response];
}

class FetchUserProfileImageFailure extends ProfileState {
  final String error;
  FetchUserProfileImageFailure({@required this.error}) : super([error]);
  @override
  String toString() {
    return "FetchUserProfileImageFailure - $error";
  }
}

class ImageButtonClickSuccess extends ProfileState {
  final PickedFile pickedFile;
  ImageButtonClickSuccess({@required this.pickedFile});
  @override
  String toString() {
    return "ImageButtonClickSuccess";
  }
}

class RefreshTokenFailure extends ProfileState {
  final String error;

  RefreshTokenFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'RefreshTokenFailure { error: $error}';
}

class RefreshTokenSuccess extends ProfileState {
  final LoginResponse loginResponse;

  RefreshTokenSuccess({@required this.loginResponse}) : super([loginResponse]);
  @override
  String toString() => 'RefreshTokenSuccess { LoginResponse: $loginResponse}';
}
