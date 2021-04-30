import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/models/arrive_db.dart';
import 'package:trackaware_lite/models/depart_db.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';
import 'package:trackaware_lite/models/pickup_part_db.dart';
import 'package:trackaware_lite/models/priority_response.dart';
import 'package:trackaware_lite/models/settings_db.dart';
import 'package:trackaware_lite/models/tender_external_db.dart';
import 'package:trackaware_lite/models/tender_parts_db.dart';
import 'package:trackaware_lite/models/location_db.dart' as DbLocation;
import 'package:http/http.dart' as http;

abstract class LandingPageState extends Equatable {
  LandingPageState([List props = const []]) : super(props);
}

class LandingPageInitial extends LandingPageState {
  @override
  String toString() {
    return 'LandingPageInitial';
  }
}

class TenderTransactionRequestSuccess extends LandingPageState {
  final String message;

  TenderTransactionRequestSuccess({@required this.message}) : super([message]);
  @override
  String toString() {
    return 'TenderTransactionRequestSuccess { message: $message}';
  }
}

class TenderTransactionRequestFailure extends LandingPageState {
  final String error;

  TenderTransactionRequestFailure({@required this.error}) : super([error]);
  @override
  String toString() {
    return 'TenderTransactionRequestFailure { error: $error}';
  }
}

class TransactionLoading extends LandingPageState {
  @override
  String toString() => 'TransactionLoading';
}

class SyncLoading extends LandingPageState {
  @override
  String toString() => 'SyncLoading';
}

class ScanSuccess extends LandingPageState {
  final String barCode;

  ScanSuccess({@required this.barCode}) : super([barCode]);
  @override
  String toString() {
    return 'ScanSuccess { barCode: $barCode}';
  }
}

class ScanFailure extends LandingPageState {
  final String error;

  ScanFailure({@required this.error}) : super([error]);
  @override
  String toString() {
    return 'ScanFailure { error: $error}';
  }
}

class ExternalTenderListFetchSuccess extends LandingPageState {
  final List<TenderExternal> tenderExternalResponse;

  ExternalTenderListFetchSuccess({@required this.tenderExternalResponse})
      : super([tenderExternalResponse]);
  @override
  String toString() =>
      'ExternalTenderListFetchSuccess { ExternalTenderListResponse: $tenderExternalResponse}';
}

class ExternalTenderListFetchFailure extends LandingPageState {
  final String error;

  ExternalTenderListFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'ExternalTenderListFetchFailure { error: $error}';
}

class TenderPartsListFetchSuccess extends LandingPageState {
  final List<TenderParts> tenderPartsResponse;

  TenderPartsListFetchSuccess({@required this.tenderPartsResponse})
      : super([tenderPartsResponse]);
  @override
  String toString() =>
      'TenderPartsListFetchSuccess { TenderPartsListResponse: $tenderPartsResponse}';
}

class TenderPartsListFetchFailure extends LandingPageState {
  final String error;

  TenderPartsListFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'TenderPartsListFetchFailure { error: $error}';
}

class UserNameFetchSuccess extends LandingPageState {
  final String userName;
  final String token;
  UserNameFetchSuccess({@required this.userName, @required this.token})
      : super([userName, token]);
  @override
  String toString() =>
      'UserNameFetchSuccess { UserNameFetchSuccess: $userName}';
}

class UserNameFetchFailure extends LandingPageState {
  final String error;

  UserNameFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'UserNameFetchFailure { error: $error}';
}

class PickUpPartsListFetchSuccess extends LandingPageState {
  final List<PickUpPart> pickUpPartsResponse;

  PickUpPartsListFetchSuccess({@required this.pickUpPartsResponse})
      : super([pickUpPartsResponse]);
  @override
  String toString() =>
      'PickUpPartsListFetchSuccess { PickUpPartsListFetchSuccess: $pickUpPartsResponse}';
}

class PickUpPartsListFetchFailure extends LandingPageState {
  final String error;

  PickUpPartsListFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'PickUpPartsListFetchFailure { error: $error}';
}

class PickUpExternalListFetchSuccess extends LandingPageState {
  final List<PickUpExternal> pickUpExternalResponse;

  PickUpExternalListFetchSuccess({@required this.pickUpExternalResponse})
      : super([pickUpExternalResponse]);
  @override
  String toString() =>
      'PickUpExternalListFetchSuccess { PickUpExternalListFetchSuccess: $pickUpExternalResponse}';
}

class PickUpExternalListFetchFailure extends LandingPageState {
  final String error;

  PickUpExternalListFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'PickUpExternalListFetchFailure { error: $error}';
}

class ArriveListItemsFetchSuccess extends LandingPageState {
  final List<Arrive> arriveResponse;

  ArriveListItemsFetchSuccess({@required this.arriveResponse})
      : super([arriveResponse]);
  @override
  String toString() =>
      'ArriveListFetchSuccess { ArriveListFetchSuccess: $arriveResponse}';
}

class ArriveListItemsFetchFailure extends LandingPageState {
  final String error;

  ArriveListItemsFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'ArriveListFetchFailure { error: $error}';
}

class DepartListItemsFetchSuccess extends LandingPageState {
  final List<Depart> departResponse;

  DepartListItemsFetchSuccess({@required this.departResponse})
      : super([departResponse]);
  @override
  String toString() =>
      'DeliveryListItemsFetchSuccess { DepartListFetchSuccess: $departResponse}';
}

