import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';

abstract class SignaturePageState extends Equatable {
  SignaturePageState([List props = const []]) : super(props);
}

class SignatureInitial extends SignaturePageState {
  @override
  String toString() {
    return "SignatureInitial";
  }
}

class FetchPickUpItemsSuccess extends SignaturePageState {
  final List pickUpItems;
  FetchPickUpItemsSuccess({@required this.pickUpItems});
  @override
  String toString() {
    return "FetchPickUpItemsSuccess : $pickUpItems";
  }
}

class FetchPickUpItemsFailure extends SignaturePageState {
  final String error;
  FetchPickUpItemsFailure({@required this.error});
  @override
  String toString() {
    return "FetchPickUpItemsFailure : $error";
  }
}

class FetchDeviceIdSuccess extends SignaturePageState {
  final String deviceId;
  FetchDeviceIdSuccess({@required this.deviceId}) : super([deviceId]);
  @override
  String toString() {
    return "FetchDeviceIdSuccess";
  }
}

class UserNameFetchSuccess extends SignaturePageState {
  final String userName;

  UserNameFetchSuccess({@required this.userName}) : super([userName]);
  @override
  String toString() =>
      'UserNameFetchSuccess { UserNameFetchSuccess: $userName}';
}

class UserNameFetchFailure extends SignaturePageState {
  final String error;

  UserNameFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'UserNameFetchFailure { error: $error}';
}

class SignatureLoading extends SignaturePageState {
  @override
  String toString() {
    return "SignatureLoading";
  }
}

class TransactionRequestSuccess extends SignaturePageState {
  final String message;

  TransactionRequestSuccess({@required this.message}) : super([message]);
  @override
  String toString() {
    return 'TransactionRequestSuccess { message: $message}';
  }
}

class TransactionRequestFailure extends SignaturePageState {
  final String error;

  TransactionRequestFailure({@required this.error}) : super([error]);
  @override
  String toString() {
    return 'TransactionRequestFailure { error: $error}';
  }
}
