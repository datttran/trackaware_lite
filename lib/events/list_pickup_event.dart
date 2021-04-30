import 'package:equatable/equatable.dart';
import 'package:trackaware_lite/models/transaction_request.dart';

abstract class ListPickUpEvent extends Equatable {
  ListPickUpEvent([List props = const []]) : super(props);
}

class ListExternalPickUpItemsEvent extends ListPickUpEvent {}

class ListPickUpPartItemsEvent extends ListPickUpEvent {}

class VerifyPackageDetails extends ListPickUpEvent {}

class FetchUserName extends ListPickUpEvent {
  @override
  String toString() {
    return "FetchUserName";
  }
}

class FetchDeviceId extends ListPickUpEvent {
  @override
  String toString() {
    return "FetchDeviceId";
  }
}

class SendExternalButtonClick extends ListPickUpEvent {
  final TransactionRequest transactionRequest;
  final String deviceIdValue;
  final String userName;
  SendExternalButtonClick(
      this.transactionRequest, this.deviceIdValue, this.userName)
      : super([transactionRequest]);
}

class SendPartsButtonClick extends ListPickUpEvent {
  final TransactionRequest transactionRequest;
  final String deviceIdValue;
  final String userName;
  SendPartsButtonClick(
      this.transactionRequest, this.deviceIdValue, this.userName)
      : super([transactionRequest]);
}
