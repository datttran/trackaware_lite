import 'package:equatable/equatable.dart';

abstract class ScanOptionEvent extends Equatable {
  ScanOptionEvent([List props = const []]) : super(props);
}

class OrderNumberScanEvent extends ScanOptionEvent {
  @override
  String toString() {
    return "OrderNumberScanEvent";
  }
}

class PartNumberScanEvent extends ScanOptionEvent {
  @override
  String toString() {
    return "PartNumberScanEvent";
  }
}

class ToolNumberScanEvent extends ScanOptionEvent {
  @override
  String toString() {
    return "ToolNumberScanEvent";
  }
}

class RefNumberScanEvent extends ScanOptionEvent {
  @override
  String toString() {
    return "RefNumberScanEvent";
  }
}

class TrackingNumberScanEvent extends ScanOptionEvent {
  @override
  String toString() {
    return "TrackingNumberScanEvent";
  }
}
