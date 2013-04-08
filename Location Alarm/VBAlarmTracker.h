//
//  VBAlarmTracker.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/11/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const VBAlarmTrackerDidTriggerAlarmNotification;
extern NSString *const VBAlarmTrackerGPSAccuracyDidChangeNotification;
extern NSString *const VBAlarmTrackerAlarmUserInfoKey;


typedef enum {
    VBGPSAccuracyGood,
    VBGPSAccuracyBad
} VBGPSAccuracy;


@interface VBAlarmTracker : NSObject

@property (nonatomic, strong, readonly) NSDictionary *alarmDistances;

@property (nonatomic, assign, readonly) VBGPSAccuracy accuracy;

+ (VBAlarmTracker *)sharedTracker;

@end
