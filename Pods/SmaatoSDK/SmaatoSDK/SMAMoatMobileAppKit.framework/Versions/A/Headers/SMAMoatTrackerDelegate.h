//
//  SMAMoatTrackerDelegate.h
//  SMAMoatMobileAppKit
//
//  Created by Moat 740 on 3/27/17.
//  Copyright © 2017 Moat. All rights reserved.
//

#import "SMAMoatAdEventType.h"

#ifndef SMAMoatTrackerDelegate_h
#define SMAMoatTrackerDelegate_h

typedef enum : NSUInteger {
    SMAMoatStartFailureTypeNone = 0, //Default none value
    SMAMoatStartFailureTypeActive,   //The tracker was already active
    SMAMoatStartFailureTypeRestart,  //The tracker was stopped already
    SMAMoatStartFailureTypeBadArgs,  //The arguments provided upon initialization or startTracking were invalid.
} SMAMoatStartFailureType;

@class SMAMoatBaseTracker;
@class SMAMoatBaseVideoTracker;

@protocol SMAMoatTrackerDelegate <NSObject>

@optional

/**
 Notifies delegate that the tracker has started tracking.
 */

- (void)trackerStartedTracking:(SMAMoatBaseTracker *)tracker;

/**
 Notifies delegate that the tracker has stopped tracking.
 */

- (void)trackerStoppedTracking:(SMAMoatBaseTracker *)tracker;

/**
 Notifies delegate that the tracker failed to start.
 
 @param type Type of startTracking failure.
 @param reason A human readable string on why the tracking failed.
 */

- (void)tracker:(SMAMoatBaseTracker *)tracker failedToStartTracking:(SMAMoatStartFailureType)type reason:(NSString *)reason;

@end

#pragma mark

@protocol SMAMoatVideoTrackerDelegate <NSObject>

@optional

/**
 Notifies delegate an ad event type is being dispatched (i.e. start, pause, quarterly events).
 
 @param adEventType The type of event fired.
 */
- (void)tracker:(SMAMoatBaseVideoTracker *)tracker sentAdEventType:(SMAMoatAdEventType)adEventType;

@end

#endif /* SMAMoatTrackerDelegate_h */
