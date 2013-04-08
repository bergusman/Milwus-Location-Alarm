//
//  VBAlarmManager.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/11/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBAlarmManager.h"


@implementation VBAlarmManager
{
    NSMutableArray *_sortedAlarms;
    NSMutableArray *_alarms;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


#pragma mark - Alarms Methods

- (VBAlarm *)createAlarm
{
    VBAlarm *alarm = [NSEntityDescription insertNewObjectForEntityForName:@"Alarm"
                                                   inManagedObjectContext:self.managedObjectContext];
    if (!alarm) {
        // TODO: handle error
        return nil;
    }
    return alarm;
}

- (void)addAlarm:(VBAlarm *)alarm
{
    [_alarms addObject:alarm];
    [_sortedAlarms addObject:alarm];
    [self sortAlarms];
}

- (void)deleteAlarm:(VBAlarm *)alarm
{
    [self.managedObjectContext deleteObject:alarm];
    [_alarms removeObject:alarm];
    [_sortedAlarms removeObject:alarm];
}


#pragma mark - Data Base Methods

- (void)load
{
    [self clear];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Alarm"
                                              inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
    
    NSError *error = nil;
    
    _alarms = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    _sortedAlarms = [_alarms mutableCopy];
    [self sortAlarms];
    
    if (error) {
        [self handleError:error];
        return;
    }
}

- (void)save
{
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        [self handleError:error];
    }
    [self sortAlarms];
}

- (void)clear
{
    _alarms = nil;
    _sortedAlarms = nil;
}


#pragma mark - Helpers

- (void)sortAlarms
{
    [_sortedAlarms sortUsingComparator:^NSComparisonResult(VBAlarm *obj1, VBAlarm *obj2) {
        return [obj1.title compare:obj2.title];
    }];
}

- (void)handleError:(NSError *)error
{
    // TODO: handle error
}


#pragma mark - Singleton

static VBAlarmManager *_sharedManager;

+ (VBAlarmManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [VBAlarmManager new];
    });
    return _sharedManager;
}

@end
