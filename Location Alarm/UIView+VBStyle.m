//
//  UIView+VBStyle.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/27/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "UIView+VBStyle.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (VBStyle)

- (void)vbSetupEditorShadow
{
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.2;
}

@end
