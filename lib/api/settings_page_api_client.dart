import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/priority_response.dart';

class SettingsPageApiClient {
  final http.Client httpClient;

  SettingsPageApiClient({@required this.httpClient})
      : assert(httpClient != null);

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
}
