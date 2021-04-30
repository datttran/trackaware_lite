import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/models/settings_db.dart';

abstract class DisplayConfigState extends Equatable{
  DisplayConfigState([List props = const []]) : super(props);
}

class DisplayConfigInitial extends DisplayConfigState{
  @override
  String toString() {
    return "DisplayConfigInitial";
  }
}

class SaveDisplayConfigSuccess extends DisplayConfigState{
  @override
  String toString() {
    return "SaveDisplayConfigSuccess";
  }
}

class FetchDisplayConfigSuccess extends DisplayConfigState{
  final List<DisciplineConfigResponse> disciplineConfigValues;
  FetchDisplayConfigSuccess({@required this.disciplineConfigValues}): super([disciplineConfigValues]);
  @override
  String toString() {
    return "FetchDisplayConfigSuccess";
  }
}