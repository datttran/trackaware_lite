import 'package:equatable/equatable.dart';

abstract class TabsConfigState extends Equatable {
  TabsConfigState([List props = const []]) : super(props);
}

class TabsConfigInitial extends TabsConfigState {
  @override
  String toString() {
    return "TabsConfigInitial";
  }
}

class NavigateToTenderConfig extends TabsConfigState {
  @override
  String toString() {
    return "NavigateToTenderConfig";
  }
}

class NavigateToPickUpConfig extends TabsConfigState {
  @override
  String toString() {
    return "NavigateToPickUpConfig";
  }
}

class NavigateToDeliveryConfig extends TabsConfigState {
  @override
  String toString() {
    return "NavigateToDeliveryConfig";
  }
}

class ResetState extends TabsConfigState {
  @override
  String toString() {
    return "ResetState";
  }
}
