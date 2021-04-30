import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:trackaware_lite/api/landing_page_api_client.dart';
import 'package:trackaware_lite/models/delivery_request.dart';
import 'package:trackaware_lite/models/delivery_response.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/priority_response.dart';
import 'package:trackaware_lite/models/transaction_request.dart';
import 'package:trackaware_lite/models/transaction_response.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:http/http.dart' as http;

class LandingPageApiRepository {
  final LandingPageApiClient landingPageApiClient;

  LandingPageApiRepository({@required this.landingPageApiClient})
      : assert(landingPageApiClient != null);

  Future<TransactionResponse> sendTransaction(
      TransactionRequest transactionRequest) async {
    return await landingPageApiClient.sendTransaction(transactionRequest);
  }

  Future<DeliveryResponse> updateDeliveryStatus(
      DeliveryRequest deliveryRequest) async {
    return await landingPageApiClient.updateDeliveryStatus(deliveryRequest);
  }

  Future<LocationApiResponse> updateLocation(String locationRequest) async {
    return await landingPageApiClient.updateLocation(locationRequest);
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

  Future<List<PriorityResponse>> fetchPriority() async {
    return await landingPageApiClient.fetchPriority();
  }

  Future<List<LocationResponse>> fetchLocation() async {
    return await landingPageApiClient.fetchLocation();
  }

  Future<http.Response> fetchUserProfileImage(
      String userName, String token) async {
    return await landingPageApiClient.fetchUserImage(token, userName);
  }
}
