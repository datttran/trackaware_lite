import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:trackaware_lite/models/location_response.dart';

abstract class CreateArriveState extends Equatable {
  CreateArriveState([List props = const []]) : super(props);
}

class CreateArriveInitial extends CreateArriveState {
  CreateArriveInitial([List props = const []]) : super(props);
}

class LocationResponseFetchSuccess extends CreateArriveState {
  final List<LocationResponse> locationResponse;

  LocationResponseFetchSuccess({@required this.locationResponse})
      : super([locationResponse]);
  @override
  String toString() =>
      'LocationResponseFetchSuccess { LocationResponse: $locationResponse}';
}

class LocationApiCallLoading extends CreateArriveState {
  @override
  String toString() => 'LocationApiCallLoading';
}

class LocationResponseFetchFailure extends CreateArriveState {
  final String error;

  LocationResponseFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'LocationResponseFetchFailure { error: $error}';
}

class ArriveItemSaved extends CreateArriveState {
  final String message;
  ArriveItemSaved({@required this.message}) : super([message]);
  @override
  String toString() => 'ArriveItemSaved';
}

class ArriveItemFailure extends CreateArriveState {
  final String error;
  ArriveItemFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'ArriveItemFailure';
}

class DeliveryLoading extends CreateArriveState {
  @override
  String toString() {
    return "DeliveryLoading";
  }
}

class UserNameFetchSuccess extends CreateArriveState {
  final String userName;
  final String token;
  UserNameFetchSuccess({@required this.userName, @required this.token})
      : super([userName, token]);
  @override
  String toString() =>
      'UserNameFetchSuccess { UserNameFetchSuccess: $userName}';
}

class UserNameFetchFailure extends CreateArriveState {
  final String error;

  UserNameFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'UserNameFetchFailure { error: $error}';
}

class FetchDeviceIdSuccess extends CreateArriveState {
  final String deviceId;
  FetchDeviceIdSuccess({@required this.deviceId}) : super([deviceId]);
  @override
  String toString() {
    return "FetchDeviceIdSuccess";
  }
}
