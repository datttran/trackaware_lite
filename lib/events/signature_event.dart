import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/models/transaction_request.dart';

abstract class SignatureEvent extends Equatable {
  SignatureEvent([List props = const []]) : super(props);
}

class FetchPickUpItems extends SignatureEvent {
  @override
  String toString() {
    return "FetchPickUpItems";
  }
}

class FetchDeviceId extends SignatureEvent {
  @override
  String toString() {
    return "FetchDeviceId";
  }
}

class FetchUserName extends SignatureEvent {
  @override
  String toString() {
    return "FetchUserName";
  }
}

class TransactionEvent extends SignatureEvent {
  final TransactionRequest transactionRequests;
  final int transactionRequestCount;

  TransactionEvent(
      {@required this.transactionRequests,
      @required this.transactionRequestCount})
      : super([transactionRequests, transactionRequestCount]);
  @override
  String toString() {
    return 'TransactionEvent : TrasactionRequests: $transactionRequests, Count : $transactionRequestCount';
  }
}
