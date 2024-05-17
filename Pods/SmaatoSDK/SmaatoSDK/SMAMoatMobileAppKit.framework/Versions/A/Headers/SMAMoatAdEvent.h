//
//  MoatAdEvent.h
//  MoatMobileAppKit
//
//  Created by Moat on 2/5/16.
//  Copyright © 2016 Moat. All rights reserved.
//
//  This class is simply a data object that encapsulates info relevant to a particular playback event.

#import <Foundation/Foundation.h>
#import "SMAMoatAdEventType.h"

static NSTimeInterval const SMAMoatTimeUnavailable = NAN;
static float const SMAMoatVolumeUnavailable = NAN;

@interface SMAMoatAdEvent : NSObject

@property (assign, nonatomic) SMAMoatAdEventType eventType;
@property (assign, nonatomic) NSTimeInterval adPlayhead;
@property (assign, nonatomic) float adVolume;
@property (assign, nonatomic, readonly) NSTimeInterval timeStamp;

- (id)initWithType:(SMAMoatAdEventType)eventType withPlayheadMillis:(NSTimeInterval)playhead;
- (id)initWithType:(SMAMoatAdEventType)eventType withPlayheadMillis:(NSTimeInterval)playhead withVolume:(float)volume;
- (NSDictionary *)asDict;
- (NSString *)eventAsString;

@end
