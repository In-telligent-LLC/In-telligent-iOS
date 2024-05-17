//
//  SOMAAdFetcher.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import <Foundation/Foundation.h>
#import "SOMAAdParser.h"

typedef void(^SOMAAdFetcherCallback)(id ad, NSError* error);

@protocol SOMAAdFetcher <NSObject>
@property(nonatomic, strong) id<SOMAAdParser> parser;
@required
- (instancetype) initWithAdRequest:(NSURLRequest*)request;
- (void)fetch:(SOMAAdFetcherCallback)callback;
- (void)fetch:(NSURL*)url withCallback:(SOMAAdFetcherCallback)callback;
- (void)parse:(NSData*)data withResponse:(NSURLResponse*)response callback:(SOMAAdFetcherCallback)callback;
@end
