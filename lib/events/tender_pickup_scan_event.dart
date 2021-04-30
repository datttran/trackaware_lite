import 'package:equatable/equatable.dart';

abstract class TenderPickUpScanEvent extends Equatable {
  TenderPickUpScanEvent([List props = const []]) : super(props);
}

class TenderProductionPartsEvent extends TenderPickUpScanEvent {
  @override
  String toString() {
    return "TenderProductionPartsEvent";
  }
}

class TenderExternalPackagesEvent extends TenderPickUpScanEvent {
  @override
  String toString() {
    return "TenderExternalPackagesEvent";
  }
}

class PickUpProductionPartsEvent extends TenderPickUpScanEvent {
  @override
  String toString() {
    return "PickUpProductionPartsEvent";
  }
}

class PickUpExternalPackagesEvent extends TenderPickUpScanEvent {
  @override
  String toString() {
    return "PickUpExternalPackagesEvent";
  }
}
