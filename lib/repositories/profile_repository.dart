import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:trackaware_lite/api/profile_api_client.dart';
import 'package:trackaware_lite/models/login_response.dart';
import 'package:trackaware_lite/models/logout_response.dart';

class ProfileRepository {
  final ProfileApiClient profileApiClient;

  ProfileRepository({@required this.profileApiClient})
      : assert(profileApiClient != null);

  Future<Object> fetchUserDetails(String userName, String token) async {
    return await profileApiClient.fetchUserDetails(userName, token);
  }

  Future<http.Response> fetchUserProfileImage(
      String userName, String token) async {
    return await profileApiClient.fetchUserImage(token, userName);
  }

  Future<LogoutResponse> logout(String userName) async {
    return await profileApiClient.logout(userName);
  }

  Future<LoginResponse> login({
    @required String username,
    @required String password,
  }) async {
    return await profileApiClient.userLogin(username, password);
  }
}
