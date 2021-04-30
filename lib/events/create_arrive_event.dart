import 'package:equatable/equatable.dart';
import 'package:trackaware_lite/models/arrive_db.dart';
import 'package:trackaware_lite/models/delivery_request.dart';
import 'package:trackaware_lite/models/location_response.dart';

abstract class CreateArriveEvent extends Equatable {
  CreateArriveEvent([List props = const []]) : super(props);
}

class LocationViewClick extends CreateArriveEvent {}

class FetchUserName extends CreateArriveEvent {
  @override
  String toString() {
    return "FetchUserName";
  }
}

class FetchDeviceId extends CreateArriveEvent {
  @override
  String toString() {
    return "FetchDeviceId";
  }
}

class SubmitButtonClick extends CreateArriveEvent {
  final Arrive arrive;
  final DeliveryRequest deliveryRequest;
  SubmitButtonClick(this.arrive, this.deliveryRequest)
      : super([arrive, deliveryRequest]);
}

class LocationSuccessResponse extends CreateArriveEvent {
  final List<LocationResponse> locationResponse;

  LocationSuccessResponse(this.locationResponse) : super([locationResponse]);

  @override
  String toString() =>
      'LocationResponse {locationResponse : $locationResponse}';
}

class LocationFailureResponse extends CreateArriveEvent {}
