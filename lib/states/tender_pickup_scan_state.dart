import 'package:equatable/equatable.dart';

abstract class TenderPickUpScanState extends Equatable {
  TenderPickUpScanState([List props = const []]) : super(props);
}

class TenderPickUpScanInitial extends TenderPickUpScanState {
  @override
  String toString() {
    return "TenderPickUpScanInitial";
  }
}

class NavigateToTenderProductionPartsScan extends TenderPickUpScanState {
  @override
  String toString() {
    return "NavigateToTenderProductionPartsScan";
  }
}

class NavigateToTenderExternalPackagesScan extends TenderPickUpScanState {
  @override
  String toString() {
    return "NavigateToTenderExternalPackagesScan";
  }
}

class NavigateToPickUpProductionPartsScan extends TenderPickUpScanState {
  @override
  String toString() {
    return "NavigateToPickUpProductionPartsScan";
  }
}

class NavigateToPickUpExternalPackagesScan extends TenderPickUpScanState {
  @override
  String toString() {
    return "NavigateToPickUpExternalPackagesScan";
  }
}
