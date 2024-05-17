//
//  SOMAInterstitialView.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import "SOMAAdView.h"

@interface SOMAInterstitialAdView : SOMAAdView

@property UIInterfaceOrientation initialOrientation;

-(BOOL)isReady;
-(void)show:(UIViewController*)rootViewController;

@end
