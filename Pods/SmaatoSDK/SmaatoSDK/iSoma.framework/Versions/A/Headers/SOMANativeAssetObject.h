//
//  SOMANativeAssetObject.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import <Foundation/Foundation.h>

@interface SOMANativeAssetObject : NSObject

/**
 Unique asset ID. Typically a counter for the array.
 */
@property(nonatomic, readonly) NSUInteger assetID;

/**
 Creates SOMANativeAssetObject with assetID property set
 
 @param assetID     Response from backend.
 @return            The initialized `SOMANativeAdObject` or `nil` on failure.
 */
- (id)initWithAssetID:(NSUInteger)assetID;

@end
