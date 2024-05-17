//
//  SOMABeaconCallingAgent.h
//  iSoma
//
//  Copyright © 2019 Smaato Inc. All rights reserved.￼
//  Licensed under the Smaato SDK License Agreement￼
//  https://www.smaato.com/sdk-license-agreement/
//

#import "SOMAAdObject.h"
#import <Foundation/Foundation.h>

@class SOMAAdObject;
@class SOMAAdSettings;
@class SOMABeaconCallingAgent;

// The callbback block definition. Used to remove an agent from the registry
typedef void(^SOMABeaconCallingAgentCallback)(SOMABeaconCallingAgent* agent);

/**
 This class calls beacons in a webview so that non-SSL/http beacons can be also called.
 
 However no need to instantiate this class, rather use the helper class methods
 like `loadBeacon:`
 
  - attention: This is to be used inside the SDK only. Not for publishers.
*/
@interface SOMABeaconCallingAgent : NSObject

/**
 * List of urls that has been successfully loaded from the WKWebView using IMG html tag.
 */
@property NSArray* urlsCalled;

/**
 * A flag which is set when the webview finshed loading all the beacon images.
 */
@property BOOL isCompleted;

/**
 * Call this method to load a single beacon. This is a syntactic suger for the `loadBeacons:` method.
 * 
 * @param url A beacon URL as NSString
 * @return An instance of this class. Typically only needed in Unit Testing
 */
+ (SOMABeaconCallingAgent*)loadBeacon:(NSString*)url forAd:(SOMAAdObject*)ad withSettings:(SOMAAdSettings*)settings;

/**
 * Call this method to load a single beacon
 *
 * @param urls Beacon urls as an array.
 * @return An instance of this class. Typically only needed in Unit Testing
 */
+ (SOMABeaconCallingAgent*)loadBeacons:(NSArray*)urls forAd:(SOMAAdObject*)ad withSettings:(SOMAAdSettings*)settings;

/**
 * Use this method to get the live agents. Mainly for Unit Testing
 *
 * @return An array of agents which are still loading the beacons
 */
+ (NSArray*)activeAgents;

/**
 * Returns number of agents still not deallocated. On counter is incremented on 
 * every instantiation and decremented in dealloc method
 *
 * @return An int value
 */
+ (int)numberOfagentsNoteallocated;

/**
 * Resets the number of not deallocated agent count.
 *
 */
+ (void)resetNumberOfagentsNoteallocated;

- (instancetype) initWithURL:(NSArray*)urlList forAdObject:(SOMAAdObject*)ad withSettings:(SOMAAdSettings*)settings callback:(SOMABeaconCallingAgentCallback)callback;

@end
