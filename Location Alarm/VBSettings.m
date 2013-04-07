//
//  VBSettings.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/25/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBSettings.h"


#define VBMeasurementSystemKey @"VBMeasurementSystem"
#define VBMapProviderKey @"VBMapProvider"
#define VBMapTypeKey @"VBMapType"


@implementation VBSettings

@dynamic system, mapType, mapProvider;

- (void)setSystem:(VBMeasurementSystem)system
{
    [[NSUserDefaults standardUserDefaults] setInteger:system forKey:VBMeasurementSystemKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (VBMeasurementSystem)system
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:VBMeasurementSystemKey];
}

- (void)setMapProvider:(VBMapProvider)mapProvider
{
    [[NSUserDefaults standardUserDefaults] setInteger:mapProvider forKey:VBMapProviderKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (VBMapProvider)mapProvider
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:VBMapProviderKey];
}

- (void)setMapType:(VBMapType)mapType
{
    [[NSUserDefaults standardUserDefaults] setInteger:mapType forKey:VBMapTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (VBMapType)mapType
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:VBMapTypeKey];
}

#pragma mark - Singleton

static VBSettings *_sharedSettings;

+ (VBSettings *)sharedSettings
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSettings = [VBSettings new];
    });
    return _sharedSettings;
}

- (id)retain { return self; }
- (NSUInteger)retainCount { return NSUIntegerMax; }
- (oneway void)release { }
- (id)autorelease { return self; }


@end
