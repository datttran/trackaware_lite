import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:trackaware_lite/models/login_response.dart';
import 'package:trackaware_lite/globals.dart' as globals;

class UserApiClient {
  final http.Client httpClient;

  UserApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<LoginResponse> userLogin(String _userName, String _password) async {
    final loginUrl = globals.baseUrl + '/mobiletransaction/userauth';

    print("Login Url : " + loginUrl);
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

  createUser(Map<String, String> map, File file) async {
    final createUserUrl = globals.baseUrl + "/mobiletransaction/signupUser";

    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode(globals.serverUserName + ':' + globals.serverPassword));

    var uri = Uri.parse(createUserUrl);
    var createUserRequest = http.MultipartRequest("POST", uri)
      ..headers.putIfAbsent("authorization", () => basicAuth)
      ..fields.addAll(map)
      ..files
          .add(await http.MultipartFile.fromPath("image", file.absolute.path));

    var send = await createUserRequest.send();
    print("CreateUserRequest :" + send.statusCode.toString());
    return send.statusCode.toString();
  }

  Future<String> forgotPassword(String email) async {
    final forgotPwdUrl =
        globals.baseUrl + "/mobiletransaction/userforgotpassword";

    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode(globals.serverUserName + ':' + globals.serverPassword));

    var forgotPwdResponse = await this.httpClient.post(forgotPwdUrl,
        headers: {'authorization': basicAuth}, body: {'username': email});
    print("ForgotPwdResponse :" + forgotPwdResponse.body);
    return forgotPwdResponse.body;
  }
}
