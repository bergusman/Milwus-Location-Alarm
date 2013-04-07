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

@property (nonatomic, retain, readonly) NSDictionary *metricRadiusFunction;
@property (nonatomic, retain, readonly) NSDictionary *imperialRadiusFunction;
@property (nonatomic, retain, readonly) NSDictionary *distanceProgressFunction;

@property (nonatomic, retain, readonly) NSArray *metricRadiusRules;
@property (nonatomic, retain, readonly) NSArray *imperialRadiusRules;

@property (nonatomic, assign, readonly) BOOL useAnalytics;
@property (nonatomic, copy, readonly) NSString *analyticsTrackingID;
@property (nonatomic, assign, readonly) NSTimeInterval analyticsDispatchInterval;

@property (nonatomic, assign, readonly) BOOL useTestFlight;
@property (nonatomic, copy, readonly) NSString *appToken;
@property (nonatomic, assign, readonly) BOOL enableUDID;

@property (nonatomic, assign, readonly) BOOL useDevTools;

@property (nonatomic, retain, readonly) NSArray *dialogDonatePrices;
@property (nonatomic, retain, readonly) NSArray *dialogDonateIDs;
@property (nonatomic, retain, readonly) NSArray *aboutDonatePrices;
@property (nonatomic, retain, readonly) NSArray *aboutDonateIDs;

@property (nonatomic, copy, readonly) NSString *googlePlusClientID;

+ (VBConfig *)sharedConfig;

- (void)loadConfigFromFile:(NSString *)fileName;

@end
