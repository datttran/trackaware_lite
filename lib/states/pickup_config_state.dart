import 'package:equatable/equatable.dart';

abstract class PickUpConfigState extends Equatable {
  PickUpConfigState([List props = const []]) : super(props);
}

class PickUpConfigInitial extends PickUpConfigState {
  @override
  String toString() {
    return "PickUpConfigInitial";
  }
}

class NavigateToPickUpProductionPartsConfig extends PickUpConfigState {
  @override
  String toString() {
    return "NavigateToPickUpProductionPartsConfig";
  }
}

class NavigateToPickUpExternalPackagesConfig extends PickUpConfigState {
  @override
  String toString() {
    return "NavigateToPickUpExternalPackagesConfig";
  }
}

class ResetPickUpConfig extends PickUpConfigState {
  @override
  String toString() {
    return "ResetPickUpConfig";
  }
}
