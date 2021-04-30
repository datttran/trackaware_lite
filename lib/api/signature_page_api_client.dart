import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:trackaware_lite/models/transaction_request.dart';
import 'package:trackaware_lite/models/transaction_response.dart';
import 'dart:convert';
import 'package:trackaware_lite/globals.dart' as globals;

class SignatureApiClient {
  final http.Client httpClient;

  SignatureApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<TransactionResponse> sendTransaction(
      TransactionRequest transactionRequest) async {
    final loginUrl = globals.baseUrl + '/transaction';

    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode(globals.serverUserName + ':' + globals.serverPassword));

    var transactionResponse = await this.httpClient.post(loginUrl,
        headers: {'authorization': basicAuth},
        body: transactionRequest.toString());
    final transactionResponseJson = jsonDecode(transactionResponse.body);
    print("TransactionResponse :" + transactionResponseJson.toString());
    return TransactionResponse.fromJson(transactionResponseJson);
  }
}
