import 'package:equatable/equatable.dart';

abstract class DeliveryConfigEvent extends Equatable {
  DeliveryConfigEvent([List props = const []]) : super(props);
}

class DepartClickAction extends DeliveryConfigEvent {
  @override
  String toString() {
    return "DepartClickAction";
  }
}

class ArriveClickAction extends DeliveryConfigEvent {
  @override
  String toString() {
    return "ArriveClickAction";
  }
}

class ResetDeliveryConfigEvent extends DeliveryConfigEvent {
  @override
  String toString() {
    return "ResetDeliveryConfigEvent";
  }
}
