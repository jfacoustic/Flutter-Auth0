import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class Auth0Credentials {
  final String? accessToken;
  final String? tokenType;
  final String? refreshToken;
  final String? idToken;
  final String? scope;
  final String? recoveryCode;

  Auth0Credentials(this.accessToken, this.tokenType, this.refreshToken,
      this.idToken, this.scope, this.recoveryCode);

  Auth0Credentials.fromJSON(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        tokenType = json['tokenType'],
        refreshToken = json['refreshToken'],
        idToken = json['idToken'],
        scope = json['scope'],
        recoveryCode = json['recoveryCode'];
}

class FlutterAuth0Client {
  static const MethodChannel _channel = MethodChannel('flutter_auth0');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Auth0Credentials> login(
      {clientId = String, domain = String, scope = String}) async {
    final rawJson = await _channel.invokeMethod(
        'login', {"clientId": clientId, "domain": domain, "scope": scope});
    final decodedJson = jsonDecode(rawJson);
    return Auth0Credentials.fromJSON(decodedJson);
  }

  static Future<dynamic> logout() async {
    return await _channel.invokeListMethod('logout');
  }
}
