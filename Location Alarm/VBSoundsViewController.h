//
//  VBSoundsViewController.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/25/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBOnBack.h"

@interface VBSoundsViewController : UIViewController

@property (nonatomic, copy) void (^onBack)();

@property (nonatomic, copy) NSString *sound;

@end
