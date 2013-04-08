//
//  VBAlarmManager.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/11/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VBAlarm.h"

@interface VBAlarmManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong, readonly) NSArray *alarms;
@property (nonatomic, strong, readonly) NSArray *sortedAlarms;

+ (VBAlarmManager *)sharedManager;

- (VBAlarm *)createAlarm;
- (void)addAlarm:(VBAlarm *)alarm;
- (void)deleteAlarm:(VBAlarm *)alarm;

- (void)load;
- (void)save;
- (void)clear;

@end
