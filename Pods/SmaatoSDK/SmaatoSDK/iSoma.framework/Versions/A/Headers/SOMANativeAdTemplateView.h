//
//  SOMANativeAdLayout.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import <UIKit/UIKit.h>
#import "SOMANativeAdLayouter.h"

@class SOMAStarView;
@class SOMANativeAdObject;
@class SOMANativeAd;

@interface SOMANativeAdTemplateView : UIView
@property UIImageView* mainImage;
@property UIImageView* icon;
@property UILabel* title;
@property UILabel* details;
@property UIButton* callToAction;
@property SOMAStarView* ratingView;
@property UILabel* sponsored;
@property UICollectionView* carousel;


@property UIView* catContainer;
@property SOMANativeAdObject* adObject;
@property id<SOMANativeAdLayouter> layouter;

- (instancetype)initWithLayouter:(id<SOMANativeAdLayouter>)layouter;
- (void)modifyNativeComponentsInNativeAd:(SOMANativeAd*)nativeAd;

@end
