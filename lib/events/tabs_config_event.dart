import 'package:equatable/equatable.dart';

abstract class TabsConfigEvent extends Equatable {
  TabsConfigEvent([List props = const []]) : super(props);
}

class TenderClickAction extends TabsConfigEvent {
  @override
  String toString() {
    return "TenderClickAction";
  }
}

class PickUpClickAction extends TabsConfigEvent {
  @override
  String toString() {
    return "PickUpClickAction";
  }
}

class DeliveryClickAction extends TabsConfigEvent {
  @override
  String toString() {
    return "DeliveryClickAction";
  }
}

class ResetEvent extends TabsConfigEvent {
  @override
  String toString() {
    return "ResetEvent";
  }
}
