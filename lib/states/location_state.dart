import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/models/location_db.dart';

abstract class LocationState extends Equatable{
  LocationState([List props = const []]) : super(props);
}

class LocationInitial extends LocationState{
  @override
  String toString() =>'LocationInitial';
}

class LocationSaveSuccess extends LocationState{
  @override
  String toString() => "LocationSaveSuccess";
}

class LocationSaveFailure extends LocationState{
  @override
  String toString() => "LocationSaveFailure";
}

class FetchLocationSuccess extends LocationState{
  final List<Location> locationList;
  FetchLocationSuccess({@required this.locationList}) : super([locationList]);
  @override
  String toString() => 'FetchLocationSuccess { locationList: $locationList}';
}

class FetchLocationFailure extends LocationState{
  final String error;
  FetchLocationFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'FetchLocationFailure { error: $error}';
}