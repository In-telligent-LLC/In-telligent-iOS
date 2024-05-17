//
//  SOMAMediatedNetworkConfiguration.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import <Foundation/Foundation.h>
@class SOMAMediationPlugin;
@class SOMANativeCSMPlugin;

@interface SOMAMediatedNetworkConfiguration : NSObject
@property (copy, nonatomic) NSString* networkName;
@property (copy, nonatomic) NSString* customClassName;
@property (copy, nonatomic) NSString* customClassMethod;
@property (copy, nonatomic) NSString* customClassData;
@property (copy, nonatomic) NSString* clickURL;
@property (copy, nonatomic) NSString* impresionURL;
@property (copy, nonatomic) NSURL* passbackURL;
@property (copy, nonatomic) NSString* sessionid;
@property (copy, nonatomic) NSString* adunitid;
@property (copy, nonatomic) NSString* adunitidextra;
@property (copy, nonatomic) NSString* status;
@property BOOL beaconsCalled;
@property BOOL clickURLCalled;

@property  BOOL isNative;
@property  int priority;
@property  int width;
@property  int height;
- (BOOL)isPluginInstalled;
- (BOOL)isCustom;
- (NSString*)pluginClassName;
- (SOMAMediationPlugin*)instantiatePlugin;
- (SOMANativeCSMPlugin*)instantiateNativePlugin;
@end
