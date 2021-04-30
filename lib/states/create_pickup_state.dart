import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/package_details_response.dart';

abstract class CreatePickUpState extends Equatable {
  CreatePickUpState([List props = const []]) : super(props);
}

class CreatePickUpInitial extends CreatePickUpState {
  CreatePickUpInitial([List props = const []]) : super(props);
}

class PickUpSiteResponseFetchSuccess extends CreatePickUpState {
  final List<LocationResponse> locationResponse;

  PickUpSiteResponseFetchSuccess({@required this.locationResponse})
      : super([locationResponse]);
  @override
  String toString() =>
      'PickUpSiteResponseFetchSuccess { LocationResponse: $locationResponse}';
}

class PickUpApiCallLoading extends CreatePickUpState {
  @override
  String toString() => 'PickUpApiCallLoading';
}

class PickUpSiteResponseFetchFailure extends CreatePickUpState {
  final String error;

  PickUpSiteResponseFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'PickUpSiteResponseFetchFailure { error: $error}';
}

class DeliverySiteResponseFetchSuccess extends CreatePickUpState {
  final List<LocationResponse> locationResponse;

  DeliverySiteResponseFetchSuccess({@required this.locationResponse})
      : super([locationResponse]);
  @override
  String toString() =>
      'DeliverySiteResponseFetchSuccess { LocationResponse: $locationResponse}';
}

class DeliverySiteApiCallLoading extends CreatePickUpState {
  @override
  String toString() => 'DestinationApiCallLoading';
}

class DeliverySiteResponseFetchFailure extends CreatePickUpState {
  final String error;

  DeliverySiteResponseFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'DestinationResponseFetchFailure { error: $error}';
}

class LocationResponseFetchSuccess extends CreatePickUpState {
  final List<LocationResponse> locationResponse;

  LocationResponseFetchSuccess({@required this.locationResponse})
      : super([locationResponse]);
  @override
  String toString() =>
      'LocationResponseFetchSuccess { LocationResponse: $locationResponse}';
}

class LocationApiCallLoading extends CreatePickUpState {
  @override
  String toString() => 'PickUpApiCallLoading';
}

class LocationResponseFetchFailure extends CreatePickUpState {
  final String error;

  LocationResponseFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'LocationResponseFetchFailure { error: $error}';
}

class DestinationResponseFetchSuccess extends CreatePickUpState {
  final List<LocationResponse> locationResponse;

  DestinationResponseFetchSuccess({@required this.locationResponse})
      : super([locationResponse]);
  @override
  String toString() =>
      'DestinationResponseFetchSuccess { LocationResponse: $locationResponse}';
}

class DestinationApiCallLoading extends CreatePickUpState {
  @override
  String toString() => 'DestinationApiCallLoading';
}

class DestinationResponseFetchFailure extends CreatePickUpState {
  final String error;

  DestinationResponseFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'DestinationResponseFetchFailure { error: $error}';
}

class CheckBoxChecked extends CreatePickUpState {
  @override
  String toString() => 'CheckBoxChecked';
}

class CheckBoxUnChecked extends CreatePickUpState {
  @override
  String toString() => 'CheckBoxUnChecked';
}

class PickUpExternalSaved extends CreatePickUpState {
  final String message;
  PickUpExternalSaved({@required this.message}) : super([message]);
  @override
  String toString() => 'PickUpExternalSaved : $message';
}

class PickUpPartsSaved extends CreatePickUpState {
  final String message;
  PickUpPartsSaved({@required this.message}) : super([message]);
  @override
  String toString() => 'PickUpPartsSaved : $message';
}

class PickUpPartsSaveFailure extends CreatePickUpState {
  final String error;
  PickUpPartsSaveFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'PickUpPartsSaveFailure : $error';
}

class PickUpExternalSaveFailure extends CreatePickUpState {
  final String error;
  PickUpExternalSaveFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'PickUpPartsSaveFailure : $error';
}

class TransactionLoading extends CreatePickUpState {
  @override
  String toString() {
    return "TransactionLoading";
  }
}

class ScanSuccess extends CreatePickUpState {
  final String barCode;

  ScanSuccess({@required this.barCode}) : super([barCode]);
  @override
  String toString() {
    return 'ScanSuccess { barCode: $barCode}';
  }
}

class ScanFailure extends CreatePickUpState {
  final String error;

  ScanFailure({@required this.error}) : super([error]);
  @override
  String toString() {
    return 'ScanFailure { error: $error}';
  }
}

class PackageDetailsResponseFetchSuccess extends CreatePickUpState {
  final List<PackageDetailsResponse> packageDetailsResponse;

  PackageDetailsResponseFetchSuccess({@required this.packageDetailsResponse})
      : super([packageDetailsResponse]);
  @override
  String toString() =>
      'PackageDetailsResponseFetchSuccess { PackageDetailsResponse: $packageDetailsResponse}';
}

class PackageDetailsApiCallLoading extends CreatePickUpState {
  @override
  String toString() => 'PackageDetailsApiCallLoading';
}

class PackageDetailsResponseFetchFailure extends CreatePickUpState {
  final String error;

  PackageDetailsResponseFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'PackageDetailsResponseFetchFailure { error: $error}';
}

class TrackingNumberScanSuccess extends CreatePickUpState {
  final String barCode;
  TrackingNumberScanSuccess({@required this.barCode});
  @override
  String toString() {
    return "TrackingNumberScanSuccess";
  }
}

class OrderNumberScanSuccess extends CreatePickUpState {
  final String barCode;
  OrderNumberScanSuccess({@required this.barCode});
  @override
  String toString() {
    return "OrderNumberScanSuccess";
  }
}

class PartNumberScanSuccess extends CreatePickUpState {
  final String barCode;
  PartNumberScanSuccess({@required this.barCode});
  @override
  String toString() {
    return "OrderNumberScanSuccess";
  }
}

class ScanOptionFailure extends CreatePickUpState {
  final String error;
  ScanOptionFailure({@required this.error});
  @override
  String toString() {
    return "ScanOptionFailure : $error";
  }
}

class FetchDeviceIdSuccess extends CreatePickUpState {
  final String deviceId;
  FetchDeviceIdSuccess({@required this.deviceId}) : super([deviceId]);
  @override
  String toString() {
    return "FetchDeviceIdSuccess";
  }
}

class UserNameFetchSuccess extends CreatePickUpState {
  final String userName;
  final String token;
  UserNameFetchSuccess({@required this.userName, @required this.token})
      : super([userName, token]);
  @override
  String toString() =>
      'UserNameFetchSuccess { UserNameFetchSuccess: $userName}';
}

class UserNameFetchFailure extends CreatePickUpState {
  final String error;

  UserNameFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'UserNameFetchFailure { error: $error}';
}

class AddToListExternalSuccess extends CreatePickUpState {
  @override
  String toString() {
    return "AddToExternalSuccess";
  }
}

class AddToListPartSuccess extends CreatePickUpState {
  @override
  String toString() {
    return "AddToListPartSuccess";
  }
}
