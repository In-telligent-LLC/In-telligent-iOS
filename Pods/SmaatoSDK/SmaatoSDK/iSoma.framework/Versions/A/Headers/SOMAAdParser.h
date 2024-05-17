//
//  SOMAAdRequestParser.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import <Foundation/Foundation.h>
#import "SOMAApiAdResponse.h"

@class SOMAAdObject;

@protocol SOMAAdParser <NSObject>
-(SOMAAdObject*)parseAdWithResponse:(SOMAApiAdResponse*)adResponse parsingError:(NSError**)error;
@end
