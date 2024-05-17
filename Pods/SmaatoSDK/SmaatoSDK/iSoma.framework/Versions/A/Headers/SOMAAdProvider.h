//
//  SOMADefaultAdProvider.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import <Foundation/Foundation.h>
#import "SOMAAdProviderDelegate.h"

@class SOMAAdSettings;
@protocol SOMAAdFetcher;

@interface SOMAAdProvider : NSObject
@property(nonatomic, weak) SOMAAdSettings* settings;
@property(nonatomic, strong) NSURL* passbackURL;
@property(nonatomic, weak) id<SOMAAdProviderDelegate> delegate;

// This is added to mock ad fetcher
@property(nonatomic, strong) id<SOMAAdFetcher> fetcher;


-(void)pause;
-(void)resume:(BOOL)shouldWaitForIntervalDuration;
@end
