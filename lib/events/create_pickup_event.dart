import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';
import 'package:trackaware_lite/models/pickup_part_db.dart';
import 'package:trackaware_lite/models/transaction_request.dart';

abstract class CreatePickUpEvent extends Equatable {
  CreatePickUpEvent([List props = const []]) : super(props);
}

class PickUpSiteViewClick extends CreatePickUpEvent {}

class DeliverySiteViewClick extends CreatePickUpEvent {}

class LocationViewClick extends CreatePickUpEvent {}

class DestinationViewClick extends CreatePickUpEvent {}

class SendButtonClick extends CreatePickUpEvent {
  final TransactionRequest transactionRequest;
  final PickUpExternal pickUpExternal;
  SendButtonClick(this.transactionRequest, this.pickUpExternal)
      : super([transactionRequest, pickUpExternal]);
}

class SendPartsButtonClick extends CreatePickUpEvent {
  final TransactionRequest transactionRequest;
  final PickUpPart pickUpPart;
  SendPartsButtonClick(this.transactionRequest, this.pickUpPart)
      : super([transactionRequest, pickUpPart]);
}

class PickUpSiteSuccessResponse extends CreatePickUpEvent {
  final List<LocationResponse> locationResponse;

  PickUpSiteSuccessResponse(this.locationResponse) : super([locationResponse]);

  @override
  String toString() =>
      'LocationResponse {locationResponse : $locationResponse}';
}

class PickUpFailureResponse extends CreatePickUpEvent {}

class DeliverySiteSuccessResponse extends CreatePickUpEvent {
  final List<LocationResponse> locationResponse;

  DeliverySiteSuccessResponse(this.locationResponse)
      : super([locationResponse]);

  @override
  String toString() =>
      'DeliverySiteSuccessResponse {locationResponse : $locationResponse}';
}

class DestinationSiteFailureResponse extends CreatePickUpEvent {}

class CheckBoxClick extends CreatePickUpEvent {
  final bool isChecked;

  CheckBoxClick({
    @required this.isChecked,
  }) : super([isChecked]);
  @override
  String toString() => 'CheckBoxClick';
}

class ScanButtonClick extends CreatePickUpEvent {
  @override
  String toString() {
    return 'ScanButtonClick';
  }
}

class PackageDetailsValidation extends CreatePickUpEvent {
  final String tag;
  PackageDetailsValidation(this.tag) : super([tag]);
  @override
  String toString() => 'PackageDetailsValidation';
}

class TrackingNumberScanEvent extends CreatePickUpEvent {
  @override
  String toString() {
    return "TrackingNumberScanEvent";
  }
}

class OrderNumberScanEvent extends CreatePickUpEvent {
  @override
  String toString() {
    return "OrderNumberScanEvent";
  }
}

class PartNumberScanEvent extends CreatePickUpEvent {
  @override
  String toString() {
    return "PartNumberScanEvent";
  }
}

class FetchUserName extends CreatePickUpEvent {
  @override
  String toString() {
    return "FetchUserName";
  }
}

class FetchDeviceId extends CreatePickUpEvent {
  @override
  String toString() {
    return "FetchDeviceId";
  }
}

class AddToListPartButtonClick extends CreatePickUpEvent {
  final PickUpPart pickUpPart;
  AddToListPartButtonClick(this.pickUpPart) : super([pickUpPart]);
}

class AddToListExternalButtonClick extends CreatePickUpEvent {
  final PickUpExternal pickUpExternal;
  AddToListExternalButtonClick(this.pickUpExternal) : super([pickUpExternal]);
}
