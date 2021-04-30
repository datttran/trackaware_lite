import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';
import 'package:trackaware_lite/models/pickup_part_db.dart';

abstract class ListPickUpState extends Equatable {
  ListPickUpState([List props = const []]) : super(props);
}

class ListPickUpInitial extends ListPickUpState {
  ListPickUpInitial([List props = const []]) : super(props);
}

class LoadPickUpList extends ListPickUpState {
  @override
  String toString() => 'LoadPickUpList';
}

class ExternalPickUpListFetchSuccess extends ListPickUpState {
  final List<PickUpExternal> pickUpExternalResponse;

  ExternalPickUpListFetchSuccess({@required this.pickUpExternalResponse})
      : super([pickUpExternalResponse]);
  @override
  String toString() =>
      'ExternalPickUpListFetchSuccess { PickUpExternalListResponse: $pickUpExternalResponse}';
}

class ExternalPickUpListFetchFailure extends ListPickUpState {
  final String error;

  ExternalPickUpListFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'ExternalPickUpListFetchFailure { error: $error}';
}

class PickUpPartsListFetchSuccess extends ListPickUpState {
  final List<PickUpPart> pickUpPartsResponse;

  PickUpPartsListFetchSuccess({@required this.pickUpPartsResponse})
      : super([pickUpPartsResponse]);
  @override
  String toString() =>
      'PickUpPartsListFetchSuccess { PickUpPartListResponse: $pickUpPartsResponse}';
}

class PickUpPartsListFetchFailure extends ListPickUpState {
  final String error;

  PickUpPartsListFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'PickUpPartsListFetchFailure { error: $error}';
}

class UserNameFetchSuccess extends ListPickUpState {
  final String userName;
  final String token;
  UserNameFetchSuccess({@required this.userName, @required this.token})
      : super([userName, token]);
  @override
  String toString() =>
      'UserNameFetchSuccess { UserNameFetchSuccess: $userName}';
}

class UserNameFetchFailure extends ListPickUpState {
  final String error;

  UserNameFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'UserNameFetchFailure { error: $error}';
}

class FetchDeviceIdSuccess extends ListPickUpState {
  final String deviceId;
  FetchDeviceIdSuccess({@required this.deviceId}) : super([deviceId]);
  @override
  String toString() {
    return "FetchDeviceIdSuccess";
  }
}

class TransactionLoading extends ListPickUpState {
  @override
  String toString() => 'TransactionLoading';
}

class PickUpExternalSaved extends ListPickUpState {
  final String message;
  PickUpExternalSaved({@required this.message}) : super([message]);
  @override
  String toString() => 'PickUpExternalSaved - $message';
}

class PickUpExternalFailure extends ListPickUpState {
  final String error;
  PickUpExternalFailure({@required this.error}) : super([error]);
  @override
  String toString() {
    return "PickUpExternalFailure - $error";
  }
}

class PickUpPartsSaved extends ListPickUpState {
  final String message;
  PickUpPartsSaved({@required this.message}) : super([message]);
  @override
  String toString() => 'PickUpPartsSaved - $message';
}

class PickUpPartsFailure extends ListPickUpState {
  final String error;
  PickUpPartsFailure({@required this.error}) : super([error]);
  @override
  String toString() {
    return "PickUpPartsFailure - $error";
  }
}
