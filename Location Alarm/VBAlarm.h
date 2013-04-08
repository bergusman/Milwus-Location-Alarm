//
//  VBAlarm.h
//  Location Alarm 2
//
//  Created by Vitaliy Berg on 2/11/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>


typedef enum {
    VBAlarmTypeIn,
    VBAlarmTypeOut
} VBAlarmType;


@interface VBAlarm : NSManagedObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic) CLLocationDistance radius;
@property (nonatomic) VBAlarmType type;
@property (nonatomic, strong) NSString *sound;
@property (nonatomic) BOOL on;

- (CLLocation *)location;
- (CLLocationCoordinate2D)coordinate;

- (NSDictionary *)dictionaryRepresentation;

@end
