//
//  VBSettings.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/25/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    VBMapProviderApple,
    VBMapProviderGoogle,
    VBMapProviderYandex
} VBMapProvider;

typedef enum {
    VBMapTypeStandard,
    VBMapTypeSatellite,
    VBMapTypeHybrid,
    VBMapTypeTerrain,
    VBMapTypeSchema,
    VBMapTypePeoples
} VBMapType;

typedef enum {
    VBMeasurementSystemMetric,
    VBMeasurementSystemImperial
} VBMeasurementSystem;


@interface VBSettings : NSObject

@property (nonatomic, assign) VBMeasurementSystem system;
@property (nonatomic, assign) VBMapProvider mapProvider;
@property (nonatomic, assign) VBMapType mapType;

+ (VBSettings *)sharedSettings;

@end
