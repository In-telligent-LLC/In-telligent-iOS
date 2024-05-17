//
//  SMAMoatAdEventType.h
//  SMAMoatMobileAppKit
//
//  Created by Moat 740 on 3/27/17.
//  Copyright © 2017 Moat. All rights reserved.
//

#ifndef SMAMoatAdEventType_h
#define SMAMoatAdEventType_h

typedef enum SMAMoatAdEventType : NSUInteger {
    SMAMoatAdEventComplete
    , SMAMoatAdEventStart
    , SMAMoatAdEventFirstQuartile
    , SMAMoatAdEventMidPoint
    , SMAMoatAdEventThirdQuartile
    , SMAMoatAdEventSkipped
    , SMAMoatAdEventStopped
    , SMAMoatAdEventPaused
    , SMAMoatAdEventPlaying
    , SMAMoatAdEventVolumeChange
    , SMAMoatAdEventNone
} SMAMoatAdEventType;

#endif /* SMAMoatAdEventType_h */
