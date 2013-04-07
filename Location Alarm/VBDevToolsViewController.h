//
//  VBDevToolsViewController.h
//  Location Alarm
//
//  Created by Vitaliy Berg on 3/13/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBOnBack.h"

@interface VBDevToolsViewController : UITableViewController <VBOnBack>

@property (nonatomic, copy) void (^onBack)();

@end
