import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/models/settings_db.dart';

abstract class SettingsEvent extends Equatable {
  SettingsEvent([List props = const []]) : super(props);
}

class TabsClick extends SettingsEvent {
  @override
  String toString() {
    return "TabsClick";
  }
}

class ServerClick extends SettingsEvent {
  @override
  String toString() {
    return "ServerClick";
  }
}

class LocationClick extends SettingsEvent {
  @override
  String toString() {
    return "LocationClick";
  }
}

class FetchUser extends SettingsEvent {
  @override
  String toString() {
    return "FetchUser";
  }
}

class FetchSettings extends SettingsEvent {
  final String userName;
  FetchSettings({@required this.userName}) : super([userName]);
  @override
  String toString() {
    return "FetchSettings";
  }
}

class TenderModeClick extends SettingsEvent {
  final SettingsResponse settingsResponse;
  TenderModeClick({@required this.settingsResponse})
      : super([settingsResponse]);
  @override
  String toString() {
    return "TenderModeClick";
  }
}

class PickUpOnTenderClick extends SettingsEvent {
  final SettingsResponse settingsResponse;
  PickUpOnTenderClick({@required this.settingsResponse})
      : super([settingsResponse]);
  @override
  String toString() {
    return "PickUpOnTenderClick";
  }
}

class DriverModeClick extends SettingsEvent {
  final SettingsResponse settingsResponse;
  DriverModeClick({@required this.settingsResponse})
      : super([settingsResponse]);
  @override
  String toString() {
    return "DriverModeClick";
  }
}

class FetchAllDisciplineConfigValues extends SettingsEvent {
  @override
  String toString() {
    return "FetchAllDisciplineConfigValues";
  }
}

class ResetSettingEvent extends SettingsEvent {
  @override
  String toString() {
    return "ResetSettingEvent";
  }
}

class PriorityFetch extends SettingsEvent {
  @override
  String toString() {
    return "PriorityFetch";
  }
}

class LocationFetch extends SettingsEvent {
  @override
  String toString() {
    return "LocationFetch";
  }
}
