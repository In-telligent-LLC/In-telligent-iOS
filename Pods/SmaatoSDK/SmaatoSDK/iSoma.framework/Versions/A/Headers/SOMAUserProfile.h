//
//  SOMAUserProfile.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import <Foundation/Foundation.h>
#import "SOMATypes.h"

@interface SOMAUserProfile : NSObject<NSCopying>
@property(nonatomic, assign) NSInteger age;
@property(nonatomic, assign) SOMAUserGender gender;
@property(nonatomic, assign) NSString* dateOfBirthYYYYMMDD DEPRECATED_MSG_ATTRIBUTE("From API v600 the 'dateOfBirthYYYYMMDD' request param is not supported");;
@property(nonatomic, assign) SOMAUserYearlyIncome yearlyIncome DEPRECATED_MSG_ATTRIBUTE("From API v600 the 'yearlyIncome' request param is not supported");
@property(nonatomic, assign) SOMAUserEthnicity ethnicity DEPRECATED_MSG_ATTRIBUTE("From API v600 the 'ethnicity' request param is not supported");
@property(nonatomic, assign) SOMAUserEducation education DEPRECATED_MSG_ATTRIBUTE("From API v600 the 'education' request param is not supported");
@property(nonatomic, assign) SOMAUserGenderInterest interestedIn DEPRECATED_MSG_ATTRIBUTE("From API v600 the 'interestedIn' request param is not supported");
@property(nonatomic, assign) SOMAUserMaritalStatus maritalStatus DEPRECATED_MSG_ATTRIBUTE("From API v600 the 'maritalStatus' request param is not supported");
@property(nonatomic, strong) NSString* country DEPRECATED_MSG_ATTRIBUTE("From API v600 the 'country' request param is not supported");
@property(nonatomic, strong) NSString* countryCode DEPRECATED_MSG_ATTRIBUTE("From API v600 the 'countryCode' request param is not supported");
@property(nonatomic, strong) NSString* region;
@property(nonatomic, strong) NSString* city DEPRECATED_MSG_ATTRIBUTE("From API v600 the 'city' request param is not supported");
@property(nonatomic, strong) NSString* zip;
@end
