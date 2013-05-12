//
//  VBRegionManager.m
//  Location Alarm
//
//  Created by Vitaliy B on 12.05.13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBRegionManager.h"
#import <CoreLocation/CoreLocation.h>
#import "VBAlarmManager.h"

@interface VBRegionManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation VBRegionManager

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
}

#pragma mark - Singleton

+ (VBRegionManager *)sharedManager {
    static VBRegionManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[VBRegionManager alloc] init];
    });
    return _sharedManager;
}

@end
