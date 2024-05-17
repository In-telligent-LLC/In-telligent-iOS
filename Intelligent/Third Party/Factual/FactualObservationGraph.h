/*
 * Use of this software is subject to the terms and
 * conditions of the license agreement between you
 * and Factual Inc
 *
 * Copyright © 2017 Factual Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#ifndef __cplusplus
@import SystemConfiguration.CaptiveNetwork;
@import UIKit;
@import CoreLocation;
@import Dispatch;
@import Darwin.sys.sysctl;
@import CoreTelephony;
@import CoreMotion;
@import Accelerate;
@import AdSupport;
#endif

/**
A user defined circumstance.  For more on Circumstances,
see <a href="http://developer.factual.com/engine/circumstances/">Factual's developer docs</a>.
*/
@interface FactualCircumstance : NSObject

/** The id of the circumstance. */
@property (readonly, nonnull) NSString *circumstanceId;

/** The circumstance expression. */
@property (readonly, nonnull) NSString *expr;

/** The action-id associated with the circumstance */
@property (readonly, nonnull) NSString *actionId;

/**
A recognizable name for the circumstance.
If a name is not provided during initalization
a default vaue of "NOT_PROVIDED_BY_USER" will be used.
*/
@property (readonly, nonnull) NSString *name;

/**
Constructs a FactualCircumstance object.

Name field is set to default value of "NOT_PROVIDED_BY_USER".

@param id The id of the circumstance.
@param expr The circumstance expression.
@param actionId The action-id associated with the circumstance
@return A FacutalCircumstance object.
*/
- (nonnull instancetype)initWithId:(nonnull NSString *)id expr:(nonnull NSString *)expr actionId:(nonnull NSString *)actionId;

/**
Constructs a FactualCircumstance object.

@param id The id of the circumstance.
@param expr The circumstance expression.
@param actionId The action-id associated with the circumstance
@param name The recognizable name of the circumstance
@return A FacutalCircumstance object.
*/
- (nonnull instancetype)initWithId:(nonnull NSString *)id expr:(nonnull NSString *)expr actionId:(nonnull NSString *)actionId name:(nonnull NSString *)name;

/**
Returns the FactualCircumstance as a NSDictionary.

@return The FactualCircumstance as a NSDictionary.
*/
- (nonnull NSDictionary *)toDict;
@end

/** For reporting Factual error messages. */
@interface FactualError : NSObject

/** The FactualError code */
@property (readonly) int code;

/** The FactualError message text. */
@property (readonly, nonnull) NSString *message;

/**
Constructs a FactualError object.

@param message The error message text.
@param code The error code
@return A FactualError object.
*/
- (nonnull instancetype)initWithMessage:(nonnull NSString *)message code:(int)code;
@end

/** Information about circumstance configurations from Garage. */
@interface FactualGarageRelease : NSObject

/** The id of the Garage release. */
@property (readonly, nonnull) NSString *releaseId;

/** The app's circumstances defined in the Garage. */
@property (readonly, nullable) NSArray<FactualCircumstance *> *circumstances;

/**
Constructs a FactualGarageRelease object.

@param releaseId The id of the Garage release.
@param circumstances The app's circumstances defined in the Garage.
@return A FactualGarageRelease object.
*/
- (nonnull instancetype)initWithReleaseId:(nonnull NSString *)releaseId circumstances:(nullable NSArray<FactualCircumstance *> *)circumstances;

/**
Returns the FactualGarageRelease as a NSDictionary.

@return The FactualGarageRelease as a NSDictionary.
*/
- (nonnull NSDictionary *)toDict;
@end

/** Contains metadata about the configuration downloaded from Factual's servers. */
@interface FactualConfigMetadata : NSObject

/** The time at which the config was downloaded. */
@property (readonly, nonnull) NSDate *timestamp;

/** The amount of data in KB stored in the SDK's on-device buffer before sending that data to the server. */
@property (readonly) int sendBufferSizeKb;

/** The maximum size of the on-device data buffer in KB. */
@property (readonly) int maxBufferSizeKb;

/** The current version of the SDK. */
@property (readonly, nonnull) NSString *version;

/** Information specific to circumstance configurations from Garage. */
@property (readonly, nullable) FactualGarageRelease *garageRelease;

/**
Constructs a FactualConfigMetadata object.

@param timestamp The time at which the config was downloaded.
@param sendBufferSizeKb The amount of data in KB stored in the SDK's on-device buffer before sending that data to the server.
@param maxBufferSizeKb The maximum size of the on-device data buffer in KB.
@param version The current version of the SDK.
@param garageRelease Information specific to circumstance configurations from Garage.
@return A FactualConfigMetadata object.
*/
- (nonnull instancetype)initWithTimestamp:(nonnull NSDate *)timestamp sendBufferSizeKb:(int)sendBufferSizeKb maxBufferSizeKb:(int)maxBufferSizeKb version:(nonnull NSString *)version garageRelease:(nullable FactualGarageRelease *)garageRelease;

/**
Returns the FactualConfigMetadata as a NSDictionary.

@return The FactualConfigMetadata as a NSDictionary.
*/
- (nonnull NSDictionary *)toDict;
@end

/** A general delegate for the sdk. */
@protocol FactualObservationGraphDelegate <NSObject>

/** Called when the sdk started successfully. */
- (void)factualObservationGraphDidStart;

/** Called when the sdk stopped successfully. */
- (void)factualObservationGraphDidStop;

/**
Called when an error occurs in the sdk and provides a FactualError.

@param factualError The error that occurred.
*/
- (void)factualObservationGraphDidFailWithError:(nonnull FactualError *)factualError;

/**
Called when an info message is sent by the sdk.

@param infoMessage The info message sent by the sdk.
*/
- (void)factualObservationGraphDidReportInfo:(nonnull NSString *)infoMessage;

/**
Called when a new config is loaded with metadata.

@param data Metadata about the new config downloaded.
*/
- (void)factualObservationGraphDidLoadConfig:(nonnull FactualConfigMetadata *)data;

/**
Called when a structured diagnostic message is available. This diagnostic information can be
used to determine if the SDK is working correctly.

@param diagnosticMessage A diagnostic message structured as a JSON string.
*/
- (void)factualObservationGraphDidReportDiagnosticMessage:(nonnull NSString *)diagnosticMessage;
@end

/**
The main singleton for using the Observation Graph SDK.
*/
@interface FactualObservationGraph : NSObject

/**
Starts the SDK asynchronously.  Starting the SDK loads configurations and starts sensor collection.
and begins monitoring for circumstance occurrences.  This function begins an asynchronous start
Once the entire start process is complete, the FactualObservationGraphDelegate's
factualObservationGraphDidStart will be called.

@param key A valid Factual api-key.
@param delegate A FactualObservationGraphDelegate to receive SDK callbacks.
*/
+ (void)startWithApiKey:(nonnull NSString *)key delegate:(nonnull id<FactualObservationGraphDelegate>)delegate;

/**
Stops the SDK. Stopping the SDK stops sensor collection. This function begins an asynchronous stop sequence,
and thus returns immediately. Once the entire stop process is complete,
the FactualObservationGraphDelegate's factualObservationGraphDidStop function is called.
*/
+ (void)stop;

/**
Returns the sdk's version string.

@return the sdk's version string
*/
+ (nonnull NSString *)sdkVersion;

/**
Forces telemetry to be sent to the telemetry server. The SDK must be started to call this.
Success is notified by an info message stating "Forced telemetry send successful."
*/
+ (void)forceTelemetrySend;

@end
