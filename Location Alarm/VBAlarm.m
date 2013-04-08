//
//  VBAlarm.m
//  Location Alarm 2
//
//  Created by Vitaliy Berg on 2/11/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBAlarm.h"


@implementation VBAlarm
{
    CLLocation *_location;
}

@dynamic title;
@dynamic notes;
@dynamic latitude;
@dynamic longitude;
@dynamic radius;
@dynamic type;
@dynamic sound;
@dynamic on;


- (CLLocation *)location
{
    if (!_location) {
        _location = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
    }
    return _location;
}

- (CLLocationCoordinate2D)coordinate
{
    return [self location].coordinate;
}

- (NSDictionary *)dictionaryRepresentation
{
    return @{
        @"objectID": [[self.objectID URIRepresentation] absoluteString],
        @"title": self.title ?: @"",
        @"notes": self.notes ?: @"",
        @"latitude": @(self.latitude),
        @"longitude": @(self.longitude),
        @"radius": @(self.radius),
        @"type": @(self.type),
        @"sound": self.sound ?: @"",
        @"on": @(self.on)
    };
}

@end
