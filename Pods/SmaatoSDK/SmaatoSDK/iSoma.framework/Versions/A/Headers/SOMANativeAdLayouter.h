//
//  SOMANativeAdLayouter.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import <Foundation/Foundation.h>

@class SOMANativeAd;
@class SOMANativeAdTemplateView;


@protocol SOMANativeAdLayouter <NSObject>
- (void)layout:(SOMANativeAdTemplateView*)view;
- (void)modifyNativeComponentsInNativeAd:(SOMANativeAd*)nativeAd fromTamplateView:(SOMANativeAdTemplateView*)templateView;
@end
