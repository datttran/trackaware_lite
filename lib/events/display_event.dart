import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DisplayConfigEvent extends Equatable {
  DisplayConfigEvent([List props = const []]) : super(props);
}

class SaveDisplayConfigEvent extends DisplayConfigEvent {
  final String keyName;
  final String disciplineConfigValue;
  SaveDisplayConfigEvent(
      {@required this.keyName, @required this.disciplineConfigValue})
      : super([keyName, disciplineConfigValue]);
  @override
  String toString() {
    return "SaveDisplayConfigEvent";
  }
}

class FetchDisplayConfig extends DisplayConfigEvent {
  final String keyName;
  FetchDisplayConfig({@required this.keyName}) : super([keyName]);
  @override
  String toString() {
    return "FetchDisplayConfig";
  }
}

class ResetDisplayConfigEvent extends DisplayConfigEvent {
  @override
  String toString() {
    return "ResetDisplayConfigEvent";
  }
}
