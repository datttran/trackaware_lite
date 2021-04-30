import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:trackaware_lite/models/delivery_request.dart';
import 'package:trackaware_lite/models/delivery_response.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/priority_response.dart';
import 'package:trackaware_lite/models/transaction_request.dart';
import 'package:trackaware_lite/models/transaction_response.dart';
import 'package:trackaware_lite/globals.dart' as globals;

class LandingPageApiClient {
  final http.Client httpClient;

  LandingPageApiClient({@required this.httpClient})
      : assert(httpClient != null);

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

  Future<DeliveryResponse> updateDeliveryStatus(
      DeliveryRequest deliveryRequest) async {
    final deliveryUrl = globals.baseUrl + '/observe';

    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode(globals.serverUserName + ':' + globals.serverPassword));

    var deliveryResponse = await this.httpClient.post(deliveryUrl,
        headers: {'authorization': basicAuth},
        body: deliveryRequest.toString());
    final deliveryResponseJson = jsonDecode(deliveryResponse.body);
    print("DeliveryResponse :" + deliveryResponse.toString());
    return DeliveryResponse.fromJson(deliveryResponseJson);
  }

  Future<LocationApiResponse> updateLocation(String locationRequest) async {
    final locationUrl = globals.baseUrl + "/geolocation";

    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode(globals.serverUserName + ':' + globals.serverPassword));

    var locationResponse = await this.httpClient.post(locationUrl,
        headers: {'authorization': basicAuth}, body: locationRequest);
    final locationResponseJson = jsonDecode(locationResponse.body);
    print("LocationResponse :" + locationResponse.toString());
    return LocationApiResponse.fromJson(locationResponseJson);
  }

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

  Future<http.Response> fetchUserImage(String token, String userName) async {
    String imageUrl = globals.baseUrl +
        "/mobiletransaction/getUserProfileImage?token=$token&user=$userName";
    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode(globals.serverUserName + ':' + globals.serverPassword));
    print(basicAuth);

    try {
      final response = await this
          .httpClient
          .get(imageUrl, headers: {'authorization': basicAuth}).timeout(
              const Duration(seconds: 60), onTimeout: () {
        return null;
      });

      return response;
    } catch (value) {
      print(value);
      return null;
    }
  }
}
