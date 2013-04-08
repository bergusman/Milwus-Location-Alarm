//
//  IPKLocationManager.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/4/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBLocationManager.h"

#import <CoreLocation/CoreLocation.h>


NSString *const VBLocationManagerDidUpdateLocationNotification = @"VBLocationManagerDidUpdateLocationNotification";
NSString *const VBLocationManagerDidChangeAuthorizationStatusNotification = @"VBLocationManagerDidChangeAuthorizationStatusNotification";
NSString *const VBLocationManagerNewLocationUserInfoKey = @"VBLocationManagerNewLocationUserInfoKey";
NSString *const VBLocationManagerOldLocationUserInfoKey = @"VBLocationManagerOldLocationUserInfoKey";


@interface VBLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end


@implementation VBLocationManager

@dynamic location;
@dynamic distanceFilter;
@dynamic desiredAccuracy;

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    return self;
}

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
}

- (CLLocation *)location
{
    return self.locationManager.location;
}

- (CLAuthorizationStatus)authorizationStatus
{
    return [CLLocationManager authorizationStatus];
}

- (BOOL)locationServicesEnabled
{
    return [CLLocationManager locationServicesEnabled];
}


#pragma mark - Distance filter

- (CLLocationDistance)distanceFilter
{
    return self.locationManager.distanceFilter;
}

- (void)setDistanceFilter:(CLLocationDistance)distanceFilter
{
    self.locationManager.distanceFilter = distanceFilter;
}


#pragma mark - Desired Accuracy

- (CLLocationAccuracy)desiredAccuracy
{
    return self.locationManager.desiredAccuracy;
}

- (void)setDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy
{
    self.locationManager.desiredAccuracy = desiredAccuracy;
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation"); // TODO: remove it
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    if (newLocation) userInfo[VBLocationManagerNewLocationUserInfoKey] = newLocation;
    if (oldLocation) userInfo[VBLocationManagerOldLocationUserInfoKey] = oldLocation;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VBLocationManagerDidUpdateLocationNotification
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"didChangeAuthorizationStatus: %d", status); // TODO: remove it
    [[NSNotificationCenter defaultCenter] postNotificationName:VBLocationManagerDidChangeAuthorizationStatusNotification
                                                        object:self
                                                      userInfo:nil];
}


#pragma mark - Singleton

static VBLocationManager *_sharedManager;

+ (VBLocationManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [VBLocationManager new];
    });
    return _sharedManager;
}

@end
