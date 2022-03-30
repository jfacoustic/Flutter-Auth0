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
    switch(call.method) {
      case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
      case "login":
        let args = call.arguments as! [String: Any]
        let clientId = args["clientId"] as! String
        let domain = args["domain"] as! String
        let scope = args["scope"] as! String
        let audience = args["audience"] as! String
        let useEphemeral = args["useEphemeral"] as! Bool
      
        login(flutterResult: result, clientId: clientId, domain: domain, scope: scope, audience: audience, useEphemeral: useEphemeral)
      case "logout":
        let args = call.arguments as! [String: Any]
        let clientId = args["clientId"] as! String
        let domain = args["domain"] as! String
        logout(flutterResult: result, clientId: clientId, domain: domain)
      default:
          print("Method does not exist")
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
  
  public func login(flutterResult: @escaping FlutterResult, clientId: String, domain: String, scope: String, audience: String, useEphemeral: Bool = false) {
    var auth = Auth0.webAuth(clientId: clientId, domain: domain).scope(scope).audience(audience)
    if(useEphemeral)  {
      auth = auth.useEphemeralSession()
    }
    auth.start {
      result in
      switch result {
      case .failure(let error):
        flutterResult(FlutterError(code: "LoginFailure", message: "Failure Logging In with Auth0", details: error.localizedDescription))
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
          flutterResult(FlutterError(code: "LoginFailure", message: "Failure Logging In With Auth0", details: "Error encoding credentials"))
        }
      }
    }
  }
  
  public func logout(flutterResult: @escaping FlutterResult, clientId: String, domain: String) {
    Auth0.webAuth(clientId: clientId, domain: domain)
    .clearSession(federated: false) { result in
      print(result)
      flutterResult(result)
    }
  }
}
