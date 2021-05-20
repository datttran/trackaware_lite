import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/models/transaction_request.dart';
import 'package:trackaware_lite/utils/transactions.dart';

_sendToServer(TransactionRequest transactionRequest) async {
  try {
    final response = await http.post(
      Uri.parse(globals.baseUrl + '/transaction/'),
      headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'Basic cmtoYW5kaGVsZGFwaTppMjExVTI7'},
      body: jsonEncode(transactionRequest.toJson()),
    );
    print(response.statusCode);
    print(transactionRequest.toString());
    print('finish');
  } catch (E) {
    print('SEND TO SERVER ERROR' + E.toString());
  }
}

pickupTrans(package) {
  try {
    print('generate transaction');
    print(package.toString());

    TransactionRequest transactionRequest = TransactionRequest();

    transactionRequest.handHeldId = 'Android_TestDevice';
    transactionRequest.id = 232;

    transactionRequest.location = package.location;

    transactionRequest.status = 'pickup';
    transactionRequest.user = 'testtest';

    transactionRequest.packages = [getPackageFromPickUpPart(package)];
    print(transactionRequest.toString());

    //_transactionRequestItems.add(transactionRequest);
    _sendToServer(transactionRequest);
  } catch (e) {
    print('GENERATE TRANSACTION ERROR ' + e.toString());
  }
}

deliTrans(package) {
  try {
    print('generate transaction');
    print(package.toString());

    TransactionRequest transactionRequest = TransactionRequest();

    transactionRequest.handHeldId = 'Android_TestDevice';
    transactionRequest.id = 232;

    transactionRequest.location = package.location;

    transactionRequest.status = 'delivery';
    transactionRequest.user = 'testtest';
    transactionRequest.receiverSignature = package.receiverSignature;

    transactionRequest.packages = [getPackageFromPickUpPart(package)];
    print(transactionRequest.toString());

    //_transactionRequestItems.add(transactionRequest);
    _sendToServer(transactionRequest);
  } catch (e) {
    print('GENERATE TRANSACTION ERROR ' + e.toString());
  }
}
