import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackaware_lite/models/login_response.dart';
import 'package:trackaware_lite/models/logout_response.dart';
import 'package:trackaware_lite/models/user_details_response.dart';
import 'dart:convert';
import 'package:trackaware_lite/globals.dart' as globals;

class ProfileApiClient {
  final http.Client httpClient;

  ProfileApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<Object> fetchUserDetails(String userName, String token) async {
    final userDetailsUrl = globals.baseUrl +
        '/mobiletransaction/getUserInfo?token=$token&user=$userName';

    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode(globals.serverUserName + ':' + globals.serverPassword));

    var userDetailsResponse = await this
        .httpClient
        .get(userDetailsUrl, headers: {'authorization': basicAuth});
    try {
      final userDetailsJson = jsonDecode(userDetailsResponse.body);
      print("UserDetailsResponse :" + userDetailsJson.toString());
      return UserDetailsResponse.fromJson(userDetailsJson);
    } catch (value) {
      print("UserDetailsResponse :" + userDetailsResponse.body.toString());
      return userDetailsResponse.body;
    }
  }

  Future<LoginResponse> userLogin(String _userName, String _password) async {
    final loginUrl = globals.baseUrl + '/mobiletransaction/userauth';

    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode(globals.serverUserName + ':' + globals.serverPassword));

    var loginResponse = await this.httpClient.post(loginUrl,
        headers: {'authorization': basicAuth},
        body: {'user': _userName, 'password': _password});
    final loginResponseJson = jsonDecode(loginResponse.body);
    print("LoginResponse :" + loginResponseJson.toString());
    return LoginResponse.fromJson(loginResponseJson);
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

  Future<LogoutResponse> logout(String userName) async {
    final logoutUrl = globals.baseUrl + '/mobiletransaction/userInauth';

    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode(globals.serverUserName + ':' + globals.serverPassword));

    var logoutResponse = await this.httpClient.post(logoutUrl, headers: {
      'authorization': basicAuth
    }, body: {
      'user': userName,
    });
    final logoutResponseJson = jsonDecode(logoutResponse.body);
    print("LogoutResponse :" + logoutResponseJson.toString());
    return LogoutResponse.fromJson(logoutResponseJson);
  }

  updateUser(Map<String, String> map, PickedFile pickedFile) async {
    final editUserUrl = globals.baseUrl + "/mobiletransaction/UpdateUser";

    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode(globals.serverUserName + ':' + globals.serverPassword));

    var uri = Uri.parse(editUserUrl);
    var editUserRequest = http.MultipartRequest("POST", uri)
      ..headers.putIfAbsent("authorization", () => basicAuth)
      ..fields.addAll(map)
      ..files.add(await http.MultipartFile.fromPath("image", pickedFile.path));

    var send = await editUserRequest.send();
    print("EditUserRequest :" + send.statusCode.toString());
    return send.statusCode.toString();
  }
}
