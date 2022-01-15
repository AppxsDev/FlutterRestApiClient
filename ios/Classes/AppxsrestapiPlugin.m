#import "AppxsrestapiPlugin.h"
#if __has_include(<appxsrestapi/appxsrestapi-Swift.h>)
#import <appxsrestapi/appxsrestapi-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "appxsrestapi-Swift.h"
#endif

@implementation AppxsrestapiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAppxsrestapiPlugin registerWithRegistrar:registrar];
}
@end
