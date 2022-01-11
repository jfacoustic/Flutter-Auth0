#import "FlutterAuth0ClientPlugin.h"
#if __has_include(<flutter_auth0/flutter_auth0-Swift.h>)
#import <flutter_auth0/flutter_auth0_client-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_auth0_client-Swift.h"
#endif

@implementation FlutterAuth0ClientPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAuth0ClientPlugin registerWithRegistrar:registrar];
}
@end
