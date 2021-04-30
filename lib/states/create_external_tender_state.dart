import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/priority_response.dart';

abstract class CreateExternalTenderState extends Equatable {
  CreateExternalTenderState([List props = const []]) : super(props);
}

class CreateExternalTenderInitial extends CreateExternalTenderState {
  CreateExternalTenderInitial([List props = const []]) : super(props);
  @override
  String toString() {
    return "CreateExternalTenderInitial";
  }
}

class PriorityResponseFetchSuccess extends CreateExternalTenderState {
  final List<PriorityResponse> priorityResponse;

  PriorityResponseFetchSuccess({@required this.priorityResponse})
      : super([priorityResponse]);
  @override
  String toString() =>
      'PriorityResponseFetchSuccess { PriorityResponse: $priorityResponse}';
}

class PriorityApiCallLoading extends CreateExternalTenderState {
  @override
  String toString() => 'PriorityApiCallLoading';
}

class PriorityResponseFetchFailure extends CreateExternalTenderState {
  final String error;

  PriorityResponseFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'PriorityResponseFetchFailure { error: $error}';
}

class LocationResponseFetchSuccess extends CreateExternalTenderState {
  final List<LocationResponse> locationResponse;

  LocationResponseFetchSuccess({@required this.locationResponse})
      : super([locationResponse]);
  @override
  String toString() =>
      'LocationResponseFetchSuccess { LocationResponse: $locationResponse}';
}

class LocationApiCallLoading extends CreateExternalTenderState {
  @override
  String toString() => 'LocationApiCallLoading';
}

class TransactionLoading extends CreateExternalTenderState {
  @override
  String toString() => 'TransactionLoading';
}

class LocationResponseFetchFailure extends CreateExternalTenderState {
  final String error;

  LocationResponseFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'LocationResponseFetchFailure { error: $error}';
}

class DestinationResponseFetchSuccess extends CreateExternalTenderState {
  final List<LocationResponse> locationResponse;

  DestinationResponseFetchSuccess({@required this.locationResponse})
      : super([locationResponse]);
  @override
  String toString() =>
      'DestinationResponseFetchSuccess { LocationResponse: $locationResponse}';
}

class DestinationApiCallLoading extends CreateExternalTenderState {
  @override
  String toString() => 'DestinationApiCallLoading';
}

class DestinationResponseFetchFailure extends CreateExternalTenderState {
  final String error;

  DestinationResponseFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'DestinationResponseFetchFailure { error: $error}';
}

class CheckBoxChecked extends CreateExternalTenderState {
  @override
  String toString() => 'CheckBoxChecked';
}

class CheckBoxUnChecked extends CreateExternalTenderState {
  @override
  String toString() => 'CheckBoxUnChecked';
}

class TenderPartsSaved extends CreateExternalTenderState {
  final String message;
  TenderPartsSaved({@required this.message}) : super([message]);
  @override
  String toString() => 'TenderPartsSaved - $message';
}

class TenderPartsFailure extends CreateExternalTenderState {
  final String error;
  TenderPartsFailure({@required this.error}) : super([error]);
  @override
  String toString() {
    return "TenderPartsFailure - $error";
  }
}

class TenderExternalSaved extends CreateExternalTenderState {
  final String message;
  TenderExternalSaved({@required this.message}) : super([message]);
  @override
  String toString() => 'TenderExternalSaved - $message';
}

class TenderExternalFailure extends CreateExternalTenderState {
  final String error;
  TenderExternalFailure({@required this.error}) : super([error]);
  @override
  String toString() {
    return "TenderExternalFailure - $error";
  }
}

class ScanSuccess extends CreateExternalTenderState {
  final String barCode;

  ScanSuccess({@required this.barCode}) : super([barCode]);
  @override
  String toString() {
    return 'ScanSuccess { barCode: $barCode}';
  }
}

class ScanFailure extends CreateExternalTenderState {
  final String error;

  ScanFailure({@required this.error}) : super([error]);
  @override
  String toString() {
    return 'ScanFailure { error: $error}';
  }
}

class OrderNumberScanSuccess extends CreateExternalTenderState {
  final String barCode;
  OrderNumberScanSuccess({@required this.barCode});
  @override
  String toString() {
    return "OrderNumberScanSuccess BarCode : $barCode";
  }
}

class PartNumberScanSuccess extends CreateExternalTenderState {
  final String barCode;
  PartNumberScanSuccess({@required this.barCode});
  @override
  String toString() {
    return super.toString();
  }
}

class ToolNumberScanSuccess extends CreateExternalTenderState {
  final String barCode;
  ToolNumberScanSuccess({@required this.barCode});
  @override
  String toString() {
    return "ToolNumberScanSuccess";
  }
}

class RefNumberScanSuccess extends CreateExternalTenderState {
  final String barCode;
  RefNumberScanSuccess({@required this.barCode});
  @override
  String toString() {
    return "RefNumberScanSuccess";
  }
}

class TrackingNumberScanSuccess extends CreateExternalTenderState {
  final String barCode;
  TrackingNumberScanSuccess({@required this.barCode});
  @override
  String toString() {
    return "TrackingNumberScanSuccess";
  }
}

class ScanOptionFailure extends CreateExternalTenderState {
  final String error;
  ScanOptionFailure({@required this.error});
  @override
  String toString() {
    return "ScanOptionFailure : $error";
  }
}

class InitPriorityResponseFetchSuccess extends CreateExternalTenderState {
  final List<PriorityResponse> priorityResponse;

  InitPriorityResponseFetchSuccess({@required this.priorityResponse})
      : super([priorityResponse]);
  @override
  String toString() =>
      'InitPriorityResponseFetchSuccess { PriorityResponse: $priorityResponse}';
}

class InitPriorityResponseFetchFailure extends CreateExternalTenderState {
  final String error;

  InitPriorityResponseFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'InitPriorityResponseFetchFailure { error: $error}';
}

class FetchDeviceIdSuccess extends CreateExternalTenderState {
  final String deviceId;
  FetchDeviceIdSuccess({@required this.deviceId}) : super([deviceId]);
  @override
  String toString() {
    return "FetchDeviceIdSuccess";
  }
}

class UserNameFetchSuccess extends CreateExternalTenderState {
  final String userName;
  final String token;
  UserNameFetchSuccess({@required this.userName, @required this.token})
      : super([userName, token]);
  @override
  String toString() =>
      'UserNameFetchSuccess { UserNameFetchSuccess: $userName}';
}

class UserNameFetchFailure extends CreateExternalTenderState {
  final String error;

  UserNameFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'UserNameFetchFailure { error: $error}';
}

class AddToListExternalSuccess extends CreateExternalTenderState {
  @override
  String toString() {
    return "AddToExternalSuccess";
  }
}

class AddToListPartSuccess extends CreateExternalTenderState {
  @override
  String toString() {
    return "AddToListPartSuccess";
  }
}
