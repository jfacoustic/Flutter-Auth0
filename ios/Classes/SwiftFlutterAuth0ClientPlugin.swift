import Flutter
import UIKit
import Auth0

public class SwiftFlutterAuth0ClientPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_auth0_client", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterAuth0ClientPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method == "getPlatformVersion") {
      result("iOS " + UIDevice.current.systemVersion)
    } else if(call.method == "login") {
      let clientId = (call.arguments as! [String: String])["clientId"]
      let domain = (call.arguments as! [String: String])["domain"]
      let scope = (call.arguments as! [String: String])["scope"]
      let audience = (call.arguments as! [String: String])["audience"]

      login(flutterResult: result, clientId: clientId!, domain: domain!, scope: scope ?? "", audience: audience ?? "")
    } else {
      print("METHOD DOES NOT EXIST")
    }
  }
  
  struct Auth0Credentials: Codable {
    var accessToken: String?
    var tokenType: String?
    var expiresIn: Date?
    var refreshToken: String?
    var idToken: String?
    var scope: String?
    var recoveryCode: String?
  }
  
  public func login(flutterResult: @escaping FlutterResult, clientId: String, domain: String, scope: String, audience: String) {
    Auth0.webAuth(clientId: clientId, domain: domain).scope(scope).audience(audience).start {
      result in
      switch result {
      case .failure(let error):
        flutterResult(error)
      case .success(let credentials):
        do {
          let data = Auth0Credentials(
            accessToken: credentials.accessToken, tokenType: credentials.tokenType, expiresIn: credentials.expiresIn, refreshToken: credentials.refreshToken, idToken: credentials.idToken, scope: credentials.scope, recoveryCode: credentials.recoveryCode
          )
          let encoder = JSONEncoder()
          let json = try encoder.encode(data)
          let result = String(data: json, encoding: .utf8)!
          flutterResult(result)
        } catch {
          flutterResult("ERROR")
        }
      }
    }
  }
  
  public func logout(_call: FlutterMethodCall, result: @escaping FlutterResult) {
    Auth0.webAuth()
      .clearSession(federated: false) { result in
        print(result)
      }
  }
}
