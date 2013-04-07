//
//  VBAlarmDetailsViewController.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/25/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBOnBack.h"

@class VBAlarm;

@interface VBAlarmDetailsViewController : UIViewController <VBOnBack>

@property (nonatomic, copy) void (^onBack)();

- (id)initWithAlarm:(VBAlarm *)alarm;

@end
