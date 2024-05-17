//
//  SOMAExtension.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import <Foundation/Foundation.h>

@protocol SOMAExtension <NSObject>
@property NSString* script;
@property NSDictionary* conf;
@property NSString* name;
@end
