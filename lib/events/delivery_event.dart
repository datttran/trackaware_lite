import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DeliveryEvent extends Equatable {
  DeliveryEvent([List props = const []]) : super(props);
}

class FetchLocation extends DeliveryEvent {
  @override
  String toString() {
    return "FetchLocation";
  }
}

class FetchDestinationList extends DeliveryEvent {
  final String location;
  FetchDestinationList({@required this.location});
  @override
  String toString() {
    return "FetchPickUpList";
  }
}

class NextButtonClick extends DeliveryEvent {
  @override
  String toString() {
    return "NextButtonClick";
  }
}

class ResetEvent extends DeliveryEvent {
  @override
  String toString() {
    return "ResetEvent";
  }
}

class CloseMsgEvent extends DeliveryEvent {
  final bool showMsg;
  CloseMsgEvent({@required this.showMsg});
  @override
  String toString() {
    return "CloseMsgEvent";
  }
}
