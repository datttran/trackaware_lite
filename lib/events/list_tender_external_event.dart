import 'package:equatable/equatable.dart';
import 'package:trackaware_lite/models/transaction_request.dart';

abstract class ListExternalTenderEvent extends Equatable {
  ListExternalTenderEvent([List props = const []]) : super(props);
}

class ListExternalTenderItemsEvent extends ListExternalTenderEvent {
  @override
  String toString() {
    return "ListExternalTenderItemsEvent";
  }
}

class ListTenderPartItemsEvent extends ListExternalTenderEvent {
  @override
  String toString() {
    return "ListTenderPartItemsEvent";
  }
}

class ScanTenderPartEvent extends ListExternalTenderEvent {
  ScanTenderPartEvent();
  @override
  String toString() {
    return "ScanTenderPartEvent";
  }
}

class ScanTenderExternalEvent extends ListExternalTenderEvent {
  ScanTenderExternalEvent();
  @override
  String toString() {
    return "ScanTenderExternalEvent";
  }
}

class SendExternalButtonClick extends ListExternalTenderEvent {
  final TransactionRequest transactionRequest;
  final String deviceIdValue;
  final String userName;
  SendExternalButtonClick(
      this.transactionRequest, this.deviceIdValue, this.userName)
      : super([transactionRequest]);
}

class SendPartsButtonClick extends ListExternalTenderEvent {
  final TransactionRequest transactionRequest;
  final String deviceIdValue;
  final String userName;
  SendPartsButtonClick(
      this.transactionRequest, this.deviceIdValue, this.userName)
      : super([transactionRequest]);
}

class FetchUserName extends ListExternalTenderEvent {
  @override
  String toString() {
    return "FetchUserName";
  }
}

class FetchDeviceId extends ListExternalTenderEvent {
  @override
  String toString() {
    return "FetchDeviceId";
  }
}
