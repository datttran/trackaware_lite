import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/models/tender_external_db.dart';
import 'package:trackaware_lite/models/tender_parts_db.dart';

abstract class ListExternalTenderState extends Equatable {
  ListExternalTenderState([List props = const []]) : super(props);
}

class ListExternalTenderInitial extends ListExternalTenderState {
  ListExternalTenderInitial([List props = const []]) : super(props);
}

class LoadExternalTenderList extends ListExternalTenderState {
  @override
  String toString() => 'LoadExternalTenderList';
}

class ExternalTenderListFetchSuccess extends ListExternalTenderState {
  final List<TenderExternal> tenderExternalResponse;

  ExternalTenderListFetchSuccess({@required this.tenderExternalResponse})
      : super([tenderExternalResponse]);
  @override
  String toString() =>
      'ExternalTenderListFetchSuccess { ExternalTenderListResponse: $tenderExternalResponse}';
}

class ExternalTenderListFetchFailure extends ListExternalTenderState {
  final String error;

  ExternalTenderListFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'ExternalTenderListFetchFailure { error: $error}';
}

class TenderPartsListFetchSuccess extends ListExternalTenderState {
  final List<TenderParts> tenderPartsResponse;

  TenderPartsListFetchSuccess({@required this.tenderPartsResponse})
      : super([tenderPartsResponse]);

  @override
  String toString() =>
      'TenderPartsListFetchSuccess { TenderListResponse: $tenderPartsResponse}';
}

class TenderPartsListFetchFailure extends ListExternalTenderState {
  final String error;

  TenderPartsListFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'TenderPartsListFetchFailure { error: $error}';
}

class ScanSuccess extends ListExternalTenderState {
  final int scanCount;
  ScanSuccess({@required this.scanCount});
  @override
  String toString() {
    return "ScanSuccess";
  }
}

class ScanFailure extends ListExternalTenderState {
  @override
  String toString() {
    return "ScanFailure";
  }
}

class TransactionLoading extends ListExternalTenderState {
  @override
  String toString() => 'TransactionLoading';
}

class TenderExternalSaved extends ListExternalTenderState {
  final String message;
  TenderExternalSaved({@required this.message}) : super([message]);
  @override
  String toString() => 'TenderExternalSaved - $message';
}

class TenderExternalFailure extends ListExternalTenderState {
  final String error;
  TenderExternalFailure({@required this.error}) : super([error]);
  @override
  String toString() {
    return "TenderExternalFailure - $error";
  }
}

class UserNameFetchSuccess extends ListExternalTenderState {
  final String userName;
  final String token;
  UserNameFetchSuccess({@required this.userName, @required this.token})
      : super([userName, token]);
  @override
  String toString() =>
      'UserNameFetchSuccess { UserNameFetchSuccess: $userName}';
}

class UserNameFetchFailure extends ListExternalTenderState {
  final String error;

  UserNameFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'UserNameFetchFailure { error: $error}';
}

class FetchDeviceIdSuccess extends ListExternalTenderState {
  final String deviceId;
  FetchDeviceIdSuccess({@required this.deviceId}) : super([deviceId]);
  @override
  String toString() {
    return "FetchDeviceIdSuccess";
  }
}

class TenderPartsSaved extends ListExternalTenderState {
  final String message;
  TenderPartsSaved({@required this.message}) : super([message]);
  @override
  String toString() => 'TenderPartsSaved - $message';
}

class TenderPartsFailure extends ListExternalTenderState {
  final String error;
  TenderPartsFailure({@required this.error}) : super([error]);
  @override
  String toString() {
    return "TenderPartsFailure - $error";
  }
}
