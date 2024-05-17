//
//  SOMAAdObject.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import "SOMATypes.h"
#import "SOMAExtension.h"

static NSString *const kSOMAAdObjectImpressionTrackersKey = @"impressiontrackers";
static NSString *const kSOMAAdObjectClickTrackersKey = @"clicktrackers";

extern NSString *const kSOMAExtension;

@interface SOMAAdObject : NSObject

@property(nonatomic, assign) SOMAAdFormat adFormat;
@property(nonatomic, readonly) NSString* passbackUrl;
@property(nonatomic) id<SOMAExtension> extension;
@property(nonatomic, readonly) NSString* session;
@property(nonatomic) NSString* sci;

/**
 An array of URLs that contains all impression trackers. The impression trackers should be all called when the creative is visible on the
 screen.
 */
@property(nonatomic, strong) NSArray<NSURL *>* impressionTrackersUrls;

/**
 An array of URLs that contains all click trackers. The click tracking URLs must be called as soon as the user clicks on the creative.
 */
@property(nonatomic, strong) NSArray<NSURL *>* clickTrackersUrls;

/**
 An array of URLs that contains all trackers.
 @param trackers    Array of string URLs.
 @return            The array of valid URLs mapped from the array of strings.
 */
+ (NSArray<NSURL *> *)URLTrackers:(NSArray *)trackers;

- (void)mergeAd:(SOMAAdObject*)ad;

@end
