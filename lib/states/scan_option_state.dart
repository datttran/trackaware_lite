import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ScanOptionState extends Equatable {
  ScanOptionState([List props = const []]) : super(props);
}

class ScanOptionInitial extends ScanOptionState {
  @override
  String toString() {
    return "ScanOptionInitial";
  }
}

class OrderNumberScanSuccess extends ScanOptionState {
  final String barCode;
  OrderNumberScanSuccess({@required this.barCode});
  @override
  String toString() {
    return "OrderNumberScanSuccess BarCode : $barCode";
  }
}

class PartNumberScanSuccess extends ScanOptionState {
  final String barCode;
  PartNumberScanSuccess({@required this.barCode});
  @override
  String toString() {
    return super.toString();
  }
}

class ToolNumberScanSuccess extends ScanOptionState {
  final String barCode;
  ToolNumberScanSuccess({@required this.barCode});
  @override
  String toString() {
    return "ToolNumberScanSuccess";
  }
}

class RefNumberScanSuccess extends ScanOptionState {
  final String barCode;
  RefNumberScanSuccess({@required this.barCode});
  @override
  String toString() {
    return "RefNumberScanSuccess";
  }
}

class TrackingNumberScanSuccess extends ScanOptionState {
  final String barCode;
  TrackingNumberScanSuccess({@required this.barCode});
  @override
  String toString() {
    return "TrackingNumberScanSuccess";
  }
}

class ScanOptionFailure extends ScanOptionState {
  final String error;
  ScanOptionFailure({@required this.error});
  @override
  String toString() {
    return "ScanOptionFailure : $error";
  }
}
