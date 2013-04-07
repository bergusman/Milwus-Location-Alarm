//
//  UINavigationBar+VBStyle.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/24/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "UINavigationBar+VBStyle.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationBar (VBStyle)

- (void)vbSetypStyle
{
    [self setBackgroundImage:[UIImage imageNamed:@"nav.bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.tintColor = [UIColor grayColor];
    
    self.layer.masksToBounds = NO;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
}

@end
