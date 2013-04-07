//
//  IPKLocationManager.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/4/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


extern NSString *const VBLocationManagerDidUpdateLocationNotification;
extern NSString *const VBLocationManagerDidChangeAuthorizationStatusNotification;
extern NSString *const VBLocationManagerNewLocationUserInfoKey;
extern NSString *const VBLocationManagerOldLocationUserInfoKey;


@interface VBLocationManager : NSObject

@property(nonatomic, assign) CLLocationDistance distanceFilter;
@property(nonatomic, assign) CLLocationAccuracy desiredAccuracy;

@property (nonatomic, readonly) CLLocation *location;

+ (VBLocationManager *)sharedManager;

- (void)startUpdatingLocation;

- (void)stopUpdatingLocation;

- (CLAuthorizationStatus)authorizationStatus;

- (BOOL)locationServicesEnabled;

@end
