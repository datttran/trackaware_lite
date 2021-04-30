import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:trackaware_lite/models/delivery_request.dart';
import 'package:trackaware_lite/models/delivery_response.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'dart:convert';
import 'package:trackaware_lite/globals.dart' as globals;

class DeliveryApiClient {
  final http.Client httpClient;

  DeliveryApiClient({@required this.httpClient}) : assert(httpClient != null);

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
}
