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
  static const MethodChannel _channel = MethodChannel('flutter_auth0_client');

  final String clientId;
  final String domain;
  final String scope;
  final String audience;
  final bool useEphemeral;

  FlutterAuth0Client(
      {required this.clientId,
      required this.domain,
      this.scope = "",
      this.audience = "",
      this.useEphemeral = false});

  Future<Auth0Credentials> login() async {
    final rawJson = await _channel.invokeMethod('login', {
      "clientId": clientId,
      "domain": domain,
      "scope": scope,
      "audience": audience,
      "useEphemeral": useEphemeral
    });
    final decodedJson = jsonDecode(rawJson);
    return Auth0Credentials.fromJSON(decodedJson);
  }

  Future<dynamic> logout() async {
    return await _channel
        .invokeListMethod('logout', {"clientId": clientId, "domain": domain});
  }
}
