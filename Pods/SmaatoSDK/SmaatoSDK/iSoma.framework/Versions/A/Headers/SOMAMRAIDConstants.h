//
//  SOMAMRAIDConstants.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import <Foundation/Foundation.h>

extern NSString *const kSOMAMRAIDJSContent;
extern NSString *const kSOMAMRAIDUrlScheme;
extern NSString *const kSOMAOrientationPropertyForceOrientationPortraitKey;
extern NSString *const kSOMAOrientationPropertyForceOrientationLandscapeKey;
extern NSString *const kSOMAOrientationPropertyForceOrientationNoneKey;

enum {
    SOMAMRAIDAdViewPlacementTypeInline,
    SOMAMRAIDAdViewPlacementTypeInterstitial
};
typedef NSUInteger SOMAMRAIDAdViewPlacementType;

enum {
    SOMAMRAIDAdViewStateHidden,
    SOMAMRAIDAdViewStateDefault,
    SOMAMRAIDAdViewStateExpanded,
    SOMAMRAIDAdViewStateResized
};
typedef NSUInteger SOMAMRAIDAdViewState;
