import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:trackaware_lite/api/external_tender_api_client.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/priority_response.dart';
import 'package:trackaware_lite/models/transaction_request.dart';
import 'package:trackaware_lite/models/transaction_response.dart';
import 'package:trackaware_lite/utils/strings.dart';

class TenderApiRepository {
  final TenderApiClient externalTenderApiClient;

  TenderApiRepository({@required this.externalTenderApiClient})
      : assert(externalTenderApiClient != null);

  Future<List<PriorityResponse>> fetchPriority() async {
    var list = await DBProvider.db.getPriorityResponse();
    if (list.isNotEmpty) {
      return list;
    } else {
      return await externalTenderApiClient.fetchPriority();
    }
  }

  Future<List<LocationResponse>> fetchLocation() async {
    try {
      var list = await DBProvider.db.getLocationResponse();
      if (list.isNotEmpty) {
        return list;
      } else {
        return await externalTenderApiClient.fetchLocation();
      }
    } catch (error) {
      print(error);
      return await externalTenderApiClient.fetchLocation();
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

  Future<TransactionResponse> sendTransaction(
      TransactionRequest transactionRequest) async {
    return await externalTenderApiClient.sendTransaction(transactionRequest);
  }
}
