import 'package:equatable/equatable.dart';

abstract class DeliveryConfigState extends Equatable {
  DeliveryConfigState([List props = const []]) : super(props);
}

class DeliveryConfigInitial extends DeliveryConfigState {
  @override
  String toString() {
    return "DeliveryConfigInitial";
  }
}

class NavigateToDepartConfig extends DeliveryConfigState {
  @override
  String toString() {
    return "NavigateToDepartConfig";
  }
}

class NavigateToArriveConfig extends DeliveryConfigState {
  @override
  String toString() {
    return "NavigateToArriveConfig";
  }
}

class ResetDeliveryConfig extends DeliveryConfigState {
  @override
  String toString() {
    return "ResetDeliveryConfig";
  }
}
