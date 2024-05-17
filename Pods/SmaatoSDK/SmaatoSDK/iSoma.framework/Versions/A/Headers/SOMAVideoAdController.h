//
//  SOMAVideoAdController.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import <UIKit/UIKit.h>
#import "SOMAAdSettings.h"
#import "SOMAAdViewDelegate.h"

@class SOMAVideoAd;
@class SOMAVideoAdController;

@protocol SOMAVideoAdControllerDelegate <NSObject>
- (void)somaVideoAdDidLoadAd:(SOMAVideoAdController *)adview;
- (void)somaVideoAd:(SOMAVideoAdController*) adview didFailToReceiveAdWithError:(NSError *)error;

@optional
- (UIViewController*)somaRootViewController;
- (void)somaAdViewDidClick:(SOMAVideoAdController *)adview;
- (void)somaVideoAd:(SOMAVideoAdController*) adview isClosed:(BOOL)userClickedCloseButton;
- (void)somaVideoAdWillLoadAd:(SOMAVideoAdController *)adview;
- (void)somaVideoAdWillEnterFullscreen:(SOMAVideoAdController *)adview;
- (void)somaVideoAdDidEnterFullscreen:(SOMAVideoAdController *)adview;
- (void)somaVideoAdApplicationWillGoBackground:(SOMAVideoAdController *)adview;
- (void)somaVideoAdWillExitFullscreen:(SOMAVideoAdController *)adview;
- (void)somaVideoAdDidExitFullscreen:(SOMAVideoAdController *)adview;
- (void)somaVideoAd:(SOMAVideoAdController *)adview didReceiveVideoAdEvent:(SOMAVideoAdTrackingEvent)event;
- (void)somaVideoAd:(SOMAVideoAdController *)adview didReceiveVideoAdEvent:(SOMAVideoAdTrackingEvent)event withURLCount:(NSUInteger)count;
- (void)somaVideoAdWillLeaveApplicationFromAd:(SOMAVideoAdController*)adview;

- (void)somaVideoAdWillHide:(SOMAVideoAdController*)adview DEPRECATED_ATTRIBUTE;
@end

@interface SOMAVideoAdController : UIViewController

@property (nonatomic) NSURL* vastURL;
@property (nonatomic) SOMAAdSettings* adSettings;
@property (nonatomic) SOMAVideoAd* currentAd;
@property (nonatomic, weak) id<SOMAVideoAdControllerDelegate> delegate;

-(void)loadRewardedVideo;
-(void)load;
-(void)show;
-(void)show:(UIViewController*)rootViewController;

-(void)reset;
-(BOOL)shouldLoadNewAd;
-(BOOL)isReady;

// Inject SOMAVideoAd object to use SOMAVideoAdController only for presentation purposes
-(void)adLoaded:(SOMAVideoAd*)ad;
@end
