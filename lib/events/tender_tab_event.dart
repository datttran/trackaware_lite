import 'package:equatable/equatable.dart';

abstract class TenderTabEvent extends Equatable {
  TenderTabEvent([List props = const []]) : super(props);
}

class FetchTenderExternalCount extends TenderTabEvent {
  @override
  String toString() {
    return "FetchTenderExternalCount";
  }
}

class FetchTenderPartsCount extends TenderTabEvent {
  @override
  String toString() {
    return "FetchTenderPartsCount";
  }
}

class ResetEvent extends TenderTabEvent {
  @override
  String toString() {
    return "ResetEvent";
  }
}
