import 'package:equatable/equatable.dart';
import 'package:trackaware_lite/models/delivery_request.dart';
import 'package:trackaware_lite/models/depart_db.dart';
import 'package:trackaware_lite/models/location_response.dart';

abstract class CreateDepartEvent extends Equatable {
  CreateDepartEvent([List props = const []]) : super(props);
}

class LocationViewClick extends CreateDepartEvent {}

class DeliveryCompleteButtonClick extends CreateDepartEvent {
  final Depart depart;
  final DeliveryRequest deliveryRequest;
  DeliveryCompleteButtonClick(this.depart, this.deliveryRequest)
      : super([depart, deliveryRequest]);
}

class LocationSuccessResponse extends CreateDepartEvent {
  final List<LocationResponse> locationResponse;

  LocationSuccessResponse(this.locationResponse) : super([locationResponse]);

  @override
  String toString() =>
      'LocationResponse {locationResponse : $locationResponse}';
}

class LocationFailureResponse extends CreateDepartEvent {}

class TrackingNumberScanEvent extends CreateDepartEvent {
  @override
  String toString() {
    return "TrackingNumberScanEvent";
  }
}

class FetchUserName extends CreateDepartEvent {
  @override
  String toString() {
    return "FetchUserName";
  }
}

class FetchDeviceId extends CreateDepartEvent {
  @override
  String toString() {
    return "FetchDeviceId";
  }
}
