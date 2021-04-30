import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:trackaware_lite/api/pickup_api_client.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/package_details_response.dart';
import 'package:trackaware_lite/models/transaction_request.dart';
import 'package:trackaware_lite/models/transaction_response.dart';
import 'package:trackaware_lite/utils/strings.dart';

class PickUpApiRepository {
  final PickUpApiClient pickUpApiClient;

  PickUpApiRepository({@required this.pickUpApiClient})
      : assert(pickUpApiClient != null);

  Future<List<LocationResponse>> fetchLocation() async {
    try {
      var list = await DBProvider.db.getLocationResponse();
      if (list.isNotEmpty) {
        return list;
      } else {
        return await pickUpApiClient.fetchLocation();
      }
    } catch (error) {
      print(error);
      return await pickUpApiClient.fetchLocation();
    }
  }

  Future<List<PackageDetailsResponse>> verifyDestination(String tag) async {
    return await pickUpApiClient.verifyDestination(tag);
  }

  Future<TransactionResponse> sendTransaction(
      TransactionRequest transactionRequest) async {
    return await pickUpApiClient.sendTransaction(transactionRequest);
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
}
