//
//  SOMAInterstitialVideoAdView.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import "SOMAInterstitialAdView.h"

@class SOMAVideoAd;

@interface SOMAInterstitialVideoAdView : SOMAInterstitialAdView

@property NSURL* vastURL;
- (SOMAVideoAd*)currentAd;

@end
