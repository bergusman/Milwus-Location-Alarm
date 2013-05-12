//
//  VBAlarmTracker.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/11/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBAlarmTracker.h"
#import "VBLocationManager.h"
#import "VBAlarmManager.h"


NSString *const VBAlarmTrackerDidTriggerAlarmNotification = @"VBAlarmTrackerDidTriggerAlarmNotification";
NSString *const VBAlarmTrackerGPSAccuracyDidChangeNotification = @"VBAlarmTrackerGPSAccuracyDidChangeNotification";
NSString *const VBAlarmTrackerAlarmUserInfoKey = @"VBAlarmTrackerAlarmUserInfoKey";


@interface VBAlarmTracker ()

@property (nonatomic, assign) VBGPSAccuracy accuracy;
@property (nonatomic, strong) NSMutableDictionary *into;

@end


@implementation VBAlarmTracker
{
    NSMutableDictionary *_alarmDistances;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    _alarmDistances = [[NSMutableDictionary alloc] init];
    _into = [[NSMutableDictionary alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLocationWithNotification:)
                                                 name:VBLocationManagerDidUpdateLocationNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authorizationStatusDidChange:)
                                                 name:VBLocationManagerDidChangeAuthorizationStatusNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alarmsChanged:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:[VBAlarmManager sharedManager].managedObjectContext];
    
    return self;
}

- (void)sendAlarmTriggeredNotificationWithAlarm:(VBAlarm *)alarm
{
    NSDictionary *userInfo = @{VBAlarmTrackerAlarmUserInfoKey : alarm};
    [[NSNotificationCenter defaultCenter] postNotificationName:VBAlarmTrackerDidTriggerAlarmNotification
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)setupLocationManagerWithDistance:(CLLocationDistance)distance
{
    
    
    /*
    if (distance < 50) {
        [VBLocationManager sharedManager].distanceFilter = 5;
        [VBLocationManager sharedManager].desiredAccuracy = kCLLocationAccuracyBest;
    } else if (distance < 500) {
        [VBLocationManager sharedManager].distanceFilter = 10;
        [VBLocationManager sharedManager].desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    } else if (distance < 1500) {
        [VBLocationManager sharedManager].distanceFilter = 50;
        [VBLocationManager sharedManager].desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    } else if (distance < 5000) {
        [VBLocationManager sharedManager].distanceFilter = 100;
        [VBLocationManager sharedManager].desiredAccuracy = kCLLocationAccuracyHundredMeters;
    } else {
        [VBLocationManager sharedManager].distanceFilter = 500;
        [VBLocationManager sharedManager].desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
     */
}

- (void)authorizationStatusDidChange:(NSNotification *)notification
{
    if ([VBLocationManager sharedManager].authorizationStatus == kCLAuthorizationStatusDenied) {
        [_alarmDistances removeAllObjects];
    }
}


#pragma mark - Location Updating

- (void)updateLocationWithNotification:(NSNotification *)notification
{
    [self updateLocationWithLocation:notification.userInfo[VBLocationManagerNewLocationUserInfoKey]];
}

- (void)updateLocation
{
    [self updateLocationWithLocation:[VBLocationManager sharedManager].location];
}

- (void)alarmsChanged:(NSNotification *)notification
{
    [self updateLocation];
}

- (void)updateLocationWithLocation:(CLLocation *)location
{
    if (!location) return;
    
    for (VBAlarm *alarm in [VBAlarmManager sharedManager].alarms) {
        CLLocationDistance distance = [location distanceFromLocation:[alarm location]];
        _alarmDistances[alarm.objectID] = @(distance - alarm.radius);
    }
    
    VBGPSAccuracy accuracy = location.horizontalAccuracy > 100 ? VBGPSAccuracyBad : VBGPSAccuracyGood;
    if (accuracy != self.accuracy) {
        [[NSNotificationCenter defaultCenter] postNotificationName:VBAlarmTrackerGPSAccuracyDidChangeNotification object:self];
        self.accuracy = accuracy;
    }
    
    if (accuracy == VBGPSAccuracyBad) return;
    
    return;
    
    CLLocationDistance minDistance = 40000000;
    
    for (VBAlarm *alarm in [VBAlarmManager sharedManager].alarms) {
        
        if (!alarm.on) continue;
        
        CLLocationDistance distance = [location distanceFromLocation:[alarm location]];
        _alarmDistances[alarm.objectID] = @(distance - alarm.radius);
        
        minDistance = MIN(minDistance, distance - alarm.radius);
        
        NSNumber *into = self.into[alarm.objectID];
        
        if (into) {
            if (distance < alarm.radius) {
                if (![into boolValue] && (alarm.type == VBAlarmTypeIn)) {
                    [self sendAlarmTriggeredNotificationWithAlarm:alarm];
                }
                self.into[alarm.objectID] = @YES;
                
            } else {
                if ([into boolValue]) {
                    if (distance > alarm.radius + 5) {
                        if (alarm.type == VBAlarmTypeOut) {
                            [self sendAlarmTriggeredNotificationWithAlarm:alarm];
                        }
                        self.into[alarm.objectID] = @NO;
                    }
                } else {
                    self.into[alarm.objectID] = @NO;
                }
            }
            
        } else {
            self.into[alarm.objectID] = @(distance < alarm.radius);
        }
    }
    
    [self setupLocationManagerWithDistance:minDistance];
}


#pragma mark - Singleton

static VBAlarmTracker *_sharedTracker;

+ (VBAlarmTracker *)sharedTracker
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTracker = [VBAlarmTracker new];
    });
    return _sharedTracker;
}

@end
