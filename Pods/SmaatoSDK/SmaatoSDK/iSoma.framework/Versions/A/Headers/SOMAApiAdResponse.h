//
//  SOMAApiAdResponse.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import "SOMATypes.h"
#import <Foundation/Foundation.h>

@interface SOMAApiAdResponse : NSObject

@property (nonatomic, readonly) SOMAAdFormat adFormat;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, readonly) NSData *receivedData;
@property (nonatomic, readonly) NSString* sci;

/**
 Designated initializer for type that encapsulates ad format and data received in network response.
 
 @param adFormat    format of the ad received in network response
 @param data        network response data
 @return            instance of `SOMAAPIAdResponse`
 */

- (instancetype)initWithAdFormat:(SOMAAdFormat)adFormat receivedData:(NSData *)data sessionId:(NSString *)sessionId smaatoCreativeID:(NSString*)sci;

@end
