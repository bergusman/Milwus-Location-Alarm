//
//  UIBarButtonItem+VBStyle.m
//  UITest
//
//  Created by Vitaliy Berg on 2/19/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "UIBarButtonItem+VBStyle.h"


@implementation UIBarButtonItem (VBStyle)

- (void)vbSetupStyle
{
    [self setBackgroundImage:[UIImage imageNamed:@"nav.button.bg.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:[UIImage imageNamed:@"nav.button.bg.h.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
}

@end
