//
//  SOMANativeEventTrackerObject.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SOMANativeAdEventType) {
    /**
     Impression.
     */
    SOMANativeAdEventTypeImpression = 1,
    /**
     Visible impression using MRC definition at 50% in view for 1 second.
     */
    SOMANativeAdEventTypeViewableMRC50 = 2,
    /**
     100% in view for 1 second.
     */
    SOMANativeAdEventTypeViewableMRC100 = 3,
};

typedef NS_ENUM(NSUInteger, SOMANativeAdEventMethod) {
    /**
     Image-pixel tracking.
     */
    SOMANativeAdEventMethodImg = 1,
    /**
     Javascript-based tracking.
     */
    SOMANativeAdEventMethodJS = 2,
};

@interface SOMANativeEventTrackerObject : NSObject

/**
 Type of event to track.
 */
@property (nonatomic, readonly) SOMANativeAdEventType event;

/**
 Type of tracking request.
 */
@property (nonatomic, readonly) SOMANativeAdEventMethod method;

/**
 The URL of the image ot js. Required for image or js, optional for custom.
 */
@property (nonatomic, readonly) NSURL *URL;

+ (instancetype)objectWithDictionary:(NSDictionary *)response error:(NSError **)error;

@end
