//
//  VBRegionManager.h
//  Location Alarm
//
//  Created by Vitaliy B on 12.05.13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VBAlarm.h"

@interface VBRegionManager : NSObject

+ (VBRegionManager *)sharedManager;

- (void)startMonitoringAlarm:(VBAlarm *)alarm;
- (void)stopMonitoringAlarm:(VBAlarm *)alarm;

@end
