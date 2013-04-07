//
//  UILabel+VBStyle.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/25/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "UILabel+VBStyle.h"

@implementation UILabel (VBStyle)

- (void)vbSetupNavTitle
{
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor colorWithWhite:0.267 alpha:1.0];
    self.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.65];
    self.shadowOffset = CGSizeMake(0, 1);
    self.font = [UIFont boldSystemFontOfSize:16];
}

@end
