import 'dart:async';
import 'dart:convert';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;
import 'dart:js_util';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';

@JS('console.log')
external void log(Object obj);

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
    try {
      final client = await getAuth0Client(
          clientId: args["clientId"],
          domain: args["domain"],
          audience: args["audience"]);
      await promiseToFuture(client.loginWithPopup());
      final token = await promiseToFuture(client.getTokenSilently());
      return '{"accessToken": "$token"}';
    } catch (e) {
      return "{}";
    }
  }

  Future<bool> isAuthenticated(dynamic client) async {
    final result = await promiseToFuture(client.isAuthenticated());
    return result;
  }

  Future<dynamic> getAuth0Client(
      {String? clientId,
      String? domain,
      String? audience,
      String? scope}) async {
    final promise = await createAuth0Client(Auth0ClientOptions(
        client_id: clientId, domain: domain, audience: audience));
    final future = promiseToFuture(promise);
    final result = await future;
    return result;
  }
}

@JS()
@anonymous
class Auth0ClientOptions {
  external factory Auth0ClientOptions(
      {String? client_id, String? domain, String? audience, String? scope});
  external String? get client_id;
  external String? get domain;
  external String? get audience;
  external String? get scope;
}

@JS('createAuth0Client')
external Future<dynamic> createAuth0Client(Auth0ClientOptions opts);

Map<String, dynamic> decodeJSON(Object obj) {
  return jsonDecode(jsonStringify(obj));
}

@JS("JSON.stringify")
external String jsonStringify(Object obj);

@JS("auth0")
external dynamic auth0;
