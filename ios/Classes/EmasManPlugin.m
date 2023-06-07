#import "EmasManPlugin.h"
#import <AlicloudMobileAnalitics/ALBBMAN.h>

@implementation EmasManPlugin {
    ALBBMANAnalytics *_man;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"emas_man"
                                  binaryMessenger:[registrar messenger]];
  EmasManPlugin *instance = [[EmasManPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
  NSString *method = call.method;
  if ([method isEqualToString:@"init"]) {
      [self init:call result:result];
  } else if ([method isEqualToString:@"getPlatformVersion"]) {
      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([method isEqualToString:@"userRegister"]) {
      [self userRegister:call result:result];
  } else if ([method isEqualToString:@"updateUserAccount"]) {
      [self updateUserAccount:call result:result];
  } else if ([method isEqualToString:@"trackPage"]) {
      [self trackPage:call result:result];
  } else if ([method isEqualToString:@"trackEvent"]) {
      [self trackEvent:call result:result];
  } else {
      result(FlutterMethodNotImplemented);
  }
}

- (void)userRegister:(FlutterMethodCall *)call result:(FlutterResult)result {
     NSString *userId = call.arguments[@"userId"];
     [_man userRegister:userId];
    result([NSNumber numberWithBool:TRUE]);
}

- (void)updateUserAccount:(FlutterMethodCall *)call
                   result:(FlutterResult)result {
     NSString *userId = call.arguments[@"userId"];
     NSString *username = call.arguments[@"username"];
     [_man updateUserAccount:username userid:userId];
    result([NSNumber numberWithBool:TRUE]);
}

- (void)trackPage:(FlutterMethodCall *)call result:(FlutterResult)result {
     ALBBMANPageHitBuilder *builder = [[ALBBMANPageHitBuilder alloc] init];
     NSString *pageName = call.arguments[@"pageName"];
     NSString *referrer = call.arguments[@"referPageName"];
     NSNumber *duration = call.arguments[@"duration"];
     NSDictionary *properties = call.arguments[@"properties"];

     [builder setPageName:pageName];
     if(referrer != (NSString *)[NSNull null]) {
         [builder setReferPage:referrer];
     }
     if (duration != (NSNumber *)[NSNull null]) {
         [builder setDurationOnPage:duration.longValue];
     }
     if (properties != (NSDictionary *)[NSNull null]) {
        NSLog(@"trackPage has properties: %d", properties != nil );
         [builder setProperties:properties];
     }

       ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
       [tracker send:[builder build]];

    result([NSNumber numberWithBool:TRUE]);
}

- (void)trackEvent:(FlutterMethodCall *)call result:(FlutterResult)result {
     ALBBMANCustomHitBuilder *builder = [[ALBBMANCustomHitBuilder alloc] init];
     NSString *pageName = call.arguments[@"pageName"];
     NSString *eventName = call.arguments[@"eventName"];
     NSNumber *duration = call.arguments[@"duration"];
     NSDictionary *properties = call.arguments[@"properties"];

     [builder setEventLabel:eventName];

     if( pageName != (NSString *)[NSNull null]) {
     [builder setEventPage:pageName];
     }

     if (duration != (NSNumber *)[NSNull null]) {
         [builder setDurationOnEvent:duration.longValue];
     }

     if(properties != (NSDictionary *)[NSNull null]) {
     [builder setProperties:properties];
     }

     ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
     [tracker send:[builder build]];

    result([NSNumber numberWithBool:TRUE]);
}

- (void)init:(FlutterMethodCall *)call
                  result:(FlutterResult)result  {
    NSLog(@"init man");

    BOOL debug = [call.arguments[@"debug"] boolValue];
  
    // Mobile Analysis
    _man = [ALBBMANAnalytics getInstance];

    if(debug){
      [_man turnOnDebug];
    }
    [_man autoInit];

    result([NSNumber numberWithBool:TRUE]);
}

@end
