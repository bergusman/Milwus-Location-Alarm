//
//  VBAppConfig.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/25/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VBConfig : NSObject

@property (nonatomic, copy, readonly) NSString *applicationID;
@property (nonatomic, copy, readonly) NSString *applicationWebsite;

@property (nonatomic, copy, readonly) NSString *milwusWebsite;

@property (nonatomic, copy, readonly) NSString *googleMapsAPIKey;
@property (nonatomic, copy, readonly) NSString *yandexMapsAPIKey;

@property (nonatomic, assign, readonly) double geocodingRadius;

@property (nonatomic, assign, readonly) BOOL offAlarmAfterFiring;

@property (nonatomic, assign, readonly) double metricDefaultRadius;
@property (nonatomic, assign, readonly) double imperialDefaultRadius;

@property (nonatomic, strong, readonly) NSDictionary *metricRadiusFunction;
@property (nonatomic, strong, readonly) NSDictionary *imperialRadiusFunction;
@property (nonatomic, strong, readonly) NSDictionary *distanceProgressFunction;

@property (nonatomic, strong, readonly) NSArray *metricRadiusRules;
@property (nonatomic, strong, readonly) NSArray *imperialRadiusRules;

@property (nonatomic, assign, readonly) BOOL useAnalytics;
@property (nonatomic, copy, readonly) NSString *analyticsTrackingID;
@property (nonatomic, assign, readonly) NSTimeInterval analyticsDispatchInterval;

@property (nonatomic, assign, readonly) BOOL useTestFlight;
@property (nonatomic, copy, readonly) NSString *appToken;
@property (nonatomic, assign, readonly) BOOL enableUDID;

@property (nonatomic, assign, readonly) BOOL useDevTools;

@property (nonatomic, strong, readonly) NSArray *dialogDonatePrices;
@property (nonatomic, strong, readonly) NSArray *dialogDonateIDs;
@property (nonatomic, strong, readonly) NSArray *aboutDonatePrices;
@property (nonatomic, strong, readonly) NSArray *aboutDonateIDs;

@property (nonatomic, copy, readonly) NSString *googlePlusClientID;

+ (VBConfig *)sharedConfig;

- (void)loadConfigFromFile:(NSString *)fileName;

@end
