import 'package:equatable/equatable.dart';

abstract class TenderConfigEvent extends Equatable {
  TenderConfigEvent([List props = const []]) : super(props);
}

class TenderProductionPartsClickAction extends TenderConfigEvent {
  @override
  String toString() {
    return "TenderProductionPartsClickAction";
  }
}

class TenderExternalPackagesClickAction extends TenderConfigEvent {
  @override
  String toString() {
    return "TenderExternalPackagesClickAction";
  }
}

class ResetTenderConfigEvent extends TenderConfigEvent {
  @override
  String toString() {
    return "ResetTenderConfigEvent";
  }
}
