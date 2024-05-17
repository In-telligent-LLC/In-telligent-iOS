//
//  SOMARichmediaAdObject.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import "SOMAAdObject.h"
#import "SOMAApiAdResponse.h"

@interface SOMARichmediaAdObject : SOMAAdObject

/**
 The javascript code that needs to be rendered on the screen.
 */
@property (nonatomic, readonly) NSString *content;

/**
 The width of the creative.
 */
@property (nonatomic, readonly) NSUInteger width;

/**
 The height of the creative
 */
@property (nonatomic, readonly) NSUInteger height;

/**
 Validates dictionary and creates adobject with all properties set
 
 @param apiResponse     Response from backend.
 @return                The initialized `SOMARichmediaAdObject` or `nil` on failure.
 */
+ (instancetype)richmediaAdObjectWithResponse:(SOMAApiAdResponse *)apiResponse error:(NSError **)error;

@end
