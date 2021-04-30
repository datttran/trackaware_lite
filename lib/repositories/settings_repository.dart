import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/api/settings_page_api_client.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/priority_response.dart';

class SettingsPageApiRepository {
  final SettingsPageApiClient settingsPageApiClient;

  SettingsPageApiRepository({@required this.settingsPageApiClient})
      : assert(settingsPageApiClient != null);

  Future<List<PriorityResponse>> fetchPriority() async {
    return await settingsPageApiClient.fetchPriority();
  }

  Future<List<LocationResponse>> fetchLocation() async {
    return await settingsPageApiClient.fetchLocation();
  }
}
