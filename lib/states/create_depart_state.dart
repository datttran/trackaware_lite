import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:trackaware_lite/models/location_response.dart';

abstract class CreateDepartState extends Equatable {
  CreateDepartState([List props = const []]) : super(props);
}

class CreateDepartInitial extends CreateDepartState {
  CreateDepartInitial([List props = const []]) : super(props);
}

class LocationResponseFetchSuccess extends CreateDepartState {
  final List<LocationResponse> locationResponse;

  LocationResponseFetchSuccess({@required this.locationResponse})
      : super([locationResponse]);
  @override
  String toString() =>
      'LocationResponseFetchSuccess { LocationResponse: $locationResponse}';
}

class LocationApiCallLoading extends CreateDepartState {
  @override
  String toString() => 'LocationApiCallLoading';
}

class LocationResponseFetchFailure extends CreateDepartState {
  final String error;

  LocationResponseFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'LocationResponseFetchFailure { error: $error}';
}

class DepartItemSaved extends CreateDepartState {
  final String message;
  DepartItemSaved({@required this.message}) : super([message]);
  @override
  String toString() => 'DepartItemSaved';
}

class DepartItemFailure extends CreateDepartState {
  final String error;
  DepartItemFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'ArriveItemFailure';
}

class DeliveryLoading extends CreateDepartState {
  @override
  String toString() {
    return "DeliveryLoading";
  }
}

class UserNameFetchSuccess extends CreateDepartState {
  final String userName;
  final String token;
  UserNameFetchSuccess({@required this.userName, @required this.token})
      : super([userName, token]);
  @override
  String toString() =>
      'UserNameFetchSuccess { UserNameFetchSuccess: $userName}';
}

class UserNameFetchFailure extends CreateDepartState {
  final String error;

  UserNameFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'UserNameFetchFailure { error: $error}';
}

class FetchDeviceIdSuccess extends CreateDepartState {
  final String deviceId;
  FetchDeviceIdSuccess({@required this.deviceId}) : super([deviceId]);
  @override
  String toString() {
    return "FetchDeviceIdSuccess";
  }
}

class TrackingNumberScanSuccess extends CreateDepartState {
  final String barCode;
  TrackingNumberScanSuccess({@required this.barCode});
  @override
  String toString() {
    return "TrackingNumberScanSuccess";
  }
}

class ScanOptionFailure extends CreateDepartState {
  final String error;
  ScanOptionFailure({@required this.error});
  @override
  String toString() {
    return "ScanOptionFailure : $error";
  }
}
