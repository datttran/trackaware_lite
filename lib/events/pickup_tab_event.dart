import 'package:equatable/equatable.dart';

abstract class PickupTabEvent extends Equatable {
  PickupTabEvent([List props = const []]) : super(props);
}

class FetchPickUpExternalCount extends PickupTabEvent {
  @override
  String toString() {
    return "FetchPickUpExternalCount";
  }
}

class FetchPickUpPartsCount extends PickupTabEvent {
  @override
  String toString() {
    return "FetchPickUpPartsCount";
  }
}

class ResetEvent extends PickupTabEvent {
  @override
  String toString() {
    return "ResetEvent";
  }
}
