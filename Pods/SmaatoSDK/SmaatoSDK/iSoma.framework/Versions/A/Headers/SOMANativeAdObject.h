//
//  SOMANativeAdObject.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import "SOMAAdObject.h"
#import "SOMAApiAdResponse.h"
#import "SOMANativeAssetObject.h"
#import <Foundation/Foundation.h>
#import "SOMANativeEventTrackerObject.h"

@interface SOMANativeAdObject : SOMAAdObject

/**
 The url of the image. Use this image to download and set image property.
 */
@property (nonatomic, readonly) NSURL *nativeURL;

/**
 Optional.
 Icon image.
 Max height: at least 50.
 Aspect ratio: 1:1.
 */
@property (nonatomic, readonly) NSURL *assetIconURL;

/**
 Required.
 Large image preview for the ad. At least one of two size variants required.
 Small Variant with max height at least 200 and max width at least 200, 267, or 382 aspect ratio: 1:1, 4:3, or 1.91:1.
 Large Variant with max height at least 627 and max width at least 627, 836, or 1198 aspect ratio: 1:1, 4:3, or 1.91:1.
 */
@property (nonatomic, readonly) NSURL *assetMainURL;

/**
 The text associated with the title element of the Native Ad.
 */
@property (nonatomic, readonly) NSString *title;

/**
 Descriptive text associated with the product or service being advertised.
 */
@property (nonatomic, readonly) NSString *descriptionText;

/**
 Rating of the product being offered to the user.
 */
@property (nonatomic, readonly) float rating;

/**
 Descriptive text describing a ‘call to action’ button for the destination URL.
 */
@property (nonatomic, readonly) NSString *CTAText;

/**
 Array that keeps all main image URLs. URLs of assets that belong to the image asset -> type of SOMANativeImageAssetObject class.
 */
@property (nonatomic, readonly) NSArray<NSURL *> *mainImages;

/**
 The list of asset objects. Each object may correspond to one of the title - SOMANativeTitleAssetObject, image - SOMANativeImageAssetObject, data - SOMANativeDataAssetObject objects. 
 */
@property (nonatomic, readonly) NSArray<SOMANativeAssetObject *> *assets;

/**
 Array of objects where each object specifies the type of event to track and the URLs/information to track them. 
 */
@property (nonatomic, readonly) NSArray<SOMANativeEventTrackerObject *> *eventTrackers;

@property UIView* mediaView;

/**
 Validates dictionary and creates adobject with all properties set
 
 @param apiResponse     Response from backend.
 @return                The initialized `SOMANativeAdObject` or `SOMAMediatedAd` or `nil` on failure.
 */
+ (SOMAAdObject *)nativeAdObjectWithResponse:(SOMAApiAdResponse *)apiResponse error:(NSError **)error;

/**
 Creates native adobject with specified properties
 
 @return        The initialized `SOMANativeAdObject`.
 */
+ (instancetype)nativeAdObjectWithURL:(NSURL *)nativeURL title:(NSString *)title descriptionText:(NSString *)text CTAText:(NSString *)CTAText rating:(float)rating;

@end
