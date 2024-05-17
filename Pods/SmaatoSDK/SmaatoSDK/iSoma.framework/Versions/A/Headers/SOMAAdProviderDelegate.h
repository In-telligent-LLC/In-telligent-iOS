//
//  SOMAAdProviderDelegate.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import <Foundation/Foundation.h>
#import "SOMAAdObject.h"

@class SOMAAdProvider;

@protocol SOMAAdProviderDelegate <NSObject>
@required
-(void)adProvider:(SOMAAdProvider*)provider didProvideAd:(SOMAAdObject*)ad;
-(void)adProvider:(SOMAAdProvider*)provider didProvidedMediationResponse:(NSArray*)mediatedNetworks;
-(void)adProvider:(SOMAAdProvider*)provider didFailed:(NSError*)error;
@end
