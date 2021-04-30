import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/priority_response.dart';
import 'package:trackaware_lite/models/tender_external_db.dart';
import 'package:trackaware_lite/models/tender_parts_db.dart';
import 'package:trackaware_lite/models/transaction_request.dart';

abstract class CreateExternalTenderEvent extends Equatable {
  CreateExternalTenderEvent([List props = const []]) : super(props);
}

class PriorityViewClick extends CreateExternalTenderEvent {
  @override
  String toString() {
    return "PriorityViewClick";
  }
}

class LocationViewClick extends CreateExternalTenderEvent {
  @override
  String toString() {
    return "LocationViewClick";
  }
}

class DestinationViewClick extends CreateExternalTenderEvent {
  @override
  String toString() {
    return "DestinationViewClick";
  }
}

class FetchPriorityResponse extends CreateExternalTenderEvent {
  @override
  String toString() {
    return "FetchPriorityResponse";
  }
}

class SendButtonClick extends CreateExternalTenderEvent {
  final TenderExternal tenderExternal;
  SendButtonClick(this.tenderExternal) : super([tenderExternal]);
}

class AddToListExternalButtonClick extends CreateExternalTenderEvent {
  final TenderExternal tenderExternal;
  AddToListExternalButtonClick(this.tenderExternal) : super([tenderExternal]);
}

class SendPartsButtonClick extends CreateExternalTenderEvent {
  final TransactionRequest transactionRequest;
  final TenderParts tenderParts;
  final String deviceIdValue;
  final String userName;
  SendPartsButtonClick(this.transactionRequest, this.tenderParts,
      this.deviceIdValue, this.userName)
      : super([transactionRequest, tenderParts]);
}

class AddToListPartButtonClick extends CreateExternalTenderEvent {
  final TenderParts tenderParts;
  AddToListPartButtonClick(this.tenderParts) : super([tenderParts]);
}

class SendExternalButtonClick extends CreateExternalTenderEvent {
  final TransactionRequest transactionRequest;
  final TenderExternal tenderExternal;
  final String deviceIdValue;
  final String userName;
  SendExternalButtonClick(this.transactionRequest, this.tenderExternal,
      this.deviceIdValue, this.userName)
      : super([transactionRequest, tenderExternal]);
}

class PriortySuccessResponse extends CreateExternalTenderEvent {
  final List<PriorityResponse> priorityResponse;

  PriortySuccessResponse(this.priorityResponse) : super([priorityResponse]);

  @override
  String toString() =>
      'PriorityResponse {priorityResponse : $priorityResponse}';
}

class PriorityFailureResponse extends CreateExternalTenderEvent {}

class LocationSuccessResponse extends CreateExternalTenderEvent {
  final List<LocationResponse> locationResponse;

  LocationSuccessResponse(this.locationResponse) : super([locationResponse]);

  @override
  String toString() =>
      'LocationResponse {locationResponse : $locationResponse}';
}

class LocationFailureResponse extends CreateExternalTenderEvent {}

class DestinationSuccessResponse extends CreateExternalTenderEvent {
  final List<LocationResponse> locationResponse;

  DestinationSuccessResponse(this.locationResponse) : super([locationResponse]);

  @override
  String toString() =>
      'DestinationSuccessResponse {locationResponse : $locationResponse}';
}

class DestinationFailureResponse extends CreateExternalTenderEvent {}

class CheckBoxClick extends CreateExternalTenderEvent {
  final bool isChecked;

  CheckBoxClick({
    @required this.isChecked,
  }) : super([isChecked]);
  @override
  String toString() => 'CheckBoxClick';
}

class ScanButtonClick extends CreateExternalTenderEvent {
  @override
  String toString() {
    return 'ScanButtonClick';
  }
}

class OrderNumberScanEvent extends CreateExternalTenderEvent {
  @override
  String toString() {
    return "OrderNumberScanEvent";
  }
}

class PartNumberScanEvent extends CreateExternalTenderEvent {
  @override
  String toString() {
    return "PartNumberScanEvent";
  }
}

class ToolNumberScanEvent extends CreateExternalTenderEvent {
  @override
  String toString() {
    return "ToolNumberScanEvent";
  }
}

class RefNumberScanEvent extends CreateExternalTenderEvent {
  @override
  String toString() {
    return "RefNumberScanEvent";
  }
}

class TrackingNumberScanEvent extends CreateExternalTenderEvent {
  @override
  String toString() {
    return "TrackingNumberScanEvent";
  }
}

class FetchUserName extends CreateExternalTenderEvent {
  @override
  String toString() {
    return "FetchUserName";
  }
}

class FetchDeviceId extends CreateExternalTenderEvent {
  @override
  String toString() {
    return "FetchDeviceId";
  }
}
