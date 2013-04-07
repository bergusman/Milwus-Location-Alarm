//
//  VBMapController.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/17/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>

@class SVPlacemark;
@class VBAlarm;
@protocol VBMapControllerDelegate;


@protocol VBMapController <NSObject>

+ (NSString *)localizedName;

@property (nonatomic, assign) id<VBMapControllerDelegate> delegate;

@property (nonatomic, assign) VBMapType mapType;
- (NSArray *)supportedMapTypes;

@property (nonatomic, assign) BOOL showsUserLocation;
@property (nonatomic, retain, readonly) CLLocation *userLocation;
- (void)showUserLocationAnimated:(BOOL)animated;

@property (nonatomic, assign) MKCoordinateRegion region;
- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)animated;

- (void)showPlacemark:(SVPlacemark *)placemark animated:(BOOL)animated;

- (CLLocationCoordinate2D)coordinateForPoint:(CGPoint)point;

- (void)addAlarm:(VBAlarm *)alarm;
- (void)addAlarms:(NSArray *)alarms;

- (void)removeAlarm:(VBAlarm *)alarm;
- (void)removeAlarms:(NSArray *)alarms;
- (void)removeAllAlarms;
- (void)removeAlarmWithObjectID:(NSManagedObjectID *)objectID;

- (void)updateAlarm:(VBAlarm *)alarm;
- (void)updateAlarms:(NSArray *)alarms;
- (void)updateAllAlarms;
- (void)updateAlarmProgresses;

@end


@protocol VBMapControllerDelegate <NSObject>

@optional
- (void)mapController:(id<VBMapController>)mapController didChooseAlarm:(VBAlarm *)alarm;

@end
