import 'dart:async';
import 'dart:convert';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:auth0_spa_dart/auth0_spa_dart.dart';

/// A web implementation of the FlutterAuth0Client plugin.
class FlutterAuth0ClientWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'flutter_auth0_client',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = FlutterAuth0ClientWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getPlatformVersion':
        return getPlatformVersion();
      case 'login':
        return login(call.arguments);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'flutter_auth0 for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Returns a [String] containing the version of the platform.
  Future<String> getPlatformVersion() {
    final version = html.window.navigator.userAgent;
    return Future.value(version);
  }

  Future<String> login(dynamic args) async {
    final client = await createAuth0Client(
        clientId: args['clientId'],
        domain: args['domain'],
        useRefreshTokens: true,
        cacheLocation: "localstorage");
    final isAuthenticated = await client.isAuthenticated();
    if (!isAuthenticated) {
      await client.loginWithPopup(
          scope: args['scope'], audience: args['audience']);
    }
    final token = await client.getTokenSilently(
        detailedResponse: args['detailedResponse'], audience: args['audience']);
    Map<String, dynamic> tokenMap = {
      'accessToken': token.accessToken,
      'idToken': token.idToken,
      'expiresIn': token.expiresIn
    };
    return jsonEncode(tokenMap);
  }


}
