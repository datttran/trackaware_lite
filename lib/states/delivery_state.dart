import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';

abstract class DeliveryState extends Equatable {
  DeliveryState([List props = const []]) : super(props);
}

class DeliveryInitial extends DeliveryState {
  @override
  String toString() {
    return "DeliveryInitial";
  }
}

class LocationResponseFetchSuccess extends DeliveryState {
  final List<LocationResponse> locationResponse;

  LocationResponseFetchSuccess({@required this.locationResponse})
      : super([locationResponse]);
  @override
  String toString() =>
      'LocationResponseFetchSuccess { LocationResponse: $locationResponse}';
}

class LocationApiCallLoading extends DeliveryState {
  @override
  String toString() => 'LocationApiCallLoading';
}

class Loading extends DeliveryState {
  @override
  String toString() => 'LocationApiCallLoading';
}

class LocationResponseFetchFailure extends DeliveryState {
  final String error;

  LocationResponseFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'LocationResponseFetchFailure { error: $error}';
}

class DestinationListFetchSuccess extends DeliveryState {
  final List<PickUpExternal> pickUpResponse;

  DestinationListFetchSuccess({@required this.pickUpResponse})
      : super([pickUpResponse]);
  @override
  String toString() =>
      'DestinationListFetchSuccess { PickUpListResponse: $pickUpResponse}';
}

class DestinationListFetchFailure extends DeliveryState {
  final String error;

  DestinationListFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'DestinationListFetchFailure { error: $error}';
}

class NextButtonClickSuccess extends DeliveryState {
  @override
  String toString() {
    return 'NextButtonClickSuccess';
  }
}

class ResetState extends DeliveryState {
  @override
  String toString() {
    return "ResetState";
  }
}

class ShowHideMsgBlock extends DeliveryState {
  final bool showMsg;
  ShowHideMsgBlock({@required this.showMsg}) : super([showMsg]);
  @override
  String toString() {
    return "ShowHideMsgBlock : $showMsg";
  }
}
