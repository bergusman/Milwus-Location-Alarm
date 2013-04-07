//
//  VBAppConfig.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/25/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBConfig.h"

@interface VBConfig ()

@property (nonatomic, copy) NSString *applicationID;
@property (nonatomic, copy) NSString *applicationWebsite;

@property (nonatomic, copy) NSString *milwusWebsite;

@property (nonatomic, copy) NSString *googleMapsAPIKey;
@property (nonatomic, copy) NSString *yandexMapsAPIKey;

@property (nonatomic, assign) double geocodingRadius;

@property (nonatomic, assign) BOOL offAlarmAfterFiring;

@property (nonatomic, assign) double metricDefaultRadius;
@property (nonatomic, assign) double imperialDefaultRadius;

@property (nonatomic, retain) NSDictionary *metricRadiusFunction;
@property (nonatomic, retain) NSDictionary *imperialRadiusFunction;
@property (nonatomic, retain) NSDictionary *distanceProgressFunction;

@property (nonatomic, retain) NSArray *metricRadiusRules;
@property (nonatomic, retain) NSArray *imperialRadiusRules;

@property (nonatomic, assign) BOOL useAnalytics;
@property (nonatomic, copy) NSString *analyticsTrackingID;
@property (nonatomic, assign) NSTimeInterval analyticsDispatchInterval;

@property (nonatomic, assign) BOOL useTestFlight;
@property (nonatomic, copy) NSString *appToken;
@property (nonatomic, assign) BOOL enableUDID;

@property (nonatomic, assign) BOOL useDevTools;

@property (nonatomic, retain) NSArray *dialogDonatePrices;
@property (nonatomic, retain) NSArray *dialogDonateIDs;
@property (nonatomic, retain) NSArray *aboutDonatePrices;
@property (nonatomic, retain) NSArray *aboutDonateIDs;

@property (nonatomic, copy) NSString *googlePlusClientID;

@end

@implementation VBConfig

- (void)loadConfigFromFile:(NSString *)fileName
{
    [self clearConfig];
    
    NSURL *configURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfURL:configURL];
    
    self.applicationID = config[@"Application ID"];
    self.applicationWebsite = config[@"Application Website"];
    self.milwusWebsite = config[@"Milwus Website"];
    self.googleMapsAPIKey = config[@"Google Maps API Key"];
    self.yandexMapsAPIKey = config[@"Yandex Maps API Key"];
    self.geocodingRadius = [config[@"Geocoding Region Radius"] doubleValue];
    self.offAlarmAfterFiring = [config[@"Turn Off Alarm After Firing"] boolValue];
    self.metricDefaultRadius = [config[@"Metric Default Radius"] doubleValue];
    self.imperialDefaultRadius = [config[@"Imperial Default Radius"] doubleValue];
    self.metricRadiusFunction = config[@"Metric Radius Function"];
    self.imperialRadiusFunction = config[@"Imperial Radius Function"];
    self.distanceProgressFunction = config[@"Distance Progress Function"];
    self.metricRadiusRules = config[@"Metric Radius Slider Rules"];
    self.imperialRadiusRules = config[@"Imperial Radius Slider Rules"];
    self.useAnalytics = [config[@"Google Analytics"][@"Use Google Analytics"] boolValue];
    self.analyticsTrackingID = config[@"Google Analytics"][@"Tracking ID"];
    self.analyticsDispatchInterval = [config[@"Google Analytics"][@"Dispatch Interval"] doubleValue];
    self.useTestFlight = [config[@"TestFlight"][@"Use TestFlight"] boolValue];
    self.appToken = config[@"TestFlight"][@"App Token"];
    self.enableUDID = [config[@"TestFlight"][@"Enable UDID"] boolValue];
    self.useDevTools = [config[@"Use Dev Tools"] boolValue];
    self.dialogDonatePrices = config[@"Donating"][@"Dialog Prices"];
    self.dialogDonateIDs = config[@"Donating"][@"Dialog Product IDs"];
    self.aboutDonatePrices = config[@"Donating"][@"About Prices"];
    self.aboutDonateIDs = config[@"Donating"][@"About Product IDs"];
    self.googlePlusClientID = config[@"Google Plus"][@"Client ID"];
}

- (void)clearConfig
{
    self.applicationID = nil;
    self.applicationWebsite = nil;
    self.milwusWebsite = nil;
    self.googleMapsAPIKey = nil;
    self.yandexMapsAPIKey = nil;
    self.geocodingRadius = 0;
    self.offAlarmAfterFiring = NO;
    self.metricDefaultRadius = 0;
    self.imperialDefaultRadius = 0;
    self.metricRadiusFunction = nil;
    self.imperialRadiusFunction = nil;
    self.distanceProgressFunction = nil;
    self.metricRadiusRules = nil;
    self.imperialRadiusRules = nil;
    self.useAnalytics = NO;
    self.analyticsTrackingID = nil;
    self.analyticsDispatchInterval = 0;
    self.useTestFlight = NO;
    self.appToken = nil;
    self.enableUDID = NO;
    self.useDevTools = NO;
    self.dialogDonatePrices = nil;
    self.dialogDonateIDs = nil;
    self.aboutDonatePrices = nil;
    self.aboutDonateIDs = nil;
    self.googlePlusClientID = nil;
}


#pragma mark - Singleton

static VBConfig *_sharedConfig;

+ (VBConfig *)sharedConfig
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConfig = [VBConfig new];
    });
    return _sharedConfig;
}

- (id)retain { return self; }
- (NSUInteger)retainCount { return NSUIntegerMax; }
- (oneway void)release { }
- (id)autorelease { return self; }

@end
