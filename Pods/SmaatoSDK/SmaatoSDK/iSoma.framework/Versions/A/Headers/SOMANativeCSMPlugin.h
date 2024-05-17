//
//  SOMANativeCSMPlugin.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SOMAMediatedAd;
@class SOMANativeCSMPlugin;
@class SOMAMediatedNetworkConfiguration;
@class SOMANativeAdObject;

@protocol SOMANativeCSMPluginDelegate <NSObject>
- (void)nativeCSMPluginDidLoad:(SOMANativeCSMPlugin*)plugin withObject:(SOMANativeAdObject*)obj;
- (void)nativeCSMPluginDidFail:(SOMANativeCSMPlugin*)plugin;
- (void)nativeCSMPluginLogImpresion:(SOMANativeCSMPlugin*)plugin;
- (void)nativeCSMPluginLogClick:(SOMANativeCSMPlugin*)plugin;


- (UILabel*)labelForTitle;
- (UILabel*)labelForDescription;
- (UIButton*)calltoActionButton;
- (UIView*)viewForMainImage;
- (UIImageView*)imageViewForIcon;
- (UIViewController*)rootViewController;
@end

@interface SOMANativeCSMPlugin : NSObject
@property(nonatomic, weak) id<SOMANativeCSMPluginDelegate> csmDelegate;
@property SOMAMediatedNetworkConfiguration* network;

- (instancetype)initWithConfiguration:(SOMAMediatedNetworkConfiguration*)network;
- (void)load;
- (void)registerViewForUserInteraction:(UIView*)view withRootViewController:(UIViewController*)rootViewController;
@end
