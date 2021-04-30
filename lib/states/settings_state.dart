import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/priority_response.dart';
import 'package:trackaware_lite/models/settings_db.dart';
import 'package:trackaware_lite/models/user_db.dart';

abstract class SettingsState extends Equatable {
  SettingsState([List props = const []]) : super(props);
}

class SettingInitial extends SettingsState {
  @override
  String toString() => 'SettingInitial';
}

class DisplayTabs extends SettingsState {
  @override
  String toString() => 'DisplayTabs';
}

class DisplayLocation extends SettingsState {
  @override
  String toString() => 'DisplayLocation';
}

class FetchUserSuccess extends SettingsState {
  final List<User> users;
  FetchUserSuccess({@required this.users}) : super([users]);
  @override
  String toString() {
    return "FetchUserSuccess";
  }
}

class FetchSettingsSuccess extends SettingsState {
  final List<SettingsResponse> settings;
  FetchSettingsSuccess({@required this.settings}) : super([settings]);
  @override
  String toString() {
    return "FetchSettingsSuccess";
  }
}

class TenderModeSuccess extends SettingsState {
  @override
  String toString() {
    return "TenderModeSuccess";
  }
}

class DriverModeSuccess extends SettingsState {
  @override
  String toString() {
    return "DriverModeSuccess";
  }
}

class PickUpOnTenderSuccess extends SettingsState {
  @override
  String toString() {
    return "PickUpOnTenderSuccess";
  }
}

class ServerClickSuccess extends SettingsState {
  @override
  String toString() {
    return "ServerClickSuccess";
  }
}

class ResetSettingState extends SettingsState {
  @override
  String toString() {
    return "ResetSettingState";
  }
}

class LocationResponseFetchSuccess extends SettingsState {
  final List<LocationResponse> locationResponse;

  LocationResponseFetchSuccess({@required this.locationResponse})
      : super([locationResponse]);
  @override
  String toString() =>
      'LocationResponseFetchSuccess { LocationResponse: $locationResponse}';
}

class LocationResponseFetchFailure extends SettingsState {
  final String error;

  LocationResponseFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'LocationResponseFetchFailure { error: $error}';
}

class PriorityResponseFetchSuccess extends SettingsState {
  final List<PriorityResponse> priorityResponse;

  PriorityResponseFetchSuccess({@required this.priorityResponse})
      : super([priorityResponse]);
  @override
  String toString() =>
      'PriorityResponseFetchSuccess { PriorityResponse: $priorityResponse}';
}

class PriorityResponseFetchFailure extends SettingsState {
  final String error;

  PriorityResponseFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'PriorityResponseFetchFailure { error: $error}';
}

class SettingsLoading extends SettingsState {
  @override
  String toString() => 'TransactionLoading';
}
