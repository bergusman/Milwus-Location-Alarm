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
#import "VBAlarmTracker.h"

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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alarmsChanged:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:[VBAlarmManager sharedManager].managedObjectContext];
    
    return self;
}

- (CLRegion *)regionWithIdentifier:(NSString *)identifier {
    for (CLRegion *region in self.locationManager.monitoredRegions) {
        if ([region.identifier isEqualToString:identifier]) {
            return region;
        }
    }
    return nil;
}

- (VBAlarm *)alarmWithIdentifier:(NSString *)identifier {
    for (VBAlarm *alarm in [VBAlarmManager sharedManager].alarms) {
        if ([[[alarm.objectID URIRepresentation] absoluteString] isEqualToString:identifier]) {
            return alarm;
        }
    }
    return nil;
}

- (void)alarmsChanged:(NSNotification *)notificaiton {
    for (VBAlarm *alarm in notificaiton.userInfo[NSInsertedObjectsKey]) {
        if (alarm.on) {
            [self startMonitoringAlarm:alarm];
        } else {
            [self stopMonitoringAlarm:alarm];
        }
    }
    
    for (VBAlarm *alarm in notificaiton.userInfo[NSUpdatedObjectsKey]) {
        if (alarm.on) {
            [self startMonitoringAlarm:alarm];
        } else {
            [self stopMonitoringAlarm:alarm];
        }
    }
    
    for (VBAlarm *alarm in notificaiton.userInfo[NSDeletedObjectsKey]) {
        [self stopMonitoringAlarm:alarm];
    }
}

- (void)sendAlarmTriggeredNotificationWithAlarm:(VBAlarm *)alarm
{
    NSDictionary *userInfo = @{VBAlarmTrackerAlarmUserInfoKey : alarm};
    [[NSNotificationCenter defaultCenter] postNotificationName:VBAlarmTrackerDidTriggerAlarmNotification
                                                        object:self
                                                      userInfo:userInfo];
}

#pragma mark - Public Methods

- (void)startMonitoringAlarm:(VBAlarm *)alarm {
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(alarm.latitude, alarm.longitude);
    NSString *identifier = [[alarm.objectID URIRepresentation] absoluteString];
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:center
                                                               radius:alarm.radius
                                                           identifier:identifier];
    [self.locationManager startMonitoringForRegion:region];
}

- (void)stopMonitoringAlarm:(VBAlarm *)alarm {
    NSString *identifier = [[alarm.objectID URIRepresentation] absoluteString];
    CLRegion *region = [self regionWithIdentifier:identifier];
    [self.locationManager stopMonitoringForRegion:region];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    VBAlarm *alarm = [self alarmWithIdentifier:region.identifier];
    if (alarm && alarm.type == VBAlarmTypeIn) {
        [self sendAlarmTriggeredNotificationWithAlarm:alarm];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    VBAlarm *alarm = [self alarmWithIdentifier:region.identifier];
    if (alarm && alarm.type == VBAlarmTypeOut) {
        [self sendAlarmTriggeredNotificationWithAlarm:alarm];
    }
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
