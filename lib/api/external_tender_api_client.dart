import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/priority_response.dart';
import 'dart:convert';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/models/transaction_request.dart';
import 'package:trackaware_lite/models/transaction_response.dart';
import 'package:trackaware_lite/utils/strings.dart';

class TenderApiClient {
  final http.Client httpClient;

  TenderApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<List<PriorityResponse>> fetchPriority() async {
    final priorityUrl = globals.baseUrl + '/priority';

    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode(globals.serverUserName + ':' + globals.serverPassword));

    var priorityListResponse = await this
        .httpClient
        .get(priorityUrl, headers: {'authorization': basicAuth});
    final priorityResponseJson = jsonDecode(priorityListResponse.body) as List;
    print("PriorityResponse :" + priorityResponseJson.toString());
    return priorityResponseJson
        .map((data) => new PriorityResponse.fromJson(data))
        .toList();
  }

  Future<List<LocationResponse>> fetchLocation() async {
    final priorityUrl = globals.baseUrl + '/readpoint';

    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode(globals.serverUserName + ':' + globals.serverPassword));

    var locationResponse = await this
        .httpClient
        .get(priorityUrl, headers: {'authorization': basicAuth});
    final locationResponseJson = jsonDecode(locationResponse.body) as List;
    print("LocationResponse :" + locationResponseJson.toString());
    return locationResponseJson
        .map((data) => new LocationResponse.fromJson(data))
        .toList();
  }

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

  Future<String> fetchDeviceId() async {
    DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
      return androidInfo.id;
    } else {
      IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor;
    }
  }

  Future<bool> fetchUserName() async {
    // read from keystore/keychain
    String userName;
    try {
      userName = await FlutterKeychain.get(key: Strings.USER_NAME);
    } on Exception catch (ae) {
      print("Exception: " + ae.toString());
    }
    await Future.delayed(Duration(seconds: 1));
    return userName != null && userName.isNotEmpty ? true : false;
  }
}
