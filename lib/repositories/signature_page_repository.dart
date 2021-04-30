import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/api/signature_page_api_client.dart';
import 'package:trackaware_lite/models/transaction_request.dart';
import 'package:trackaware_lite/models/transaction_response.dart';

class SignaturePageRepository {
  final SignatureApiClient signatureApiClient;

  SignaturePageRepository({@required this.signatureApiClient})
      : assert(signatureApiClient != null);

  Future<TransactionResponse> sendTransaction(
      TransactionRequest transactionRequest) async {
    return await signatureApiClient.sendTransaction(transactionRequest);
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
}
