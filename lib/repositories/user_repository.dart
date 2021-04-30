import 'dart:core';
import 'dart:io';

import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:meta/meta.dart';
import 'package:trackaware_lite/api/user_login_api_client.dart';
import 'package:trackaware_lite/models/login_response.dart';
import 'package:trackaware_lite/utils/strings.dart';

class UserRespository {
  final UserApiClient userApiClient;

  UserRespository({@required this.userApiClient})
      : assert(userApiClient != null);

  Future<LoginResponse> authenticate({
    @required String username,
    @required String password,
  }) async {
    return await userApiClient.userLogin(username, password);
  }

  Future<String> createUser(
      {@required Map<String, String> map, @required File file}) async {
    return await userApiClient.createUser(map, file);
  }

  Future<String> forgotPwd({@required String email}) async {
    return await userApiClient.forgotPassword(email);
  }

  Future<void> deleteToken() async {
    //delete from keystore/keychain
    await FlutterKeychain.remove(key: Strings.TOKEN);
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    //write to keystore/keychain
    await FlutterKeychain.put(key: Strings.TOKEN, value: token);
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    // read from keystore/keychain
    String token;
    try {
      token = await FlutterKeychain.get(key: Strings.TOKEN);
    } on Exception catch (ae) {
      print("Exception: " + ae.toString());
    }
    await Future.delayed(Duration(seconds: 1));
    return token != null && token.isNotEmpty ? true : false;
  }

  Future<void> persistUser(String userName) async {
    //write to keystore/keychain
    await FlutterKeychain.put(key: Strings.USER_NAME, value: userName);
    await Future.delayed(Duration(seconds: 1));
    return;
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
}
