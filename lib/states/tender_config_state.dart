import 'package:equatable/equatable.dart';

abstract class TenderConfigState extends Equatable {
  TenderConfigState([List props = const []]) : super(props);
}

class TenderConfigInitial extends TenderConfigState {
  @override
  String toString() {
    return "TenderConfigInitial";
  }
}

class NavigateToTenderProductionPartsConfig extends TenderConfigState {
  @override
  String toString() {
    return "NavigateToTenderProductionPartsConfig";
  }
}

class NavigateToTenderExternalPackagesConfig extends TenderConfigState {
  @override
  String toString() {
    return "NavigateToTenderExternalPackagesConfig";
  }
}

class ResetTenderConfig extends TenderConfigState {
  @override
  String toString() {
    return "ResetTenderConfig";
  }
}
