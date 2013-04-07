//
//  UIButton+VBStyle.m
//  UITest
//
//  Created by Vitaliy Berg on 2/19/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "UIButton+VBStyle.h"


@implementation UIButton (VBStyle)

- (void)vbSetupRadioButton
{
    [self setImage:[UIImage imageNamed:@"radiobutton.png"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"radiobutton.sh.png"] forState:UIControlStateHighlighted];
    [self setImage:[UIImage imageNamed:@"radiobutton.s.png"] forState:UIControlStateSelected];
    [self setImage:[UIImage imageNamed:@"radiobutton.sh.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
}

@end