class DepartListItemsFetchFailure extends LandingPageState {
  final String error;

  DepartListItemsFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'DepartListItemsFetchFailure { error: $error}';
}

class DeliveryRequestSuccess extends LandingPageState {
  final String message;

  DeliveryRequestSuccess({@required this.message}) : super([message]);
  @override
  String toString() {
    return 'DeliveryRequestSuccess { message: $message}';
  }
}

class DeliveryRequestFailure extends LandingPageState {
  final String error;

  DeliveryRequestFailure({@required this.error}) : super([error]);
  @override
  String toString() {
    return 'DeliveryRequestFailure { error: $error}';
  }
}

class DeliveryLoading extends LandingPageState {
  @override
  String toString() => 'DeliveryLoading';
}

class PermissionStatusResult extends LandingPageState {
  final bool isPermissionEnabled;
  PermissionStatusResult({@required this.isPermissionEnabled})
      : super([isPermissionEnabled]);
  @override
  String toString() {
    return super.toString();
  }
}

class LocationServiceStatus extends LandingPageState {
  final bool isLocationServiceEnabled;
  LocationServiceStatus({@required this.isLocationServiceEnabled})
      : super([isLocationServiceEnabled]);
  @override
  String toString() {
    return "LocationServiceStatus";
  }
}

class LocationSettingsChangeSuccess extends LandingPageState {
  @override
  String toString() {
    return "LocationSettingsChangeSuccess";
  }
}

class LocationSettingsChangeFailure extends LandingPageState {
  @override
  String toString() {
    return "LocationSettingsChangeFailure";
  }
}

class FetchLocationSuccess extends LandingPageState {
  final List<DbLocation.Location> locationList;
  FetchLocationSuccess({@required this.locationList}) : super([locationList]);
  @override
  String toString() => 'FetchLocationSuccess { locationList: $locationList}';
}

class FetchLocationFailure extends LandingPageState {
  final String error;
  FetchLocationFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'FetchLocationFailure { error: $error}';
}

class LocationRequestSuccess extends LandingPageState {
  final String message;

  LocationRequestSuccess({@required this.message}) : super([message]);
  @override
  String toString() {
    return 'LocationRequestSuccess { message: $message}';
  }
}

class LocationRequestFailure extends LandingPageState {
  final String error;

  LocationRequestFailure({@required this.error}) : super([error]);
  @override
  String toString() {
    return 'LocationRequestFailure { error: $error}';
  }
}

class LocationLoading extends LandingPageState {
  @override
  String toString() => 'LocationLoading';
}

class FetchDeviceIdSuccess extends LandingPageState {
  final String deviceId;
  FetchDeviceIdSuccess({@required this.deviceId}) : super([deviceId]);
  @override
  String toString() {
    return "FetchDeviceIdSuccess";
  }
}

class FetchSettingsSuccess extends LandingPageState {
  final List<SettingsResponse> settings;
  FetchSettingsSuccess({@required this.settings}) : super([settings]);
  @override
  String toString() {
    return "FetchSettingsSuccess";
  }
}

class ProfileImageClickActionSuccess extends LandingPageState {
  @override
  String toString() {
    return "ProfileImageClickActionSuccess";
  }
}

class PriorityResponseFetchSuccess extends LandingPageState {
  final List<PriorityResponse> priorityResponse;

  PriorityResponseFetchSuccess({@required this.priorityResponse})
      : super([priorityResponse]);
  @override
  String toString() =>
      'PriorityResponseFetchSuccess { PriorityResponse: $priorityResponse}';
}

class PriorityResponseFetchFailure extends LandingPageState {
  final String error;

  PriorityResponseFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'PriorityResponseFetchFailure { error: $error}';
}

class LocationResponseFetchSuccess extends LandingPageState {
  final List<LocationResponse> locationResponse;

  LocationResponseFetchSuccess({@required this.locationResponse})
      : super([locationResponse]);
  @override
  String toString() =>
      'LocationResponseFetchSuccess { LocationResponse: $locationResponse}';
}

class LocationResponseFetchFailure extends LandingPageState {
  final String error;

  LocationResponseFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'LocationResponseFetchFailure { error: $error}';
}

class UpdatePickUpItemSuccess extends LandingPageState {
  @override
  String toString() {
    return "UpdatePickUpItemSuccess";
  }
}

class UpdatePickUpItemFailure extends LandingPageState {
  final String error;

  UpdatePickUpItemFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'UpdatePickUpItemFailure { error: $error}';
}

class FetchUserProfileImageSuccess extends LandingPageState {
  final http.Response response;
  FetchUserProfileImageSuccess({@required this.response}) : super([response]);
  @override
  String toString() {
    return "FetchUserProfileImageSuccess - $response";
  }
}

class FetchUserProfileImageFailure extends LandingPageState {
  final String error;
  FetchUserProfileImageFailure({@required this.error}) : super([error]);
  @override
  String toString() {
    return "FetchUserProfileImageFailure - $error";
  }
}

class ResetState extends LandingPageState {
  @override
  String toString() {
    return "ResetState";
  }
}

class ShowScan extends LandingPageState {
  @override
  String toString() {
    return "ShowScan";
  }
}

class HideScan extends LandingPageState {
  @override
  String toString() {
    return "HideScan";
  }
}
