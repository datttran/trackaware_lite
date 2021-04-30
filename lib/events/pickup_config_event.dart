import 'package:equatable/equatable.dart';

abstract class PickUpConfigEvent extends Equatable {
  PickUpConfigEvent([List props = const []]) : super(props);
}

class PickUpProductionPartsClickAction extends PickUpConfigEvent {
  @override
  String toString() {
    return "PickUpProductionPartsClickAction";
  }
}

class PickUpExternalPackagesClickAction extends PickUpConfigEvent {
  @override
  @override
  String toString() {
    return "PickUpExternalPackagesClickAction";
  }
}

class ResetPickUpConfigEvent extends PickUpConfigEvent {
  @override
  String toString() {
    return "ResetPickUpConfigEvent";
  }
}
