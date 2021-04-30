import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class PickupTabState extends Equatable {
  PickupTabState([List props = const []]) : super(props);
}

class PickupTabInitial extends PickupTabState {
  @override
  String toString() {
    return 'PickupTabInitial';
  }
}

class FetchExternalPickUpSuccess extends PickupTabState {
  final int count;
  FetchExternalPickUpSuccess({@required this.count});
  @override
  String toString() {
    return "FetchExternalPickUpSuccess";
  }
}

class FetchExternalPickUpFailure extends PickupTabState {
  final String message;
  FetchExternalPickUpFailure({@required this.message});
  @override
  String toString() {
    return "FetchExternalPickUpFailure";
  }
}

class FetchPickUpPartSuccess extends PickupTabState {
  final int count;
  FetchPickUpPartSuccess({@required this.count});
  @override
  String toString() {
    return "FetchPickUpPartSuccess";
  }
}

class FetchPickUpPartFailure extends PickupTabState {
  final String message;
  FetchPickUpPartFailure({@required this.message});
  @override
  String toString() {
    return "FetchPickUpPartFailure";
  }
}

class ResetState extends PickupTabState {
  @override
  String toString() {
    return "ResetState";
  }
}
