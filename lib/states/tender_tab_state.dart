import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class TenderTabState extends Equatable {
  TenderTabState([List props = const []]) : super(props);
}

class TenderTabInitial extends TenderTabState {
  @override
  String toString() {
    return 'TenderTabInitial';
  }
}

class FetchExternalTenderSuccess extends TenderTabState {
  final int count;
  FetchExternalTenderSuccess({@required this.count});
  @override
  String toString() {
    return "FetchExternalTenderSuccess";
  }
}

class FetchExternalTenderFailure extends TenderTabState {
  final String message;
  FetchExternalTenderFailure({@required this.message});
  @override
  String toString() {
    return "FetchExternalTenderFailure";
  }
}

class FetchTenderPartSuccess extends TenderTabState {
  final int count;
  FetchTenderPartSuccess({@required this.count});
  @override
  String toString() {
    return "FetchTenderPartSuccess";
  }
}

class FetchTenderPartFailure extends TenderTabState {
  final String message;
  FetchTenderPartFailure({@required this.message});
  @override
  String toString() {
    return "FetchTenderPartFailure";
  }
}

class ResetState extends TenderTabState {
  @override
  String toString() {
    return "ResetState";
  }
}
