//
//  VBHelpViewController.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/25/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBOnBack.h"

@interface VBHelpViewController : UIViewController <VBOnBack>

@property (nonatomic, assign) BOOL showsCloseButton;

@property (nonatomic, copy) void (^onBack)();

@end
